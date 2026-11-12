-- Steroid Pathway Trainer: research mode (event logging for an education study)
--
-- For the trainer's own Supabase project. Run it once in the SQL editor, after
-- supabase_setup.sql. Safe to run more than once. It adds new objects only and
-- does not touch public.steroid_progress.
--
-- Design
--   * Participants are identified by a study code only (for example CHP-7K3M9QX2).
--     No name or email is stored here. The code-to-person crosswalk stays with
--     the study coordinator (for example in REDCap).
--   * The tables live in their own schema, "research", which the Supabase API
--     does not expose. Browsers cannot read or write them at all.
--   * Browsers can call exactly one function, public.research_log(code, events).
--     It accepts events only for a known, consented, not-withdrawn code, checks
--     every field, skips malformed events instead of failing the batch, and
--     ignores repeats of an event it already has (so retries never double-count).
--   * Investigators read the data with the dashboard (Table editor, schema
--     "research") or the SQL editor. See the views at the bottom.

-- 1. Schema ----------------------------------------------------------------
create schema if not exists research;
revoke all on schema research from public, anon, authenticated;

-- 2. Participants ----------------------------------------------------------
-- One row per study code, added by the investigator before enrollment
-- (tools/make_study_codes.py writes the insert statements).
create table if not exists research.participants (
  code          text primary key
                check (code ~ '^[A-Z]{2,5}-[23456789ABCDEFGHJKMNPQRSTVWXYZ]{8}$'),
  site          text not null check (length(site) between 1 and 40),
  track         text check (track in ('peds','adult','other')),
  note          text check (length(note) <= 200),   -- e.g. PGY level; never a name
  created_at    timestamptz not null default now(),
  consented_at  timestamptz,                        -- set by the first consent event
  consent_ver   text,
  withdrawn_at  timestamptz                         -- set by a withdraw event; logging stops
);

-- 3. Events ----------------------------------------------------------------
create table if not exists research.events (
  id          bigint generated always as identity primary key,
  event_id    uuid        not null unique,          -- made by the browser; makes retries idempotent
  code        text        not null references research.participants (code) on delete cascade,
  visit_id    uuid        not null,                 -- one per page load
  seq         integer     not null check (seq >= 0),-- order within the visit
  client_ts   timestamptz not null,                 -- device clock
  server_ts   timestamptz not null default now(),   -- server clock
  type        text        not null check (type in
              ('consent','withdraw','visit_start','hidden','visible',
               'mode_start','round_end','answer','reveal','explore_view')),
  mode        text check (mode ~ '^[A-Za-z0-9]{1,16}$'),        -- build level id (L1..L7, X1, X2), block, name, sort, study, weak
  item        text check (item ~ '^[nedqlkx]:[A-Za-z0-9]{1,24}$'), -- same keys as the game: n:ohp, e:..., d:cyp21 ...
  ok          boolean,
  attempt     smallint check (attempt between 1 and 50),
  latency_ms  integer  check (latency_ms between 0 and 86400000),
  given       text check (given ~ '^[nz]:[A-Za-z0-9]{1,24}$'),  -- recognized wrong answer: n:<steroid> or z:<enzyme>; never raw text
  input       text check (input in ('typed','chip','choice','reveal','map')),
  detail      jsonb check (detail is null or (jsonb_typeof(detail) = 'object' and pg_column_size(detail) < 2048)),
  app_version text check (app_version ~ '^[A-Za-z0-9._-]{1,32}$')
);
create index if not exists events_code_ts on research.events (code, client_ts);

-- "create table if not exists" leaves an existing table as it was, so checks that
-- have changed since the first release are re-applied here on every run.
alter table research.events drop constraint if exists events_mode_check;
alter table research.events add  constraint events_mode_check check (mode ~ '^[A-Za-z0-9]{1,16}$');

-- Defense in depth: no table access for browser roles, and RLS on with no policies.
alter table research.participants enable row level security;
alter table research.events       enable row level security;
revoke all on all tables    in schema research from public, anon, authenticated;
revoke all on all sequences in schema research from public, anon, authenticated;

-- 4. The one entry point browsers may call ----------------------------------
-- Returns {"status": "ok" | "unknown" | "withdrawn" | "bad_request", "accepted": n, "skipped": n}.
-- Events are processed in array order, so a consent event at the front of a
-- batch enables the events behind it.
create or replace function public.research_log(p_code text, p_events jsonb)
returns jsonb
language plpgsql
security definer
set search_path = research, pg_temp
as $$
declare
  v_code text := upper(btrim(coalesce(p_code, '')));
  v_part research.participants%rowtype;
  v_ev   jsonb;
  v_type text;
  v_acc  integer := 0;
  v_skip integer := 0;
  v_n    integer;
begin
  if p_events is null or jsonb_typeof(p_events) <> 'array'
     or jsonb_array_length(p_events) = 0 or jsonb_array_length(p_events) > 200
     or v_code !~ '^[A-Z]{2,5}-[23456789ABCDEFGHJKMNPQRSTVWXYZ]{8}$' then
    return jsonb_build_object('status','bad_request','accepted',0,'skipped',0);
  end if;

  select * into v_part from research.participants where code = v_code for update;
  if not found then
    return jsonb_build_object('status','unknown','accepted',0,'skipped',0);
  end if;
  if v_part.withdrawn_at is not null then
    return jsonb_build_object('status','withdrawn','accepted',0,'skipped',0);
  end if;

  for v_ev in select value from jsonb_array_elements(p_events) with ordinality order by ordinality loop
    begin
      if jsonb_typeof(v_ev) <> 'object' then raise exception 'not an object'; end if;
      v_type := v_ev->>'type';

      -- Nothing but a consent event is accepted until the participant has consented.
      if v_part.consented_at is null and v_type is distinct from 'consent' then
        raise exception 'not consented';
      end if;

      insert into research.events
        (event_id, code, visit_id, seq, client_ts, type, mode, item, ok, attempt,
         latency_ms, given, input, detail, app_version)
      values
        ((v_ev->>'event_id')::uuid, v_code, (v_ev->>'visit_id')::uuid, (v_ev->>'seq')::integer,
         (v_ev->>'client_ts')::timestamptz, v_type, v_ev->>'mode', v_ev->>'item',
         (v_ev->>'ok')::boolean, (v_ev->>'attempt')::smallint, (v_ev->>'latency_ms')::integer,
         v_ev->>'given', v_ev->>'input',
         case when jsonb_typeof(v_ev->'detail') = 'object' then v_ev->'detail' end,
         v_ev->>'app_version')
      on conflict (event_id) do nothing;
      get diagnostics v_n = row_count;

      if v_n = 1 then
        v_acc := v_acc + 1;
        if v_type = 'consent' and v_part.consented_at is null then
          update research.participants
             set consented_at = now(), consent_ver = left(v_ev->'detail'->>'ver', 32)
           where code = v_code;
          v_part.consented_at := now();
        elsif v_type = 'withdraw' then
          update research.participants set withdrawn_at = now() where code = v_code;
          -- Later events in this batch are not accepted.
          v_skip := v_skip + (jsonb_array_length(p_events) - v_acc - v_skip);
          return jsonb_build_object('status','withdrawn','accepted',v_acc,'skipped',v_skip);
        end if;
      end if;
    exception when others then
      v_skip := v_skip + 1;   -- a malformed event is dropped; the rest of the batch still goes in
    end;
  end loop;

  return jsonb_build_object('status','ok','accepted',v_acc,'skipped',v_skip);
end;
$$;

revoke all on function public.research_log(text, jsonb) from public;
grant execute on function public.research_log(text, jsonb) to anon, authenticated;

-- 5. Views for analysis (investigators only; not reachable from browsers) ----
-- Active time: the gap before an event counts only if it is 2 minutes or less
-- and the page was not hidden in between. Change the 120 to test sensitivity.
create or replace view research.v_events_gaps as
select e.*,
       extract(epoch from client_ts - lag(client_ts) over w) as gap_s,
       lag(type) over w as prev_type
from research.events e
window w as (partition by visit_id order by seq);

create or replace view research.v_usage_by_code as
select code,
       count(*) filter (where type = 'answer')                                   as answers,
       count(*) filter (where type = 'answer' and attempt = 1)                   as first_attempts,
       round(avg((ok)::int) filter (where type = 'answer' and attempt = 1), 3)   as first_try_accuracy,
       count(distinct visit_id)                                                  as visits,
       count(distinct (client_ts at time zone 'America/New_York')::date)         as distinct_days,
       round(sum(case when gap_s <= 120 and prev_type is distinct from 'hidden'
                      then gap_s else 0 end) / 60.0, 1)                          as active_minutes,
       min(client_ts) as first_event, max(client_ts) as last_event
from research.v_events_gaps
group by code;

-- Learning curve: first-try accuracy by how many times the person had seen the item.
create or replace view research.v_learning_curve as
select code, item, ok, latency_ms, client_ts,
       row_number() over (partition by code, item order by client_ts, seq) as exposure
from research.events
where type = 'answer' and attempt = 1;

revoke all on all tables in schema research from public, anon, authenticated;

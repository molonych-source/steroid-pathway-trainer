-- Steroid Pathway Trainer: per-account progress
--
-- For the trainer's own Supabase project. Do not run it in any other project.
-- Safe to run more than once: the table is created only if missing and the
-- policies are dropped and recreated.
--
-- One row per person. The whole progress record (scores, streak days, weak
-- spots) is a single JSON document, because the game always reads and writes
-- it as a unit. No patient data and nothing clinical is stored.

-- 1. The table -------------------------------------------------------------
create table if not exists public.steroid_progress (
  -- The owner. Primary key, so each account can have exactly one row.
  user_id    uuid        primary key default auth.uid()
                         references auth.users (id) on delete cascade,
  data       jsonb       not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  -- The record must be a JSON object and stay small. The game's own record is
  -- a few kilobytes; this stops the table being used to store anything else.
  constraint steroid_progress_data_is_object check (jsonb_typeof(data) = 'object'),
  constraint steroid_progress_data_small     check (pg_column_size(data) < 65536)
);

-- 2. Row-Level Security ----------------------------------------------------
-- Without this line every signed-in user could read every other user's row.
alter table public.steroid_progress enable row level security;

-- auth.uid() is the ID of whoever is making the request. Each policy says:
-- this row is only visible or writable if it belongs to that person.
drop policy if exists steroid_progress_select_own on public.steroid_progress;
create policy steroid_progress_select_own
  on public.steroid_progress for select
  to authenticated
  using (auth.uid() = user_id);

drop policy if exists steroid_progress_insert_own on public.steroid_progress;
create policy steroid_progress_insert_own
  on public.steroid_progress for insert
  to authenticated
  with check (auth.uid() = user_id);

drop policy if exists steroid_progress_update_own on public.steroid_progress;
create policy steroid_progress_update_own
  on public.steroid_progress for update
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists steroid_progress_delete_own on public.steroid_progress;
create policy steroid_progress_delete_own
  on public.steroid_progress for delete
  to authenticated
  using (auth.uid() = user_id);

-- 3. Permissions -----------------------------------------------------------
-- Signed-in users get table access, still filtered by the policies above.
-- Signed-out visitors (the "anon" role) are granted nothing, so a logged-out
-- browser cannot read or write the table at all.
revoke all on public.steroid_progress from anon;
grant select, insert, update, delete on public.steroid_progress to authenticated;

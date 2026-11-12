# Research mode: setup, enrollment, data and analysis

Research mode logs how study participants use the trainer, for an education study
(pre-test, use of the trainer, post-test, delayed retention test). It is off for
everyone else. Tests themselves are not in the app: run them in REDCap and join on
the study code.

## 1. One-time setup (investigator)

1. Supabase dashboard → SQL editor → paste and run `2026-11-12-research-setup.sql`.
   It is safe to run again. It adds new objects only and does not touch account progress.
2. Before enrolling anyone, replace `CONSENT_HTML` in `index.html` with the IRB-approved
   wording and bump `R_CONSENT_VER` (for example to `irb-v1`). Each consent event stores
   the version that was shown.
3. Run `python3 tools/check_live.py` after the site is deployed. Expect `status unknown`
   for the fake code and `blocked` for the research read.

## 2. Enrolling participants (coordinator)

1. Make codes, one batch per site and track:
   `python3 tools/make_study_codes.py --site CHP --track peds --n 12 --out ~/study`
2. Run the `.sql` file it writes in the Supabase SQL editor.
3. Keep the `.csv` (code ↔ person) with the coordinator or in REDCap. It never goes
   into Supabase or this repository.
4. Send each participant their enrollment link (`…/?study=CODE`), or the code itself.
   They tick the consent box and press **Join study**. The header then shows
   **Study mode: ON**.
5. Tell participants: **enter the code on every device and browser you use**, and use a
   normal (not private) window. Play on a device without the code is not recorded.

Withdrawal: **Leave study** stops logging and stamps `withdrawn_at`. Rows already
recorded are kept until an investigator deletes them, following the protocol:

```sql
delete from research.events where code = 'CHP-XXXXXXXX';            -- the data
update research.participants set note = 'data deleted on request'   -- keep the audit trail
 where code = 'CHP-XXXXXXXX';
```

To re-enroll a withdrawn code: `update research.participants set withdrawn_at = null where code = '…';`

## 3. What is recorded (`research.events`)

| Column | Meaning |
|---|---|
| `code` | Study code. The only identifier. |
| `visit_id`, `seq` | One visit per page load, and the event's order within it |
| `client_ts`, `server_ts` | Device clock and server clock. Use `client_ts` for order within a visit and `server_ts` to check the device clock. |
| `type` | `consent`, `withdraw`, `visit_start`, `hidden`, `visible`, `mode_start`, `round_end`, `answer`, `reveal`, `explore_view` |
| `mode` | `L1`–`L7`, `X1`, `X2` (build levels), `weak` (drill weak spots), `block` (CAH: break the pathway), `name` (name the defect), `sort` (sort it), `study` (explore) |
| `item` | `n:` steroid slot, `e:` enzyme step, `d:` deficiency, `q:` defect card, `l:` enzyme location, `k:` steroid class, `x:` enzyme card opened during a build level |
| `ok`, `attempt` | Correct or not, and which try (1 = first try). Build levels allow 3 tries, name mode 2; block and sort allow 1. |
| `latency_ms` | Time from the prompt appearing, or from the previous try, to this answer. Time with the page hidden is excluded. |
| `given` | For a wrong answer the game recognizes: `n:<steroid>` or `z:<enzyme>`. Unrecognized text is **not** stored. |
| `input` | `typed`, `chip` (word bank), `choice` (sort), `map` (block), `reveal` |
| `detail` | Block mode: `up` / `down` (marks), `miss` (wrongly marked steroids), `mc` / `xx` / `xy` (phenotype menus correct or not), `nw` / `pw` (counts). Sort: `pick` (index of option chosen). Rounds: `n`, `pct`, `secs`. |
| `app_version` | `R_APP` in `index.html`. Bump it when scoring or content changes. |

`research.participants` holds the site, the track (peds, adult or other), `consented_at`,
`consent_ver` and `withdrawn_at`.

## 4. Getting the data out

Dashboard → Table editor → schema `research` → export CSV. Or use the SQL editor:

```sql
select * from research.v_usage_by_code;      -- one row per participant
select * from research.v_learning_curve;     -- first tries, numbered by exposure to each item
select e.* from research.events e
 join research.participants p using (code)
 where p.withdrawn_at is null;               -- raw events, withdrawn participants excluded
```

`v_usage_by_code` gives answers, first-try accuracy, visits, distinct days (in the
America/New_York time zone) and **active minutes**. A gap between events counts as
active only if it is 2 minutes or less and the page was not hidden in between. Change
the `120` in the view to test sensitivity, and **pre-specify the primary usage metric**
in the protocol.

## 5. Analysis notes and known limits

- **Undercounting.** Play on a device without the code is invisible. Ask about other
  devices on the post-test survey, and report `count(distinct visit_id)`.
- **Response time** is device time between screen updates. It is precise to
  milliseconds but includes reading time. Use medians or log-transform.
- **Repeated items.** Items repeat across rounds and the drill favours weak items, so
  exposure differs by person. Use `v_learning_curve` with mixed models (random effects
  for person and item).
- **Mode mix differs by person.** Report it rather than pooling accuracy across modes.
- **Versions.** Filter or stratify by `app_version` if content changes mid-study.
- **Privacy.** Events carry only the code. Check the IRB's rules on storing study data
  in Supabase, a US-hosted vendor, before enrolling; some institutions require an
  institutional data store or a data use agreement.

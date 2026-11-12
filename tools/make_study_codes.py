"""Make study codes for research mode.

Writes two files into the folder you name (default: the current folder):
  <SITE>-codes-<date>.csv   for the study coordinator: code, site, track, enrollment link.
                            Add the participant's name here, or in REDCap, never in Supabase.
  <SITE>-codes-<date>.sql   paste into the Supabase SQL editor to register the codes.

Run:  python3 tools/make_study_codes.py --site CHP --track peds --n 12
      python3 tools/make_study_codes.py --site UPMC --track adult --n 10 --out ~/study

Codes are random (30-symbol alphabet with no 0/O, 1/I/L or U; 8 symbols, about 6.6e11
possibilities), so one cannot be guessed from another. Keep the CSV out of this repository.
"""
import argparse, csv, datetime, os, re, secrets

ALPHABET = "23456789ABCDEFGHJKMNPQRSTVWXYZ"  # must match R_CODE_RE in index.html and the SQL check
SITE_URL = "https://molonych-source.github.io/steroid-pathway-trainer/"

ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
ap.add_argument("--site", required=True, help="2-5 capital letters, e.g. CHP or UPMC")
ap.add_argument("--track", required=True, choices=["peds", "adult", "other"])
ap.add_argument("--n", type=int, required=True, help="how many codes (1-500)")
ap.add_argument("--out", default=".", help="folder for the two output files")
a = ap.parse_args()
if not re.fullmatch(r"[A-Z]{2,5}", a.site):
    ap.error("--site must be 2 to 5 capital letters")
if not 1 <= a.n <= 500:
    ap.error("--n must be between 1 and 500")

codes = set()
while len(codes) < a.n:
    codes.add(a.site + "-" + "".join(secrets.choice(ALPHABET) for _ in range(8)))
codes = sorted(codes)

out = os.path.expanduser(a.out)
os.makedirs(out, exist_ok=True)
stem = os.path.join(out, f"{a.site}-codes-{datetime.date.today().isoformat()}")
for ext in (".csv", ".sql"):
    if os.path.exists(stem + ext):
        raise SystemExit(f"{stem + ext} already exists; not overwriting it. Move it or choose another --out.")

with open(stem + ".csv", "w", newline="") as f:
    w = csv.writer(f)
    w.writerow(["code", "site", "track", "enrollment_link", "participant (coordinator only)"])
    for c in codes:
        w.writerow([c, a.site, a.track, f"{SITE_URL}?study={c}", ""])

with open(stem + ".sql", "w") as f:
    f.write("-- Register study codes. Safe to run twice: existing codes are left as they are.\n")
    f.write("insert into research.participants (code, site, track) values\n")
    f.write(",\n".join(f"  ('{c}', '{a.site}', '{a.track}')" for c in codes))
    f.write("\non conflict (code) do nothing;\n")

print(f"{len(codes)} codes\n  {stem}.csv  (coordinator)\n  {stem}.sql  (run in the Supabase SQL editor)")

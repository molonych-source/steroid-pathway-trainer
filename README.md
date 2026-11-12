# Steroid Pathway Trainer

A single-page study game for adrenal steroidogenesis and congenital adrenal
hyperplasia: rebuild the pathway from memory, then break it one enzyme at a time.

A study aid for clinicians and trainees. Not clinical guidance.

## What is here

- `index.html`: the whole game. It has no build step and no dependencies for
  guest play, and it works offline when opened as a file.
- `supabase_setup.sql`: the one database table used for optional accounts, with
  row-level security so each person can only read and write their own row.

## Accounts

Accounts are optional. Guests keep their progress in their own browser. Signing
in saves progress to this site's own Supabase project, set by `SUPA_URL` and
`SUPA_KEY` near the "ACCOUNTS AND CLOUD SAVE" section of `index.html`. The key
there is a publishable key, which is meant to be public: row-level security in
`supabase_setup.sql` is what keeps each person's row private.

An account stores an email address and game progress only.

## Source of truth

This repository is the only copy. Edit `index.html` here, commit, and push to
`main`; the GitHub Actions workflow in `.github/workflows/pages.yml` publishes
it to GitHub Pages within a minute.

- `assets/`: the logo as SVG and PNG.
- `preview.png` and `icon-180.png`: the link preview card and home-screen icon.
- `tools/make_images.py`: regenerates the logo, preview card and icon.
- `tools/check_live.py`: smoke check of the published site, including that a
  signed-out browser cannot read the progress table.
- `googlea06cf89ef8c2e172.html`: proves site ownership to Google. Keep it.

## Sources

Endotext, Congenital Adrenal Hyperplasia (Speiser and White); the Wikimedia
Commons diagram File:Steroidogenesis.svg; PubChem for structures; and the
papers listed in the page footer.

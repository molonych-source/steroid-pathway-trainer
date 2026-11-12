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

The working copy lives in the author's notes vault as
`Generated Documents/Steroid Pathway Trainer.html`. This `index.html` is a
published copy of that file: edit the vault copy, then copy it here.

## Sources

Endotext, Congenital Adrenal Hyperplasia (Speiser and White); the Wikimedia
Commons diagram File:Steroidogenesis.svg; PubChem for structures; and the
papers listed in the page footer.

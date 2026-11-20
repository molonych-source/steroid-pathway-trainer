# Steroid Pathway Trainer: pre/post study instrument

Draft, 2026-11-20. For pediatric and adult endocrinology attendings, fellows and
APPs. Two Microsoft Forms quizzes, two weeks apart, linked by an anonymous study
code that the app shows.

## 1. Design in one paragraph

Single-group pre/post study. Participants complete a baseline survey (comfort
plus five knowledge items), use the trainer freely for 14 days, then complete a
follow-up survey with parallel knowledge items, the same comfort items, their
active minutes of play as recorded by the app, and feedback. Primary outcome:
change in knowledge score. Secondary: change in comfort, and the association
between active minutes and post-test knowledge, adjusted for baseline.

## 2. Participant flow

1. The invitation email contains two links: the study link to the app
   (`https://molonych-source.github.io/steroid-pathway-trainer/?study=1`) and
   the pre-survey.
2. The participant opens the study link **first**. The home screen shows a
   "Research study" box with an 8-character code (e.g. `K7QM-3XPD`) and active
   minutes (0 at enrolment).
3. They enter that code in the pre-survey and submit it **before playing**.
4. They play as much or as little as they like for 14 days, on the **same
   device and browser** (the code and minutes are stored in that browser only).
5. On day 14 the study team emails the post-survey link. The participant opens
   the app, copies the code and the minutes shown, and completes the
   post-survey.

What the app records, and where: the code, the enrolment time, and active
seconds per calendar day, in that browser's local storage only. None of it is
sent to the server or tied to an account or email address. Time counts only
while the tab is visible and the participant has clicked, typed, scrolled or
touched within the last 90 seconds. Clearing browser data or using a private
window loses the code; the box warns when storage is blocked.

## 3. Pre-survey (Microsoft Forms, "New Quiz")

### Section A: Study code and background

| # | Question | Type | Options |
|---|---|---|---|
| A1 | Study code shown in the app (format XXXX-XXXX) | Text, required | |
| A2 | Specialty | Choice | Pediatric endocrinology · Adult endocrinology · Combined (med-peds) endocrinology |
| A3 | Role | Choice | Attending physician · Fellow · Nurse practitioner · Physician assistant |
| A4 | If fellow, year of fellowship | Choice | 1 · 2 · 3 · 4 or more · Not applicable |
| A5 | Years in endocrinology practice after training | Choice | Still in training · <5 · 5–10 · 11–20 · >20 |
| A6 | Patients with CAH you see in a typical month | Choice | 0 · 1–2 · 3–5 · >5 |
| A7 | Have you used Steroid Pathway Trainer before today? | Choice | No · Yes, once or twice · Yes, regularly |

### Section B: Comfort (identical at pre and post)

Stem: "How comfortable are you with each of the following?"
Likert scale, 1 = Not at all comfortable, 2 = Slightly, 3 = Moderately,
4 = Very, 5 = Extremely comfortable. No points.

| # | Item |
|---|---|
| C1 | Drawing adrenal steroidogenesis from cholesterol to cortisol, aldosterone and the androgens from memory |
| C2 | Predicting which precursors rise and which products fall when a given enzyme is deficient |
| C3 | Distinguishing the forms of CAH by blood pressure, electrolytes and genital phenotype in 46,XX and 46,XY individuals |
| C4 | Interpreting a cosyntropin-stimulated adrenal steroid profile |
| C5 | Teaching the steroid pathway to trainees or families |

### Section C: Knowledge (pre version)

Single answer, 1 point each. "Not sure" scores 0. Keep options in the order
shown (do not turn on Shuffle options, so "Not sure" stays last).

**K1.** Which enzyme converts progesterone to 11-deoxycorticosterone (DOC)?
- A. CYP11B1 (11β-hydroxylase)
- **B. CYP21A2 (21-hydroxylase)**
- C. CYP17A1 (17α-hydroxylase)
- D. HSD3B2 (3β-HSD type 2)
- E. Not sure

**K2.** Which enzyme catalyzes the final step of aldosterone synthesis,
18-hydroxycorticosterone to aldosterone?
- A. CYP11B1 (11β-hydroxylase)
- B. CYP21A2 (21-hydroxylase)
- **C. CYP11B2 (aldosterone synthase)**
- D. CYP11A1 (side-chain cleavage)
- E. Not sure

**K3.** Besides 17-OHP and androstenedione, which steroid is elevated in
classic 21-hydroxylase deficiency?
- **A. 21-Deoxycortisol**
- B. 11-Deoxycortisol
- C. 11-Deoxycorticosterone (DOC)
- D. Corticosterone
- E. Not sure

**K4.** A 15-year-old with a 46,XX karyotype has primary amenorrhea, absent
breast development, hypertension and hypokalemia. Which deficiency best
explains this?
- A. 11β-hydroxylase (CYP11B1)
- **B. 17α-hydroxylase/17,20-lyase (CYP17A1)**
- C. Aromatase (CYP19A1)
- D. Nonclassic 21-hydroxylase (CYP21A2)
- E. Not sure

**K5.** Serum DHEA is markedly elevated while androstenedione is low. Which
deficiency does this pattern suggest?
- A. 17,20-lyase (CYP17A1)
- B. 21-hydroxylase (CYP21A2)
- **C. 3β-HSD type 2 (HSD3B2)**
- D. P450 oxidoreductase (POR)
- E. Not sure

End-of-form message: "Thank you. Please do not look up these questions; the
follow-up survey in two weeks will ask similar ones. You can start using the
trainer now."

## 4. Post-survey (Microsoft Forms, separate "New Quiz")

### Section A: Study code and use

| # | Question | Type |
|---|---|---|
| P1 | Study code shown in the app | Text, required |
| P2 | Active minutes shown in the app's Research study box | Text, restriction: Number |
| P3 | Active days shown in the app's Research study box | Text, restriction: Number |
| P4 | Did you use the trainer on more than one device or browser? | Choice: No · Yes (if yes, give the other code and minutes in P5) |
| P5 | Other code(s) and minutes, if any | Text, optional |
| P6 | If the app's minutes are missing, estimate your total time | Choice: <15 min · 15–30 · 31–60 · 1–2 h · >2 h |
| P7 | In the past two weeks, did you study steroid pathways or CAH with any other resource (reading, lectures, board review)? | Choice: No · Yes, briefly · Yes, substantially |
| P8 | Did you look up the answers to the first survey's questions? | Choice: No · Yes |

### Section B: Comfort

C1–C5 exactly as in the pre-survey.

### Section C: Knowledge (post version, same concepts, reworded)

**K1′.** Which enzyme converts 17-hydroxyprogesterone to 11-deoxycortisol?
- A. CYP17A1 (17α-hydroxylase)
- B. CYP11B2 (aldosterone synthase)
- **C. CYP21A2 (21-hydroxylase)**
- D. CYP11B1 (11β-hydroxylase)
- E. Not sure

**K2′.** Which enzyme 18-hydroxylates corticosterone in the zona glomerulosa?
- **A. CYP11B2 (aldosterone synthase)**
- B. CYP11B1 (11β-hydroxylase)
- C. CYP11A1 (side-chain cleavage)
- D. CYP17A1 (17α-hydroxylase)
- E. Not sure

**K3′.** A 46,XX infant has salt wasting and virilized genitalia. Other than
17-OHP and androstenedione, which steroid do you expect to be elevated?
- A. Aldosterone
- B. Corticosterone
- C. 11-Deoxycortisol
- **D. 21-Deoxycortisol**
- E. Not sure

**K4′.** An infant with a 46,XY karyotype has typical female external
genitalia and later develops hypertension and hypokalemia. Which deficiency
best explains this?
- A. 3β-HSD type 2 (HSD3B2)
- B. StAR (lipoid CAH)
- C. 11β-hydroxylase (CYP11B1)
- **D. 17α-hydroxylase/17,20-lyase (CYP17A1)**
- E. Not sure

**K5′.** 17-Hydroxypregnenolone is markedly elevated relative to
17-hydroxyprogesterone. Which deficiency does this pattern suggest?
- A. 21-hydroxylase (CYP21A2)
- B. 11β-hydroxylase (CYP11B1)
- **C. 3β-HSD type 2 (HSD3B2)**
- D. 17α-hydroxylase (CYP17A1)
- E. Not sure

### Section D: Feedback

| # | Question | Type |
|---|---|---|
| F1 | How useful was the trainer for your understanding of steroid pathways? | Likert 1–5 (Not at all … Extremely) |
| F2 | How likely are you to recommend it to a colleague or trainee? | Net Promoter (0–10) |
| F3 | Which parts did you use? | Multiple answers: Build the map · Block the enzyme · Name the defect · Sort it · Explore the map · Drill weak spots |
| F4 | What was most helpful? | Long text |
| F5 | What would you change or add? | Long text |
| F6 | Did you notice any content you believe is wrong? Please describe. | Long text |

## 5. Answer key and scoring

| Item | Pre | Post | Concept tested | Key reasoning |
|---|---|---|---|---|
| K1 | B | C | 21-hydroxylation step | CYP21A2 converts progesterone→DOC and 17-OHP→11-deoxycortisol |
| K2 | C | A | Aldosterone synthase | CYP11B2 carries out 11β-, 18-hydroxylation and 18-oxidation in the ZG |
| K3 | A | D | Shunt product of a 21-OH block | Accumulated 17-OHP is 11β-hydroxylated by CYP11B1 to 21-deoxycortisol; every distractor needs 21-hydroxylation and is low |
| K4 | B | D | CYP17A1 deficiency phenotype | No sex steroids (XX: no puberty; XY: female external genitalia) plus DOC/corticosterone excess (hypertension, hypokalemia). CYP11B1 deficiency virilizes; aromatase deficiency is not hypertensive |
| K5 | C | C | Δ5 to Δ4 block | 3β-HSD2 deficiency raises Δ5 steroids (DHEA, 17-OH-pregnenolone) relative to Δ4 |

- Knowledge score: 0–5 at each time point. "Not sure" or blank = 0.
- Comfort score: sum of C1–C5, range 5–25. Report items individually too.

Sources: Endotext, Congenital Adrenal Hyperplasia (Speiser & White, updated
January 20, 2026); the same references cited in the app footer.

## 6. Microsoft Forms setup checklist

- Create each survey with **New Quiz** so the knowledge items are scored
  automatically. Mark the correct option and set 1 point; Likert, text and
  background questions get no points.
- **Settings → Who can fill out this form: "Anyone can respond".** With an
  organization-only setting Forms records name and email, which breaks
  anonymity.
- Turn **off** "Show results automatically" (or "Show correct answers and
  points" in newer versions) on **both** quizzes. If respondents see the
  answers on the pre-survey, the post-survey measures memory of the
  pre-survey.
- Turn off "One response per person" (it requires sign-in).
- Mark A1 and P1 required. Forms cannot validate the code's format, so check
  codes when cleaning data (case-insensitive; the app uses no 0, O, 1, I or L).
- Forms cannot send the day-14 survey automatically. Options: a scheduled
  email from the study mailbox, or a Power Automate flow triggered by each
  pre-survey response with a 14-day delay. Because the forms are anonymous,
  the reminder list has to come from the invitation list, not the responses.
- Export each form to Excel and join the two sheets on the study code.

## 7. Analysis plan

- **Primary:** paired change in knowledge score, Wilcoxon signed-rank test.
  Report median (IQR) pre and post and the proportion correct per item.
- **Secondary:** paired change in comfort score (Wilcoxon), per-item comfort.
- **Dose–response:** linear regression of post knowledge score on pre knowledge
  score, log(active minutes + 1), specialty and role (ANCOVA form, which handles
  ceiling and regression to the mean better than a raw change score). Also
  report the Spearman correlation between active minutes and knowledge change.
- **Calibration:** Spearman correlation between comfort and knowledge at
  baseline (are confidence and knowledge aligned?), and whether it changes.
- **Subgroups:** pediatric vs adult specialty; attending vs fellow vs APP.
  Descriptive only unless numbers allow.
- **Sensitivity:** exclude P7 = "substantially" and P8 = "Yes"; analyze
  completers vs all baseline respondents for attrition bias.
- **Sample size:** detecting ρ = 0.4 between minutes and gain (α 0.05, power
  0.8) needs about 47 completers; a moderate paired effect (d = 0.5) needs about
  34. With 30–50% loss at two weeks, aim to enrol 80–100.
- Missing app minutes: use P6 category midpoints, flagged, and run the
  analysis with and without them.

## 8. Limitations to state up front

- No control group: gains may reflect the pre-test itself, outside study, or
  time.
- Five items per time point is a coarse scale; attendings may start near the
  ceiling.
- Parallel item forms are matched by concept, not psychometrically validated.
- Voluntary participation selects for interested clinicians.
- The investigator developed the app; disclose this in any abstract.

## 9. IRB summary paragraph (adapt to your institution's form)

> This is a prospective, single-group educational study of a free web-based
> learning game about adrenal steroidogenesis. Adult endocrinology and pediatric
> endocrinology attendings, fellows and advanced practice providers will be
> invited by email to complete an anonymous baseline survey (background, five
> comfort ratings, five multiple-choice knowledge questions), use the game at
> their discretion for two weeks, and complete an anonymous follow-up survey with
> parallel questions, self-reported usage and feedback. Surveys are hosted in
> Microsoft Forms with anonymous responses; no names, email addresses or
> institutional identifiers are collected. Responses are linked only by a random
> code generated and stored in the participant's own browser by the game, which
> also records active minutes of use locally; this information is not
> transmitted to any server. Participation is voluntary, there is no
> compensation, and participants may stop at any time. Risk is minimal. We
> request a determination of exempt status under 45 CFR 46.104(d)(2).

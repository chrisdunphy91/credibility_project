# Evidence Review Protocol v0.2

Working draft, October 2026. Governing document for every claim page. CLAUDE.md defers to this file; where they disagree, this file wins.

**Changelog.**

- **v0.2 (2026-10-21).** §3.2: tested statements are written in the direction of the public claim, so "Supported" means the claim holds; the example now tests whether foreign sellers absorbed most of the tariff. §11.1: the certainty combining rule is replaced by a points rule (Partial = 1, Weak = 2), scored separately for each verdict scope.
- **v0.1 (October 2026).** First working draft.

## Status and how to read this

This is a working draft (v0.2) for internal discussion, not a published protocol. Every rule below is a proposal to be argued with. Items marked **[decide]** are open choices; items marked **[placeholder]** need a real value before launch.

The protocol is versioned. A published claim page always names the protocol version it was reviewed under. A change to any rule in sections 3 through 12 is a new minor version (v1.1, v1.2); a change that would alter existing verdicts is a new major version and triggers re-review of affected pages (section 14).

Sources for the design choices here: the Royal Society's principles for evidence synthesis for policy, the GRADE approach used in Cochrane reviews, J-PAL's Policy Insights method, and the RAISE 2026 recommendations on responsible AI in evidence synthesis. Links are in Appendix C.

## 1. Purpose and scope

This protocol governs how The Credibility Project turns a public policy claim into a published, graded evidence page. Its job is to make every judgment in that process visible, attributable, and repeatable by someone who disagrees with us.

**In scope:** empirical claims about the effects of policy where the evidence base is quantitative causal research (experiments, natural experiments, difference-in-differences, regression discontinuity, instrumental variables, synthetic control, structural models estimated on policy variation). The author's field does not matter; the evidence type does. Examples: who bears the cost of tariffs; whether minimum wage increases reduce employment; whether zoning reform lowers rents; whether interior immigration enforcement reduces crime.

**Out of scope:** value claims (whether a policy is good), predictions about events with no evidence base, claims about individual politicians, clinical and biomedical efficacy claims, natural-science claims, constitutional and legal questions, foreign policy, and anything whose evidence is polling or case studies. Topics where the literature is too thin to grade get a "cannot be graded" page (section 10), not silence.

**Unit of analysis:** the claim, not the topic. A topic page ("Trade and tariffs") is a container for claim pages. Each claim page tests one causal statement, or two when the evidence base is shared (section 3.4).

## 2. Principles

Five commitments every page must honor. If a rule later in this document conflicts with one of these, the principle wins and the rule gets fixed.

1. **Pre-commitment.** The question, search strategy, and inclusion criteria are fixed and time-stamped before any study is read (section 4). We cannot choose criteria to fit a preferred answer because the criteria exist first.
2. **Transparent judgment, not mechanical judgment.** Grading uses rubrics with stated thresholds, applied by named humans, with the rationale published. We do not claim an algorithm produced the verdict, because none could do it well.
3. **Everything auditable.** The search log, the screening decisions, the extracted study table, and each reviewer's ratings are published with the page. A critic can rerun the search and reproduce the table.
4. **Disagreement is a finding.** Where the literature disagrees, the page says so, classifies why (data, method, time horizon, scope, or values), and presents the strongest opposing case.
5. **Separation of evidence and opinion.** Signed expert commentary is welcome and clearly labeled, and it never changes the evidence page. The review is written first; commentary responds to it.

## 3. Claim formulation

Turning a public claim into a testable statement is the step most exposed to bias, so it has its own rules and its own audit trail. Every page shows the public claim, the tested statement, and the mapping between them.

**3.1 Source the public claim.** Record at least two verbatim instances of the claim as it circulates (a speech, a bill summary, a widely shared post), with links and dates. The page quotes the most common phrasing.

**3.2 Write the tested statement in PECOS form.** Population (whose outcomes), Exposure (the policy, with a dose where it matters), Comparison (what it is compared against), Outcome (what is measured, with a magnitude where the claim implies one), Setting (country and period). The tested statement is written in the direction of the public claim, so that "Supported" means the claim holds and "Not supported" means it does not. Example, for the claim that foreign countries pay for U.S. tariffs: *Foreign sellers (P) of goods subject to the 2018 and 2025 U.S. tariffs (E), relative to sellers of similar untariffed goods (C), cut their prices by enough to absorb most of the tariff, so that U.S. import prices rose by much less than the tariff rate (O), in the first 24 months after imposition (S).*

**3.3 Steelman rule.** The tested statement is the strongest reasonable version of what proponents mean, not the weakest. If a claim has a strong and a weak reading, test the strong one and note the weak one. A page that tests a strawman fails review.

**3.4 Splitting bundled claims.** A public claim that bundles several causal statements ("tariffs protect jobs and are paid by foreigners") is split. When the component statements share an evidence base (immigration's effect on native employment and on native wages), they go on **one page with one verdict per statement**. When the evidence bases are disjoint (whether deportations reduce crime versus whether immigrants commit more crime), each gets **its own page**, and the pages link both ways.

**3.5 Sign-off.** The mapping from public claim to tested statement is approved by two reviewers, at least one of whom is not the lead reviewer, before pre-registration. **[decide]** whether an editorial board member must also approve for high-salience claims.

## 4. Pre-registration

Before the first search runs, the review is registered on a public, time-stamped platform (OSF Registries **[decide]**, or a signed commit in a public repository). The registration is immutable; changes after it are logged as amendments with reasons.

The registration contains, using the template in Appendix A:

- The public claim and the tested PECOS statement(s) (section 3)
- The search strategy: sources, query strings, date range, language, grey-literature policy (section 5)
- Inclusion and exclusion criteria (section 6)
- The extraction fields (Appendix B)
- The reviewers assigned, with conflict-of-interest statements
- The protocol version in force

A page may not be published if its registration is missing or post-dates the search. Amendments are allowed (a search that returns nothing may need a wider date range) but each is dated, explained, and shown on the page's Methods section.

## 5. Search strategy

The search is the thing a critic can rerun, so it is specified fully and logged fully. The prompt used to drive an AI search agent is one input to the strategy and is published with it; it is not the strategy itself.

**5.1 Sources.** Every review searches the core set; topic-specific sources are added at registration.

| Source | Coverage | Access |
| --- | --- | --- |
| OpenAlex | Journals and working papers, citation graph | Open API |
| NBER Working Papers | Economics working papers | Open |
| SSRN | Working papers, social science | Open index |
| EconLit **[decide]** | Journal articles, economics | Subscription |
| Google Scholar | Catch-all, forward citations of key studies | Manual, logged |
| Existing systematic reviews and meta-analyses | Seed list for backward citation search | Any of the above |

**5.2 Query construction.** Queries are built from the PECOS terms, with synonyms listed in the registration. Each query string, source, date of execution, and result count is recorded in the search log.

**5.3 Date range.** Default: 2000 to present. Earlier work is included when it is foundational and still cited in current reviews. The range is stated per claim at registration.

**5.4 Working papers and grey literature.** Working papers from recognized series (NBER, CEPR, IZA, Fed system, IMF, World Bank) are eligible and flagged as not peer-reviewed. Think-tank and advocacy reports are recorded but excluded from grading unless they contain original causal analysis with data available. **[decide]** the recognized-series list.

**5.5 Citation chasing.** For every included study, the search checks its reference list (backward) and papers citing it (forward) for eligible studies missed by the queries. Studies found this way are logged with the study that led to them.

**5.6 AI-assisted search.** An agent may run queries, de-duplicate, and propose candidates. Its prompt, model, and date are logged. Nothing it returns enters the included set without human screening (sections 6 and 16).

**5.7 The search log** is published with the page: every query, every source, every result count, and the de-duplicated total that went to screening.

## 6. Screening: inclusion and exclusion

Screening happens in two passes, title-and-abstract then full text, and every exclusion is recorded with its reason. Two screeners work independently on the full-text pass; disagreements are resolved by discussion and logged.

**6.1 Included if all of the following hold:**

- The study estimates a causal effect of the exposure on the outcome named in the PECOS statement, or a parameter the statement depends on (for example, pass-through).
- It uses an identification strategy that can in principle separate the policy's effect from confounders: randomized or natural experiment, difference-in-differences, regression discontinuity, instrumental variables, synthetic control, event study, or a structural model estimated on policy variation.
- It is peer-reviewed, or a working paper from a recognized series (section 5.4).
- It reports enough to extract an effect size and a measure of uncertainty, or the authors supply them on request.
- Setting is within the registered scope (section 3.2).

**6.2 Excluded, with the reason recorded:**

- Descriptive, correlational, or opinion pieces (reason: no causal design)
- Simulations with no estimation on policy variation (reason: model-only), though these may be cited in section 2 of a page as theory
- Studies of a different exposure, outcome, or population (reason: off-PECOS)
- Duplicates and superseded versions (reason: duplicate; the latest version is kept)
- Retracted studies, or studies with a failed published replication where the authors have not responded (reason: integrity)

**6.3 Screening record.** The page publishes the counts at each stage (records found, after de-duplication, screened on abstract, screened on full text, included) and a downloadable list of full-text exclusions with reasons.

## 7. Data extraction and the study table

Every included study is reduced to one row in a structured table, and that table is the public product of the review. The synthesis (section 9) is written from the table, not from memory of the papers.

Extraction fields are fixed in Appendix B. The core ones: citation and link, publication status, design, data source, setting and period, sample, the exposure as implemented, the comparison, the primary outcome, the point estimate with its units, the standard error or confidence interval, the direction relative to the tested statement, and free-text notes on limitations.

**Rules:**

- An AI assistant may draft the extraction. A human reviewer verifies every numeric field against the paper before the row is accepted, and initials the row.
- Where a study reports several specifications, the authors' preferred specification is extracted, and the range across specifications is noted.
- Where units differ across studies (percent, elasticity, dollars), the table records the native unit and, where a defensible conversion exists, a harmonized unit with the conversion stated.
- Missing values are left blank, never imputed. A study that cannot supply an effect size and uncertainty is retained in the table but flagged as not gradeable.

The table is published as a CSV with a version number. The rendered table on the page and the downloadable CSV are the same file. Changes to it after publication go through the correction process (section 14).

## 8. Study quality and relevance tiers

Studies are not weighted numerically. Each gets a quality tier and a relevance tier, both shown in the public table with a one-line reason. Tiers determine how much a study can move the verdict and the certainty grade (sections 10 and 11).

**8.1 Quality tier** reflects how well the design isolates the policy's effect.

| Tier | Typical designs | Conditions |
| --- | --- | --- |
| A | Randomized experiment; sharp natural experiment with clean control group; regression discontinuity at a policy threshold | Identification assumptions stated and tested; pre-trends shown where applicable; results robust to stated alternatives |
| B | Difference-in-differences, event study, synthetic control, instrumental variables | Credible but assumption-dependent; parallel trends or instrument validity argued, not demonstrated |
| C | Structural model estimated on policy variation; panel fixed effects with rich controls | Conclusions depend materially on modeling choices |
| D | Cross-sectional or time-series correlation with controls | Retained in the table for completeness; cannot move a verdict |

**8.2 Relevance tier** reflects how close the study's setting is to the claim's.

| Tier | Meaning |
| --- | --- |
| 1 | Same country, same policy instrument, within 15 years |
| 2 | Same country, similar instrument or earlier period; or a close peer economy, same instrument |
| 3 | Different setting that illuminates mechanism but transfers with caution |

**8.3 Modifiers**, recorded in the notes column and applied to the quality tier:

- Not peer-reviewed: tier is provisional and shown with an asterisk.
- Replicated independently with consistent results: noted as a strength.
- Published replication failed or materially disagreed: tier is lowered one step and both studies are shown.
- Author conflict of interest disclosed (industry or advocacy funding): noted; tier unchanged unless design is affected.

Two reviewers assign tiers independently. Disagreements are resolved by discussion; unresolved ones go to the editorial board and the page shows both ratings.

## 9. Synthesis

Synthesis answers one question: taken together, what do the Tier A and B, Relevance 1 and 2 studies say about the tested statement? Lower-tier studies are discussed only to explain disagreement or fill a gap, and the page says when that happens.

**9.1 Quantitative pooling** (meta-analysis) is used only when at least three studies estimate the same parameter in comparable units with comparable designs. The pooling method, heterogeneity statistic, and a forest plot are published. For most policy claims this condition will not hold, and the page says so rather than forcing a pooled number.

**9.2 Structured narrative synthesis** is the default. It proceeds in a fixed order so that it can be checked against the table:

1. Direction: how many eligible studies find an effect in the direction the claim predicts, against it, or null.
2. Magnitude: the range of point estimates among Tier A and B studies, and whether they cluster.
3. Heterogeneity: whether differences in findings track differences in setting, period, design, or data, and which.
4. Mechanism: whether the findings are consistent with the theory in section 2 of the page, and where they are not.
5. Gaps: what the eligible studies do not cover (populations, horizons, outcomes).

**9.3 The synthesis text is drafted from the table** by the lead reviewer. It cites each study by its table row. Any statement in the synthesis that cannot be traced to a row or to the pre-registered theory section is removed in review.

## 10. Verdict rubric

The verdict says what the eligible evidence shows about the tested statement. It is one of four categories, assigned against stated thresholds by two reviewers independently, with the rationale published. It is never computed by formula alone.

| Verdict | Threshold (applied to Tier A and B, Relevance 1 and 2 studies) |
| --- | --- |
| **Supported** | At least three eligible studies; at least 80% find effects in the claimed direction; no Tier A study finds the opposite; magnitudes are consistent with the claim as stated (not merely the sign) |
| **Not supported** | At least three eligible studies; at least 80% find null or opposite effects, or effects far smaller than the claim requires; no Tier A study supports the claim |
| **Mixed** | At least three eligible studies and neither threshold above is met; the page must classify the disagreement (section 12) |
| **Cannot be graded** | Fewer than three eligible studies, or the eligible studies cannot supply effect sizes; the page publishes what exists and says what evidence would be needed |

**10.1 Magnitude matters.** A claim can be directionally right and still not supported if the size is wrong. "Tariffs create manufacturing jobs" is not supported by a study finding 1,800 jobs at $800,000 each if the claim as circulated implies large-scale job creation. The tested statement (section 3.2) carries the magnitude so this can be judged.

**10.2 The 80% threshold** is a floor for a clean verdict, not a vote count. Three high-quality studies agreeing outweigh six Tier B studies split evenly, and the rationale must say why. **[decide]** the exact threshold; 80% is a starting proposal.

**10.3 Rationale.** Each reviewer writes a rationale of 150 to 300 words tracing the verdict to table rows. Both rationales are published. If the reviewers disagree on the verdict after discussion, the editorial board decides and all three rationales are published.

**10.4 Vocabulary [decide].** "Supported / Not supported" reads like a fact-checker. Alternatives: "Consistent with the evidence / Contradicted by the evidence," or a plain-language sentence verdict with the category as a tag. Choose before launch and keep it fixed.

**10.5 Policy generations.** Where a claim refers to a current policy but the evidence covers an earlier generation of it (2018 tariffs versus 2025 tariffs; Secure Communities versus 2025 enforcement), the page carries one verdict per generation. The headline verdict is for the generation the evidence covers; the current generation is stated immediately beneath it, usually as "Cannot be graded" with the evidence needed.

## 11. Certainty rubric

Certainty says how confident we are that the verdict would survive more and better evidence. It is graded separately from the verdict, so a page can read "Not supported, low certainty." Five criteria are each scored Strong, Partial, or Weak, and the grade follows from the pattern of scores.

| Criterion | Strong | Partial | Weak |
| --- | --- | --- | --- |
| Number and quality of causal studies | 3+ Tier A, or 5+ Tier A/B, from independent teams | 3 to 4 Tier A/B, or dependence on one team or one dataset | Fewer than 3, or mostly Tier C |
| Consistency of direction | 90%+ agree | 70 to 90% agree | Below 70% |
| Consistency of magnitude | Tier A/B estimates cluster within a range narrow enough that policy conclusions do not change across it | Estimates vary, but the variation is explained by setting or design | Estimates vary and the variation is unexplained |
| External validity to the current policy | Relevance 1 studies dominate; the current policy is close in instrument and scale | Mostly Relevance 2, or the current policy differs materially in scale or scope | Mostly Relevance 3 |
| Recency and publication status | Peer-reviewed work covers the current policy generation | Peer-reviewed work covers an earlier generation; working papers cover the current one | Only working papers, or nothing on the current generation |

**11.1 Combining scores.** Each Strong scores 0 points, each Partial 1 point, and each Weak 2 points. The total sets the grade: 0–1 points is High; 2–3 is Moderate; 4–5 is Low; 6 or more is Very low. A single Weak is therefore enough to rule out High. Criteria are scored separately for each verdict scope (section 11.2), never for the claim as a whole.

| Grade | Meaning for the reader |
| --- | --- |
| High | Further research is very unlikely to change the verdict |
| Moderate | Further research could change the magnitude or qualify the verdict, but is unlikely to reverse it |
| Low | Further research could reasonably reverse the verdict |
| Very low | The verdict is a best current reading, not a settled finding |

**11.2 Split grades.** Where the evidence base differs by policy generation or population, the page carries one grade per generation and says which applies to the claim as currently made.

**11.3 Published with the grade:** each criterion's score, a one-line reason per criterion, and both reviewers' scores where they differed.

## 12. Characterizing disagreement

Every page has a disagreement section, even when the verdict is clean, because readers arrive having heard the other side. The section classifies the disagreement, presents the strongest opposing case, and says what would change our assessment.

**12.1 Classify the disagreement.** Each material dispute in the literature is assigned one or more types:

- **Data:** studies use different data and get different answers.
- **Method:** studies use different identification strategies and the choice drives the result.
- **Time horizon:** short-run and long-run effects differ, and studies measure different windows.
- **Scope:** the disagreement is about a related but different claim (jobs rather than prices).
- **Values:** the evidence is not disputed; what to do about it is.

The type determines what the reader should take away. A values disagreement does not lower certainty. A method disagreement among Tier A studies does. The section also says what the disagreement is *not* about, because public arguments often depend on blurring that.

**12.2 The steelman.** The lead reviewer writes the strongest version of the case against the verdict, in 150 to 300 words, citing the best evidence for it from the table. A reviewer who personally holds that view, or an outside economist who does, checks it before publication and may rewrite it. The steelman is labeled as such and never softened.

**12.3 What would change our assessment.** A concrete, falsifiable statement: the number and kind of studies, the findings, and the designs that would move the verdict or the certainty grade. This is the page's commitment to update.

**12.4 Expert commentary** (signed op-eds) is linked from this section, not merged into it. Authors see the review before writing; the review is not changed to fit the commentary.

## 13. Review workflow, roles and governance

A page passes through six gates before publication, and every gate has a named person. Trust comes from the people and the auditability of the process, not from the documents alone.

**13.1 Roles**

| Role | Who | Responsibility |
| --- | --- | --- |
| Lead reviewer | A PhD economist or equivalent, named on the page | Claim formulation, registration, search, extraction, synthesis draft, verdict and certainty ratings |
| Second reviewer | Independent of the lead; named on the page | Independent screening, tiering, and ratings; checks every numeric field in the table |
| Adversarial reader | An economist known to hold, or able to argue, the opposing view | Reads the full page before publication; rewrites the steelman if needed; comments are published **[decide]** |
| Editorial board | 5 to 7 economists spanning the field's ideological range; no two from the same institution **[placeholder]** | Approves the protocol and its versions; adjudicates reviewer disagreements; approves high-salience pages; hears challenges |
| Managing editor | Staff | Runs the pipeline, maintains the search log and the study tables, publishes, owns the changelog |

**13.2 Conflicts of interest.** Every reviewer and board member files a public statement covering funding, consulting, advocacy affiliations, and prior public positions on the claim. A reviewer with a prior public position on a claim may not be its lead reviewer. **[decide]** whether they may be second reviewer.

**13.3 Changing a verdict.** After publication, a verdict or certainty grade changes only through a re-review (section 14) approved by the editorial board. No single person, including the founder, can change a published verdict.

**13.4 Funding.** Funders are listed publicly. Funders have no role in topic selection, claim formulation, or review, and this is stated on every page. Topic selection follows the salience procedure in **[placeholder: topic selection policy]**.

**13.5 Gates**

1. Claim approved (two reviewers)
2. Registration posted
3. Search log and screening record complete
4. Study table verified by second reviewer
5. Verdict and certainty rated independently; disagreements resolved or escalated
6. Adversarial read complete; managing editor publishes with the protocol version and changelog entry

The scheduled re-search (section 14.1) sends a published page back through gate 3.

## 14. Updating, versioning, corrections and challenges

A page is a living review. It carries a version, a last-updated date, and a changelog, and it has a public route for anyone to challenge it.

**14.1 Scheduled re-search.** Every page's registered search is rerun on a schedule (quarterly **[decide]**; monthly for pages tagged election-relevant). New candidates go through screening. The managing editor logs the rerun whether or not anything changed.

**14.2 Triggers for re-review** (a full pass through sections 6 to 12):

- A new Tier A or B, Relevance 1 study is included
- A published replication of an included study fails or materially disagrees
- An included study is retracted or corrected
- A new policy generation makes the current claim materially different from the tested statement
- A challenge (14.4) is upheld

**14.3 Versioning.** Minor update (new study, no verdict change): v1.0 to v1.1, changelog entry, no board approval. Major update (verdict or certainty grade changes): new major version, board approval, prior version archived and linked, and a short note at the top of the page saying what changed and why.

**14.4 Challenges.** Anyone may submit a challenge: a missing study, an extraction error, a tiering dispute, or a claim-formulation objection. Each gets a public ticket, a response from the lead reviewer within 14 days **[decide]**, and a decision logged on the page. Upheld challenges are credited to the challenger by name if they wish.

**14.5 Corrections.** Errors of fact are corrected in place with a dated note. Errors that affected a verdict trigger 14.3. The corrections log is site-wide and public. The first high-profile correction will be judged on how it is handled, so the standard is: fast, complete, and un-defensive.

## 15. Self-measurement

The site publishes measures of its own reliability, because a review process that does not measure itself is asking to be trusted on faith.

**15.1 Inter-rater reliability.** For every page, the two reviewers' independent tier assignments, verdicts, and certainty scores are recorded before discussion. The site publishes, per page and in aggregate, the agreement rate and a chance-corrected statistic (Cohen's kappa or weighted kappa for ordered tiers). A sustained kappa below 0.6 **[decide]** on any rubric triggers a protocol review.

**15.2 Calibration.** Certainty grades make an implicit prediction: High-certainty verdicts should rarely be reversed; Low-certainty ones may be. The site tracks every verdict reversal against the certainty grade at the time, and publishes the reversal rate by grade annually. If High-certainty verdicts reverse at a rate comparable to Moderate ones, the rubric in section 11 is miscalibrated and gets revised.

**15.3 Search recall.** For a random sample of pages each year, an outside reviewer runs an independent search. Eligible studies they find that the registered search missed are counted and the recall rate is published.

**15.4 Challenge outcomes.** The number of challenges received, upheld, and rejected, by type, is published annually.

**15.5 Audience signals** (which pages are cited, by whom) are reported but never used to set verdicts or choose certainty grades.

## 16. Use of AI in the review

AI is the engine of the pipeline, not the author of the page. The rule throughout: AI may propose; a named human verifies and signs. This section follows the RAISE 2026 recommendations on responsible AI in evidence synthesis and is where our departures from them would be noted.

| Stage | AI may | AI may not | Human check |
| --- | --- | --- | --- |
| Claim formulation | Draft PECOS statements and list candidate public phrasings | Approve the tested statement | Two reviewers approve (3.5) |
| Search | Run registered queries, de-duplicate, chase citations, propose candidates | Add sources or queries not in the registration | Managing editor verifies the log against the registration |
| Screening | Pre-screen titles and abstracts and flag likely exclusions with reasons | Make a final inclusion or exclusion decision | Two humans screen full texts independently (6) |
| Extraction | Draft every row of the study table from the full text | Enter a row as verified | Human verifies every numeric field against the paper (7) |
| Tiering | Suggest a quality tier with a reason | Assign a tier | Two humans tier independently (8) |
| Synthesis | Draft the structured narrative from the verified table | Introduce any claim not traceable to a table row | Lead reviewer rewrites; second reviewer checks traceability (9.3) |
| Verdict and certainty | Nothing | Rate | Two humans, independently (10, 11) |
| Steelman | Draft a first version | Finalize | An economist holding the opposing view checks it (12.2) |
| Re-search | Run the scheduled rerun and flag new candidates | Change the page | Managing editor and lead reviewer (14.1) |

**16.1 Logging.** For every AI-assisted step the page's methods section records the model and version, the date, and a link to the prompt used. Prompts are versioned alongside the protocol.

**16.2 Disclosure.** Every page states that AI assisted search, screening, and extraction drafts, and that every published figure was verified by a named human. Nothing on the site is described as AI-generated analysis.

**16.3 Known failure modes** that the human checks are designed to catch: fabricated or misattributed citations; extraction of the wrong specification; confident summaries of papers the model has not fully read; and systematic omission of studies from less-indexed sources. Section 15.3 measures the last of these.

## 17. Page requirements

A claim page may be published only when every item below is present. This list is the publication checklist; `scripts/validate.R` enforces the structured items at build time.

- Public claim, verbatim, with at least two sourced instances
- Tested statement(s) in PECOS form and the mapping between the two
- Verdict (section 10) with both reviewers' rationales
- Certainty grade (section 11) with each criterion's score and reason; split grades where applicable
- A 30-second summary, the numbered sections, and the full study table on one page
- Key numbers box, each number linked to its table row
- Section 1: what the policy is trying to address, with links to related claim pages
- Section 2: what theory says: hypothesized effect, trade-offs, unintended consequences
- Section 3: the study table (design, setting, finding, tiers), with downloadable CSV
- Section 4: conclusion and certainty, criterion by criterion
- Section 5: what is still unknown
- Section 6: disagreement classified, the steelman, and what would change our assessment
- Methods: protocol version, registration link, sources and dates searched, screening counts, AI use log, reviewer names, conflict-of-interest statements
- Changelog with version history
- Links to expert commentary, labeled as opinion
- Challenge and correction links
- Citation string

## Appendix A: Pre-registration form

Filled in full before the first search runs, then posted to the registry (section 4). In the repository, this corresponds to the `registration`, `public_claim`, `tested_statements`, and `methods.search` / `methods.inclusion` sections of `claim.yml`.

```
CLAIM REGISTRATION

Claim ID: [tr-04]
Topic page: [Trade and tariffs]
Protocol version: [v0.2]
Registered: [date]   Registry link: [URL]

1. PUBLIC CLAIM
   Verbatim phrasing: "[...]"
   Instances (link, date, speaker): [1] [2]

2. TESTED STATEMENT (PECOS), one per verdict
   Population:  [...]
   Exposure:    [...] (dose: [...])
   Comparison:  [...]
   Outcome:     [...] (magnitude: [...])
   Setting:     [country, period]
   Full statement: [...]
   Weaker/stronger readings noted: [...]

3. SEARCH STRATEGY
   Sources: [core set + additions]
   Query strings (one per line): [...]
   Date range: [...]   Languages: [...]
   Grey literature policy: [per 5.4, with any additions]
   AI search agent: [model, version, prompt link]

4. INCLUSION / EXCLUSION
   Designs eligible: [per 6.1, with any claim-specific additions]
   Claim-specific exclusions: [...]

5. EXTRACTION FIELDS
   Standard set (Appendix B) plus: [...]
   Harmonized unit for effect sizes: [...]

6. REVIEWERS
   Lead: [name, affiliation]   COI statement: [link]
   Second: [name, affiliation]   COI statement: [link]
   Adversarial reader: [name]   Stated position: [...]

7. AMENDMENTS (added after registration)
   [date] [what changed] [why]
```

## Appendix B: Extraction fields

One row per included study. `studies.csv` has these columns, in this order.

| Field | Type | Notes |
| --- | --- | --- |
| study_id | text | S01, S02, … within the claim |
| citation | text | Authors, year, title, venue |
| doi_or_url | link | |
| pub_status | enum | Peer-reviewed; Working paper; Other |
| year | integer | Year of latest version |
| design | enum | RCT; Natural experiment; RD; DiD; Event study; Synthetic control; IV; Structural; Panel FE; Cross-section |
| data_source | text | |
| country | text | |
| period | text | Years covered by the data |
| sample | text | Units and size |
| exposure_as_implemented | text | The policy, with dose |
| comparison | text | |
| outcome | text | As measured |
| estimate | number | Point estimate, native unit |
| unit | text | |
| se_or_ci | text | Standard error or 95% CI |
| estimate_harmonized | number | In the registered harmonized unit, if convertible |
| direction | enum | Supports; Opposes; Null; Not applicable |
| spec_range | text | Range across specifications, if reported |
| quality_tier | enum | A; B; C; D |
| quality_reason | text | One line |
| relevance_tier | enum | 1; 2; 3 |
| relevance_reason | text | One line |
| modifiers | text | Per 8.3 |
| finding_summary | text | One sentence for the page table |
| limitations | text | Free text |
| extracted_by | text | AI draft, date |
| verified_by | text | Initials, date |
| tier_rater_1 / tier_rater_2 | text | Independent tiers before discussion |

## Appendix C: Glossary and sources

**Claim page.** A page that tests one causal statement (or two sharing an evidence base). **Topic page.** A container linking related claim pages.

**PECOS.** Population, Exposure, Comparison, Outcome, Setting: the structured form of the tested statement, adapted from the PICO framework used in medical reviews.

**Quality tier (A to D).** How well a study's design isolates the policy's effect. **Relevance tier (1 to 3).** How close its setting is to the claim's.

**Verdict.** What the eligible evidence shows: Supported, Not supported, Mixed, Cannot be graded. **Certainty.** How likely the verdict is to survive further evidence: High, Moderate, Low, Very low.

**Steelman.** The strongest reasonable version of the case against the verdict.

**Sources that shaped this protocol:**

- [Royal Society, Evidence synthesis for policy: a statement of principles](https://royalsociety.org/-/media/policy/projects/evidence-synthesis/evidence-synthesis-statement-principles.pdf)
- [J-PAL, Announcing Policy Insights (method note)](https://www.povertyactionlab.org/blog/5-10-18/announcing-j-pals-policy-insights)
- [RAISE 2026 recommendations, as cited in Preliminary Guidelines for Using GenAI Tools to Support Systematic Literature Reviews](https://arxiv.org/pdf/2607.24991)
- GRADE handbook (Cochrane): the model for separating the finding from the certainty in it **[add link]**
- [EconoFact](https://econofact.org/story/in-the-news) and [Microeconomic Insights](https://microeconomicinsights.org/?p=2): the closest existing products, for positioning

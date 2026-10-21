# Decisions log

Settled choices, with the reasoning, so a new session (human or Claude Code) does not reopen them. Add an entry when something is decided; mark it superseded rather than deleting it.

## 2026-10-19 — Name: The Credibility Project

Tagline: *What the economic evidence says, and how sure we are.* Chosen over The Margin (collides with Marginal Revolution and a former MarketWatch column), Priors, The Counterfactual, Pareto (crowded, wrong connotation), and "Credibility Revolution" (reads as a methods-tribe allegiance flag). Known neighbors to be aware of: Credibility Coalition (US nonprofit, online-information credibility) and Projeto Credibilidade (Brazil, journalism). No direct collision found; domain check pending.

## 2026-10-19 — Scope is defined by evidence type, not field

In scope: policy claims whose evidence base is quantitative causal research. Out of scope: clinical/biomedical efficacy, natural-science claims, constitutional questions, foreign policy, polling-based or case-study claims, and all value claims. Protocol §1.

## 2026-10-19 — The claim is the unit of analysis

Topic pages are containers. Each claim page tests one PECOS statement (or two sharing an evidence base). Protocol §1, §3.

## 2026-10-19 — Verdict and certainty are separate grades

Verdict: Supported / Not supported / Mixed / Cannot be graded. Certainty: High / Moderate / Low / Very low, built from five criteria scored Strong / Partial / Weak. Protocol §10–11. Vocabulary for the verdict labels is still **[decide]** (§10.4).

## 2026-10-19 — Split-verdict rule

Bundled claims are split. Shared evidence base → one page, one verdict per statement (e.g. immigrants and native jobs: employment vs. wages). Disjoint evidence bases → separate pages, linked both ways (e.g. deportations-and-crime vs. immigrant crime rates). Protocol §3.4.

## 2026-10-19 — Policy-generation rule

When evidence covers an earlier generation of a current policy, the headline verdict is for the generation studied; the current generation is stated immediately beneath, usually "Cannot be graded" with the evidence needed. Protocol §10.5.

## 2026-10-19 — Pilot claims (five)

1. `tr-04` Tariffs are paid by foreign countries, not Americans
2. `hs-01` Rent control makes housing more affordable (expected split verdict)
3. `hs-02` Building more market-rate housing doesn't help affordability
4. `lb-01` Raising the minimum wage costs jobs (expected Mixed, with magnitude in the statement)
5. `sn-01` Medicaid work requirements increase employment

Chosen to cover 2027–28 salience, show the rubric producing different verdicts, and include claims from both sides' rhetoric. Mock-ups also exist for `im-01` (immigrants and native jobs) and `im-02` (deportations and crime); these are candidates for after the pilot.

## 2026-10-19 — Team for the pilot

Two people minimum (lead reviewer + half-time second reviewer), plus adversarial readers on honoraria and 3–5 advisors lending names. Sustained operation is roughly 4–5 FTE. The second reviewer is non-negotiable: the protocol requires two humans on every grade.

## 2026-10-21 — Tooling: Quarto, static site, data-driven claim pages

Quarto (R-native, static, GitHub Pages) over Astro. Each claim is a folder: `index.qmd` (prose + R chunks) reading `claim.yml` (structured fields) and `studies.csv` (the study table, also the public download). `scripts/validate.R` runs as a Quarto pre-render step and fails the build on missing required fields. Working notes in `research/` are not canonical.

## 2026-10-21 — Division of labor between tools

The claude.ai Project holds the thinking (protocol revisions, claim formulation, pilot strategy, mock-ups). Claude Code holds the build (site, templates, validation, pipeline scripts). Decisions made in the Project are copied into this file or `docs/protocol.md` so Claude Code sessions inherit them.

## Open items

- Verdict label vocabulary (§10.4)
- Registry choice: OSF vs. signed commit (§4)
- Recognized working-paper series list (§5.4)
- Exact verdict threshold, 80% proposed (§10.2)
- Editorial board composition (§13.1) and whether adversarial-reader comments are published
- Domain registration for credibilityproject.org / thecredibilityproject.org
- Whether to qualify the name ("The Policy Credibility Project") or rely on the tagline

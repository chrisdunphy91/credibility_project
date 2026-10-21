# The Credibility Project — Claude Code instructions

Read at the start of every session in this repo. It encodes the project's purpose and the rules that make every page auditable. The governing document is `docs/protocol.md` (Evidence Review Protocol); when this file and the protocol disagree, the protocol wins and this file gets fixed.

## What this project is

A Quarto website that grades public policy claims against the causal research literature, for a general audience ahead of elections and major policy decisions. Tagline: *What the economic evidence says, and how sure we are.*

The product is **transparency**, not verdicts. Every page shows the claim as people say it, the statement we tested, every study we included, how each was weighted, who reviewed it, and what would change our mind. A critic must be able to rerun our search and reproduce our table.

We do not recommend policies. We do not discuss politicians. We describe what the evidence shows about a policy's effects, including who gains and who loses, and let readers decide.

Working name: The Credibility Project. Use the `site-title` variable from `_variables.yml` (`{{< var site-title >}}`); never hardcode it in content.

## Scope rule

In scope: claims about the effects of policy where the evidence base is quantitative causal research (experiments, natural experiments, DiD, RD, IV, synthetic control, structural models estimated on policy variation). The author's field does not matter; the evidence type does. Out of scope: clinical/biomedical efficacy, natural-science claims, constitutional questions, foreign policy, and anything whose evidence is polling or case studies. Value claims ("is this policy good") are never graded.

## Non-negotiables (from the protocol)

1. **The unit is the claim, not the topic.** A claim page tests one causal statement. A topic page is a container that links claim pages. Never write a "topic page" that grades things.
2. **Verdict and certainty are separate.** Verdict = what the eligible evidence shows (Supported / Not supported / Mixed / Cannot be graded). Certainty = how likely that verdict survives more evidence (High / Moderate / Low / Very low), built from five scored criteria. A page can be "Not supported, Low certainty."
3. **Pre-register before searching.** The tested statement, search strategy, and inclusion criteria are written and time-stamped before any study is read. Amendments are logged, never silent.
4. **Two humans on every grade.** Claude drafts; it never assigns a final tier, verdict, or certainty score. Two named reviewers rate independently; both rationales are published.
5. **The study table is data, and it is public.** `studies.csv` is the page's table *and* the downloadable file. One file. The search log and screening record are published too.
6. **The build fails if a claim is missing** a registration link, a protocol version, two reviewer scores, five certainty criterion scores, or a changelog entry. `scripts/validate.R` enforces this as a Quarto pre-render step.
7. **Disagreement is a finding.** Every page classifies why the literature disagrees (data / method / time horizon / scope / values) and publishes a steelman of the opposing case.

## Repository layout

```
CLAUDE.md
_quarto.yml                 site config, navigation, pre-render: scripts/validate.R
index.qmd                   homepage
about.qmd                   mission, scope, editorial board, funding, challenge process
methods.qmd                 public rendering of docs/protocol.md
docs/
  protocol.md               Evidence Review Protocol — single source of truth for all rules
  decisions.md              decisions log (name, scope rule, pilot claims, split-verdict rule)
  mockups/                  reference HTML mock-ups of the claim page layout
topics/
  _template.qmd             topic container page
  <topic>.qmd               one per topic (trade, housing, labor, immigration, safety-net)
claims/
  _template/                canonical claim — ALWAYS copy this to start a new claim
    index.qmd               page template; reads claim.yml and studies.csv via R chunks
    claim.yml               registration, verdicts, certainty scores, reviewers, changelog
    studies.csv             one row per included study (columns fixed; see protocol App. B)
    search-log.csv          every query, source, date, result count
    screening.csv           every full-text exclusion with reason
  <claim-id>/               e.g. claims/tr-04-tariff-incidence/
research/
  <claim-id>/               Claude's working notes and drafts; not canonical, not rendered
references/
  <claim-id>.bib
scripts/
  validate.R                pre-render validation; build fails on missing required fields
.github/workflows/          renders and deploys on push to main
```

Published content: `claims/`, `topics/`, `index.qmd`, `about.qmd`, `methods.qmd`. Nothing in `research/` renders, but it may be published later, so keep it honest.

## Workflow for a new claim (the six gates)

Each gate has a named human. Claude does the drafting between gates and stops at each one.

1. **Claim formulation.** Record 2+ verbatim public instances with links. Write the tested statement in PECOS form (Population, Exposure, Comparison, Outcome, Setting) with a magnitude where the claim implies one. Apply the steelman rule: test the strongest reasonable reading. *Gate 1: two reviewers approve the mapping.*
2. **Pre-registration.** Fill `claim.yml` sections `registration` and `search_strategy`. Post to the registry (OSF or a signed commit). *Gate 2: registration link in `claim.yml`.*
3. **Search.** Run the registered queries only; log each in `search-log.csv`. Chase citations backward and forward from every included study. *Gate 3: log complete.*
4. **Screening and extraction.** Title/abstract pass, then full text. Record every full-text exclusion in `screening.csv`. Draft one row per included study in `studies.csv` with a *proposed* quality and relevance tier and a one-line reason. Mark every numeric field `[VERIFY]` until a human initials it. *Gate 4: second reviewer verifies every number.*
5. **Synthesis and rating.** Draft the page prose from the verified table only; every empirical sentence cites a table row. Reviewers rate independently (tiers, verdict, five certainty criteria) and write 150–300 word rationales. *Gate 5: both rationales in `claim.yml`.*
6. **Adversarial read.** An economist who holds or can argue the opposing view reads the page and rewrites the steelman if needed. *Gate 6: managing editor publishes with version and changelog entry.*

Branch `claim/<claim-id>`; open a PR at the end; the author merges.

## Study tiers (protocol §8)

Studies get a quality tier and a relevance tier, not a numeric weight. Both appear in `studies.csv` with a reason.

| Quality | Designs | Can move a verdict? |
| --- | --- | --- |
| A | RCT; sharp natural experiment; RD at a policy threshold | Yes |
| B | DiD, event study, synthetic control, IV | Yes |
| C | Structural model on policy variation; panel FE with rich controls | Only to explain disagreement |
| D | Cross-sectional or time-series correlation | No; kept for completeness |

Relevance: 1 = same country, same instrument, within 15 years; 2 = same country earlier period or close peer economy; 3 = illuminates mechanism, transfers with caution.

Modifiers: working paper → provisional tier with asterisk; failed replication → tier lowered one step, both studies shown; author COI → noted.

## Verdict and certainty (protocol §10–11)

Verdict thresholds apply to Tier A/B, Relevance 1/2 studies: **Supported** (3+ studies, 80%+ in claimed direction, no Tier A opposite, magnitude consistent with the claim as stated); **Not supported** (mirror); **Mixed** (neither); **Cannot be graded** (fewer than 3 eligible studies — publish what exists and say what evidence is needed). Magnitude matters: directionally right with the wrong size is Not supported.

Certainty criteria, each scored Strong / Partial / Weak: (1) number and quality of causal studies, (2) consistency of direction, (3) consistency of magnitude, (4) external validity to the current policy, (5) recency and publication status. Start at High; the first two Partials each drop one step; each Weak drops one step without limit; no High with any Weak. Where the evidence differs by policy generation, grade each generation separately.

Claude proposes scores with reasons. Humans assign them.

## Claim formulation rules (protocol §3)

- Test the strong reading, note the weak one. A page that tests a strawman fails review.
- A public claim that bundles several causal statements is split. **One page with two verdicts** when the evidence base is shared (e.g. immigrants-and-jobs: employment vs. wages). **Separate pages** when the evidence bases are disjoint (e.g. deportations-and-crime vs. immigrant crime rates). Link them both ways.
- The public claim, the tested statement, and the mapping between them all appear on the page.

## Disagreement section rules (protocol §12)

Every page has one, even when the verdict is clean. Classify each live dispute as data / method / time horizon / scope / values. Values disagreements do not lower certainty; method disagreements among Tier A studies do. Write the steelman (150–300 words, citing the best opposing evidence from the table) and a falsifiable "what would change our assessment." Signed expert op-eds link from here; they never alter the review.

## Audience and voice

- Reader: an interested non-expert adult. Assume intelligence, not background. Gloss jargon once.
- Calm, direct, specific. "Most studies find X; a minority find Y, in settings where Z" beats "the evidence is mixed."
- Quantify in units a reader can picture, with the range across credible studies.
- Name trade-offs: who gains, who loses, through what channel.
- Discuss policies, not people. Describe disagreement neutrally, then say what the evidence shows.
- Three reading depths on one page: a 30-second summary box, the numbered sections, the full study table.

## Citation and sourcing rules

- Effect estimates come only from peer-reviewed articles and recognized working-paper series (NBER, CEPR, IZA, Fed system, IMF, World Bank). Think tanks and media are acceptable only for descriptive facts.
- Every number on a page traces to a `studies.csv` row or a cited descriptive source. No orphan statistics.
- Never cite a study you have not retrieved and read (methods and results, not just the abstract). If only the abstract was accessible, say so in `research/<id>/notes.md`.
- **Never fabricate a citation, DOI, effect size, or standard error.** Uncertain → `[VERIFY]` and flag the author. A placeholder is always better than an invented number.
- Record search dates. Pages show "last updated" and a changelog.

## Quarto conventions

- `.qmd` files; YAML front matter follows the template exactly. Section headings and order are fixed; a section with nothing to say keeps its heading and one sentence explaining why.
- Claim pages read `claim.yml` and `studies.csv` through R chunks; do not retype table contents into prose or markdown tables. Declare `studies.csv` under `resources:` so it downloads.
- Callouts as defined in the template: `callout-important` for verdicts, `callout-note` for certainty, `callout-tip collapse="true"` for methods.
- Per-claim bibliography via `bibliography: ../../references/<claim-id>.bib`.
- `quarto render` must pass with no warnings before committing. `scripts/validate.R` must pass.

## Git conventions

- Branches: `claim/<claim-id>` for content, `site/<description>` for design or config.
- Commits: imperative mood, first line under 70 characters.
- Never commit secrets or large binaries. Never force-push or rewrite history on `main`. Never merge PRs; the author does.

## Pilot claims (the planned list)

`tr-04` tariff incidence · `hs-01` rent control and affordability · `hs-02` market-rate construction and rents · `lb-01` minimum wage and employment · `sn-01` Medicaid work requirements and employment. Drafted mock-ups also exist for `im-01` immigrants and native jobs and `im-02` deportations and crime; these are not in the pilot.

## Ask the author rather than decide

- Any claim not on the planned list, or any change to a tested statement after registration.
- Any change to the tiers, verdict thresholds, certainty rubric, page structure, or `docs/protocol.md`.
- Any content naming a living politician or candidate.
- Any final tier, verdict, or certainty score (Claude proposes; humans assign).
- Design or navigation changes to the site.

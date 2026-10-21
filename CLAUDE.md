# The Credibility Project — Claude Code instructions

This file is read at the start of every Claude Code session in this repo. It encodes the project's purpose, conventions, and decision rules so that every topic page is produced the same way.

## What this project is

A Quarto website that synthesizes the published academic literature on policy-relevant economic questions for a general audience (voters ahead of elections and major policy decisions). The site's value is **transparency**: it states plainly what is known, what is not known, where the literature disagrees, and how we reached each conclusion.

The site is *not* an advocacy project. We do not recommend policies. We describe what the evidence says about their effects, including trade-offs and unintended consequences, and let readers decide.

Working name: The Credibility Project (not final; do not hardcode the name in content — use the `site-title` variable from `_quarto.yml`).

## Audience and voice

- Reader: an interested, non-expert adult. Assume intelligence, not background. No jargon without a one-line plain-language gloss on first use.
- Voice: calm, direct, specific. Never breathless, never hedged into mush. Prefer "most studies find X; a minority find Y, usually in settings where Z" over "the evidence is mixed."
- Quantify when the literature quantifies. Give effect sizes in units a reader can picture (dollars per year, percentage points, jobs per 100 workers), with the range across credible studies.
- Name trade-offs explicitly. Every policy helps some people and costs others; say who.
- Do not editorialize about politicians, parties, or motives. Discuss policies, not people.
- Spell out political and ideological disagreement neutrally: "proponents argue… critics argue…" and then say what the evidence shows about each claim.

## Repository layout

```
CLAUDE.md             this file
_quarto.yml           site config and navigation
index.qmd             homepage
about.qmd             mission, methodology, and the decision rules below (public)
topics/
  _template.qmd       canonical topic page — ALWAYS start new pages from this
  <slug>.qmd          one file per topic (kebab-case slug, e.g. minimum-wage.qmd)
research/
  <slug>/             working notes for each topic — NOT published
    sources.md        annotated list of every study considered, with inclusion decision
    notes.md          extraction notes, effect sizes, study designs, caveats
    log.md            dated log of searches run and decisions made
references/
  <slug>.bib          BibTeX file for each topic
.github/workflows/    builds and deploys the site on push to main
```

Published content lives only in `topics/`, `index.qmd`, and `about.qmd`. Everything in `research/` is the evidence trail and may later be published for transparency, so keep it tidy and honest.

## Workflow for a new topic

1. Create a branch: `topic/<slug>`.
2. Create `research/<slug>/` with `sources.md`, `notes.md`, and `log.md`.
3. **Literature search phase.** Search for peer-reviewed studies, working papers from established series (NBER, IZA, CEPR, Fed system, etc.), and existing meta-analyses or systematic reviews. Record every search and its date in `log.md`. Record every candidate study in `sources.md` with an inclusion/exclusion decision and a one-line reason.
4. **Extraction phase.** For each included study, record in `notes.md`: citation, setting (country, period, population), design (see evidence hierarchy below), outcome(s), effect size with units and confidence interval or standard error, and any major caveat.
5. **Synthesis phase.** Copy `topics/_template.qmd` to `topics/<slug>.qmd`. Fill every section. Do not delete sections; if a section genuinely has nothing to say, write one sentence explaining why (e.g. "No credible causal evidence exists on this outcome.").
6. Create `references/<slug>.bib` and cite with Quarto `[@key]` syntax. Every empirical claim must carry a citation.
7. Render locally (`quarto render`) and fix any warnings before committing.
8. Commit with a descriptive message, push, and open a pull request. The author reviews every page before merge; Claude Code does not merge to `main`.

## Evidence hierarchy

When weighing studies, use this ordering for causal questions. Higher tiers get more weight, but a well-executed lower-tier study in a highly relevant setting can outweigh a poorly executed higher-tier study elsewhere. Say which tier each key finding rests on.

1. Randomized controlled trials and natural experiments with credible as-good-as-random assignment (lotteries, discontinuities, sharp policy cutoffs).
2. Quasi-experimental designs with a credible identification strategy: difference-in-differences with parallel pre-trends, regression discontinuity, instrumental variables with a defensible instrument, synthetic control.
3. Panel designs with fixed effects and careful control for confounders, without a clean source of exogenous variation.
4. Cross-sectional correlational studies, descriptive statistics.
5. Simulations, calibrated models, and theory-only arguments (informative about mechanisms, not about magnitudes in the real world).

Prefer meta-analyses and systematic reviews when they exist and are recent, but check their inclusion criteria and whether they account for publication bias.

## Certainty rubric

Every conclusion on a topic page is assigned exactly one of these labels. The label must be justified in the "How we reached this" subsection.

- **High confidence** — Multiple tier-1/tier-2 studies across different settings point the same direction, with effect sizes in a similar range. Dissenting studies are few and have identifiable weaknesses.
- **Moderate confidence** — Several credible studies agree on direction, but magnitudes vary materially, settings are limited, or there is a credible minority finding.
- **Low confidence** — Evidence exists but is thin, methodologically weak, or genuinely split with no clear reason for the split.
- **Unknown / insufficient evidence** — No credible studies, or only tier-4/tier-5 evidence.

Rules that follow from the rubric:
- Never state a conclusion without a label.
- Never upgrade a label because the conclusion feels intuitive or widely believed.
- When the literature disagrees, do not average it into a vague middle. State the disagreement, state the leading explanations for it (different settings, different time periods, different methods), and label accordingly.
- Distinguish "effect is probably small" (a finding) from "we don't know" (absence of evidence). These get different labels and different language.
- Direction and magnitude can carry different labels (e.g. high confidence the effect is negative, low confidence about how large).

## Citation and sourcing rules

- Cite peer-reviewed articles and established working-paper series. Think tanks, advocacy groups, and media are acceptable only for descriptive facts (what the policy is, when it passed), never for effect estimates.
- Every number on a page traces to a specific citation. No orphan statistics.
- Do not cite a study you have not actually retrieved and read (abstract plus methods and results at minimum). If only the abstract was accessible, say so in `notes.md`.
- Never fabricate a citation, a DOI, or an effect size. If uncertain whether a study exists or what it found, mark it `[VERIFY]` in `notes.md` and flag it for the author.
- Record the date the search was run. Pages note their "last reviewed" date so readers can judge staleness.

## Quarto conventions

- Files use `.qmd`. YAML front matter follows `topics/_template.qmd` exactly.
- Section headings and their order are fixed by the template. Do not rename, reorder, or remove them.
- Use Quarto callouts for the certainty labels (`::: {.callout-note}` etc. as defined in the template) so they render consistently.
- Bibliography per topic via `bibliography: ../references/<slug>.bib` in the page YAML.
- Keep pages readable in under ten minutes; put extended detail in collapsible sections (`::: {.callout-tip collapse="true"}`) rather than cutting it.

## Git conventions

- Branch names: `topic/<slug>` for content, `site/<description>` for design or config changes.
- Commit messages: imperative mood, first line under 70 characters, e.g. `Add minimum wage topic page draft`.
- Never commit secrets, API keys, or large binary files.
- Never force-push and never rewrite history on `main`.
- Do not merge pull requests; leave that to the author.

## Things to ask the author about rather than decide

- Adding a new topic that is not already on the planned list.
- Any change to the certainty rubric, evidence hierarchy, or page structure.
- Any content that discusses a named living politician or candidate.
- Design or navigation changes to the site.

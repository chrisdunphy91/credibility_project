# The Credibility Project

What the economic evidence says, and how sure we are.

A Quarto site that grades public policy claims against the causal research literature, with every search, study, tier, and reviewer rationale published alongside the verdict.

- `docs/protocol.md` — the Evidence Review Protocol (governing document)
- `docs/decisions.md` — decisions log
- `CLAUDE.md` — instructions for Claude Code sessions in this repo
- `claims/_template/` — start every new claim by copying this folder

Build: `quarto render`. The pre-render step `scripts/validate.R` fails the build if any claim is missing required fields.

Deploy: manual only. Actions tab → "Render and publish site" → Run workflow (on `main`). Pull requests are checked by "Check site", which renders but publishes nothing.

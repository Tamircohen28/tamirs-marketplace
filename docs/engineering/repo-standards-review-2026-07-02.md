# Repo standards review — tamirs-plugins (plugins-catalog)

_Reviewed 2026-07-02 · profile: app-gold · multi-platform plugin catalog_

## Executive summary

The repo is already well past baseline: README with banner + badges, generated
multi-platform manifests, CI (validate + secret-scan + doc-lint), release
workflow, issue/PR templates, dependabot, CODEOWNERS, and branch protection all
present. The remaining gaps are almost entirely **multi-agent scaffolding**
(AGENTS.md and friends) plus a few small standards P2s. Employer-IP scan is
**CLEAN**.

## Severity summary

| Severity | Count | Notes |
|----------|-------|-------|
| P1 | 4 | All multi-agent (AGENTS.md, CLAUDE↔AGENTS link, agent:check cmd, CI agent-validate doc) — delegated to `multi-agent-repo` |
| P2 | 9 | README Prerequisites, docs/engineering (now created), .cursor/rules, portable skills dir, docs/agent-guidelines, agent-drift script, branch-protection review count |
| P3 | 0 | — |

## Standards gaps (S1–S7)

- **S1-03 (P2):** README missing an explicit Prerequisites section (Claude Code / Cursor / Codex CLI + Python 3 for `make generate`).
- **S2-02 (P2):** `docs/engineering/` was missing — created for this review.
- **S3-02 (P2):** scorer flags "CI missing secret-scan job" but `ci.yml` **already has** a `Secret scan` step. False positive — no action.
- **S4-01 (P2):** scorer flags "CODEOWNERS missing" but `.github/CODEOWNERS` **already exists**. False positive — no action.
- **S4-03 (P2):** branch protection currently requires 0 approving reviews; single-maintainer repo, acceptable but could set to 1.

## Employer IP scan

**RESULT: CLEAN.** `ip-scan.sh` found no employer-IP patterns. A deep history
sweep (`git grep` across all refs) surfaced only **guardrail** mentions of "Wix"
— e.g. CONTRIBUTING.md "Plugin must not contain Wix-internal references" and
CLAUDE.md "Never add Wix-internal URLs". These are prohibition statements, not
leaked IP, and should stay. No actual Wix/Rango/SkillsLibrary content in tracked
files or history.

## Multi-agent appendix (S8 / L*)

Deferred to `multi-agent-repo` (step 3 / polish phase 5):
- **L1-01 (P1):** AGENTS.md missing at repo root.
- **L2-02 (P1):** CLAUDE.md does not reference AGENTS.md.
- **L6-03 / L6-04 (P1):** no `agent:check`/validate command wired into Makefile + CI doc.
- **L3-01, L4-02, L5-01, L7-01 (P2):** `.cursor/rules/`, portable skills dir, `docs/agent-guidelines/`, agent-drift script.

## Docs read-only notes

`docs/` tree is complete (README, CONTRIBUTING, CHANGELOG, user/{concepts,
quick-start, troubleshooting}). Well-organized; no misplaced top-level docs. No
P1 doc issues.

## Next steps

1. Plan mode → phase the P1s + real P2s.
2. Polish → implement README Prerequisites + branch-protection tweak, delegate
   multi-agent scaffolding to `multi-agent-repo`, open one PR.

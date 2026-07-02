# Repo standards remediation plan — tamirs-plugins

_From review 2026-07-02. Branch: `feat/repo-standards-setup`. One PR, never merge from skill._

## Phase 0 — IP scan
- Already CLEAN. No scrub needed. (guardrail "Wix" mentions are intentional; keep.)

## Phase 1 — README + CLAUDE.md
- **S1-03:** Add a Prerequisites section to README (Claude Code / Cursor / Codex + Python 3 for `make generate`).
- **L2-02:** Add AGENTS.md reference into CLAUDE.md (done via multi-agent-repo in phase 5, but add the pointer link).

## Phase 2 — docs
- `docs/engineering/` created (holds this review + plan). No further doc P1s.

## Phase 3 — CI
- Secret-scan job already present. No change. (scorer false positive)

## Phase 4 — governance
- CODEOWNERS already present. No change.
- **S4-03:** optionally require 1 approving review — single-maintainer repo; leave as-is to avoid self-block, note in PR.

## Phase 5 — multi-agent (delegated)
- Run `multi-agent-repo` on the same branch: creates AGENTS.md, CLAUDE↔AGENTS link, `.cursor/rules/`, `docs/agent-guidelines/`, `agent:check` command, drift script. Covers L1-01, L2-02, L3-01, L4-02, L5-01, L6-03, L6-04, L7-01.

## Phase 6 — docs/changelog review
- Light-touch; add CHANGELOG `[Unreleased]` entry for the standards work.

## Phase 7 — exit gate
- `assert-contract.sh` app-gold P1/P2/P3 acceptable; open PR.

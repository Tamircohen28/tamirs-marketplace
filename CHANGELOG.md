# Changelog

All notable changes to the tamirs-plugins catalog are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

### Added
- Canonical `AGENTS.md` as the single source of truth for agent guidance, with
  thin adapters: `CLAUDE.md` (`@AGENTS.md`) and `.cursor/rules/000-project.mdc`
- `docs/agent-guidelines/` (style, testing, security) referenced from `AGENTS.md`
- `scripts/check-agent-drift.sh` and `make agent:check`, wired into `make validate` and CI
- README Prerequisites section
- `docs/engineering/` with repo-standards review and remediation plan

### Changed
- CI runs the secret scan as its own dedicated `secret-scan` job
- Moved `CODEOWNERS` to the repository root

---

## [1.1.0] — 2026-06-26

### Added
- Codex marketplace manifest at `.agents/plugins/marketplace.json`
- Cursor team marketplace manifest at `.cursor-plugin/marketplace.json`
- `scripts/generate-marketplaces.py` and `scripts/validate-marketplaces.py`
- `make generate` and `make validate` targets
- Multi-platform install instructions for Claude Code, Codex, and Cursor

### Changed
- CI validates all three marketplace manifests and fails on generator drift
- Release workflow regenerates Codex and Cursor manifests when bumping version
- Banner SVG: correct repo name (`plugins-catalog` → `plugins`) and replace hardcoded plugin list with platform description

---

## [1.0.0] — 2025-06-01

### Added
- Initial catalog with three plugins: `tamirs-superpowers`, `jose-claudinho`, `headhunter`
- `allowCrossMarketplaceDependenciesOn` for `superpowers-dev` marketplace (enables `tamirs-superpowers` dependency auto-install)

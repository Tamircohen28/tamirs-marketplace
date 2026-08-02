# Changelog

All notable changes to the tamirs-plugins catalog are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

### Added
- **Docs: plugin discovery via newer Claude Code CLI/UI (2.1.157–2.1.172).** Quick-start now points at the `/plugin` marketplace search bar, `claude plugin list --enabled/--disabled` filters for the verify step, and the Installed tab's Skills section.
- **Docs: `pluginSuggestionMarketplaces` for teams (2.1.152).** Concepts explains that org admins can allowlist `tamirs-plugins` so Claude Code surfaces its plugins as context-aware suggestions inside the organization.

### Changed
- Platform targets: validated against Claude Code 2.1.220 (was 2.0.0). Reviewed the 2.0.0 → 2.1.220 changelog for marketplace-facing changes: `marketplace.json` stays valid, no renamed plugins (so the 2.1.191 `renames` map is not needed), and no reliance on removed features. Updated `platform-targets.json`, the `platform-targets.md` mirror, and the README Claude Code badge. `supported_min` stays 2.0.0.

## [1.2.0] — 2026-07-10

### Added
- `docs/engineering/build-and-release/platform-targets.json` and `platform-targets.md`
- `docs/engineering/build-and-release/versioning.md`
- `docs/agent-guidelines/platform-equivalence.md` (catalog vs plugin capabilities)
- `make install`, `make update`, `make uninstall` contributor lifecycle targets
- `make repo-standards-gate`, `assert-contract`, and vendored contract check scripts
- `.agents/skills/run-plugins-catalog/` contributor skill stub
- `.codex/config.toml` stub for Codex contributors
- README author + version badges; platform-target pinned AI badges
- `production-master` row in README plugin table
- Dedicated `CI` job as required branch-protection status check

### Changed
- Marketplace version bumped to `1.2.0`
- `make agent:check` now includes feature-equivalence and platform-targets checks

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

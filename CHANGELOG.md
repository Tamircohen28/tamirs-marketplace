# Changelog

All notable changes to the tamirs-marketplace catalog are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

### Changed
- **Cursor desktop pin → 3.15.19.** `.cursor-version`, cursor fields in `platform-targets.json`, README badge, and install docs track desktop **3.15.19**. Changelog feature coverage remains **3.11** / **2026-08-03**.
- **Cursor docs: `workspaceOpen` + Agent Plugins standard.** Install guide documents the `workspaceOpen` hook and Agent Plugins open-standard support.

### Fixed
- **Removed Cursor adoption commits that landed on the Claude Code nightly branch.**
  The rolling `claude-code-update` branch briefly carried the "Cursor 3.11
  (+2026-08-03) Team MCP + Customize" doc adoption and a follow-up install-index
  note, duplicating the separate `cursor-update` nightly PR and putting
  cursor-scoped files in a Claude Code-scoped PR; both are reverted here and live
  only in the cursor PR where they belong.

## [2.0.0] — 2026-08-07

### Changed
- **BREAKING — the catalog is renamed from `tamirs-plugins` to `tamirs-marketplace`, and the repo from `Tamircohen28/plugins` to `Tamircohen28/tamirs-marketplace`.** The old repo URL still resolves via GitHub's redirect, but the marketplace *identifier* changed, so plugin selectors (`<plugin>@tamirs-plugins`), the local cache path (`~/.claude/plugins/cache/tamirs-plugins/`), and any glob built on that path no longer match. Existing installs must migrate:

  ```
  /plugin marketplace remove tamirs-plugins
  /plugin marketplace add Tamircohen28/tamirs-marketplace
  /plugin install tamirs-superpowers@tamirs-marketplace
  ```

  Consumers that hardcode the cache path — notably `tamirs-superpowers`' statusline and Pushover hooks — are updated in that repo's matching release. The rename makes the name state what the repo is: a marketplace catalog, not a pile of plugins.

## [1.3.0] — 2026-08-03

### Added
- **OpenCode as a fourth supported target.** The four targets this catalog and every plugin in it support are now **Claude Code, Cursor, Codex, and OpenCode**, recorded as `supported_targets` in `platform-targets.json`. OpenCode has no plugin marketplace and no plugin manifest format, so this catalog **cannot** be installed there — each plugin repo is installed directly and OpenCode discovers its skills natively via the `opencode.json` each one ships. Tracked under `targets.opencode.capability_gaps` rather than left implicit.
- **`docs/user/install/` — a detailed guide per target** (`claude-code.md`, `cursor.md`, `codex.md`, `opencode.md`, plus an index). Each has a validated-against/minimum header, prerequisites, install methods, what you get, verification, update, uninstall, and a troubleshooting table.
- `platform-targets.json` schema 1 → 2: `supported_targets` makes the enforced target list data-driven, plus `supported_min_source`, `verified_on`, `verification_method`, `install_doc`, and `capabilities` per target. `scripts/check-platform-targets.sh` reads that list (with a legacy three-target fallback), so adding a fifth target needs no script change.
- `--sync` now refreshes `latest_known` from npm for Claude Code (`@anthropic-ai/claude-code`) and OpenCode (`opencode-ai`), alongside the existing Codex GitHub-releases lookup. Cursor has no public version endpoint and stays manual.
- **Docs: plugin discovery via newer Claude Code CLI/UI (2.1.157–2.1.172).** Quick-start now points at the `/plugin` marketplace search bar, `claude plugin list --enabled/--disabled` filters for the verify step, and the Installed tab's Skills section.
- **Docs: `pluginSuggestionMarketplaces` for teams (2.1.152).** Concepts explains that org admins can allowlist `tamirs-marketplace` so Claude Code surfaces its plugins as context-aware suggestions inside the organization.

### Fixed
- **The Codex install commands in the README, quick-start, and concepts could never have worked.** They documented `codex plugin install <name> --source plugins`; Codex 0.146.0 has no `install` subcommand and no `--source` flag. Verified against `codex plugin add --help`. Corrected everywhere to `codex plugin add <name>@tamirs-marketplace` and `codex plugin list --marketplace tamirs-marketplace`.
- **Removed the dead `production-master` catalog entry.** It pointed at `ProductionMasterAI/production-master-intel`, which 404s. `codex plugin add production-master@tamirs-marketplace` failed with `remote: Repository not found` — the entry listed cleanly and then broke at clone time, which is the worst way for it to fail.
- **Cursor's version floor was fiction.** `0.45.0` predates Cursor's plugin system entirely, so a host at that version could never have imported a team marketplace. Cursor's docs state no minimum for plugins, so the floor is now the version actually validated on (3.14.7).
- Stale `tamirs-superpowers` description — "17 bundled skills" → **26**, in the canonical manifest (and therefore both generated manifests), README, and concepts.

### Changed
- Marketplace version bumped to `1.3.0`.
- Platform targets validated against **Claude Code 2.1.220, Cursor 3.14.7, Codex 0.146.0, OpenCode 1.18.11** — every one read from the CLI itself. Codex moved from `validated_against: 0.40.0` to 0.146.0; `supported_min` stays 0.40.0. Reviewed the Claude Code 2.0.0 → 2.1.220 changelog for marketplace-facing changes: `marketplace.json` stays valid, no renamed plugins (so the 2.1.191 `renames` map is not needed), and no reliance on removed features. `supported_min` stays 2.0.0.
- `AGENTS.md` now names the four targets and requires verifying that a new entry's source repo actually resolves before adding it.

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

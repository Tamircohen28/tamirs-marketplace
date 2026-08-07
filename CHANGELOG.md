# Changelog

All notable changes to the tamirs-plugins catalog are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

### Changed
- **Platform target: Claude Code 2.1.224** (from 2.1.223). Docs-only bump. Two items in
  the 2.1.224 delta touch marketplace docs: (1) the new **`archive` plugin source** —
  plugins can be installed from a zip over HTTPS, without git or npm, with optional
  SHA-256 pinning — is documented in concepts and the Claude Code install guide as a
  distribution channel that exists alongside the git-pinned `github` sources this catalog
  uses (the catalog itself does not publish archive sources, so `marketplace.json` is
  unchanged); (2) the fix for **plugin install records being silently corrupted when the
  same plugin is installed in multiple projects** gets a troubleshooting entry — on
  2.1.224+ the corruption no longer happens, and a reinstall clears state broken by older
  versions. The rest of the delta (self-hosted runners, cross-session messaging,
  sandbox credential masking, subagent-cap removal) is not marketplace-facing.

- **Platform target: Claude Code 2.1.223** (from 2.1.222). Docs-only bump. The one
  marketplace-facing item in the 2.1.223 delta is adopted: `strictKnownMarketplaces`
  and `blockedMarketplaces` managed settings now accept **owner wildcards**
  (`"Tamircohen28/*"`), so the Claude Code install guide gains a "Managed (enterprise)
  environments" section showing admins how to allowlist this catalog and every
  standalone plugin marketplace it points at in one entry, recorded as
  `owner-wildcard-managed-allowlist-2.1.223` in `platform-targets.json`. The rest of
  the delta is security/fix-focused (permission-prompt spoofing fixes, a Bash
  permission bypass, a workflow sandbox escape) and needs no catalog change —
  `marketplace.json` stays valid, and the `/review` → `/code-review` consolidation
  touches nothing here.

- **Platform target: Claude Code 2.1.222** (from 2.1.220). Docs-only bump reflecting two
  2.1.221 install-flow improvements: plugins installed with `/plugin install` now activate
  immediately when safe (no new session / `/reload-plugins` needed), and `/plugin install`
  refreshes a stale marketplace catalog and retries before reporting a plugin not found.
  Install guides, quick-start, troubleshooting, and `platform-targets.json` updated; the
  older-version guidance is kept for users below 2.1.221. The 2.1.222 delta contains
  nothing marketplace-facing — `marketplace.json` stays valid and no catalog change is
  needed. Also reviewed against 2.1.221's `claude plugin validate` naming warnings
  (names that Claude Desktop's managed marketplace sync would reject): the catalog name
  `tamirs-plugins` and all three plugin names are lowercase-hyphen and pass.

## [1.3.0] — 2026-08-03

### Added
- **OpenCode as a fourth supported target.** The four targets this catalog and every plugin in it support are now **Claude Code, Cursor, Codex, and OpenCode**, recorded as `supported_targets` in `platform-targets.json`. OpenCode has no plugin marketplace and no plugin manifest format, so this catalog **cannot** be installed there — each plugin repo is installed directly and OpenCode discovers its skills natively via the `opencode.json` each one ships. Tracked under `targets.opencode.capability_gaps` rather than left implicit.
- **`docs/user/install/` — a detailed guide per target** (`claude-code.md`, `cursor.md`, `codex.md`, `opencode.md`, plus an index). Each has a validated-against/minimum header, prerequisites, install methods, what you get, verification, update, uninstall, and a troubleshooting table.
- `platform-targets.json` schema 1 → 2: `supported_targets` makes the enforced target list data-driven, plus `supported_min_source`, `verified_on`, `verification_method`, `install_doc`, and `capabilities` per target. `scripts/check-platform-targets.sh` reads that list (with a legacy three-target fallback), so adding a fifth target needs no script change.
- `--sync` now refreshes `latest_known` from npm for Claude Code (`@anthropic-ai/claude-code`) and OpenCode (`opencode-ai`), alongside the existing Codex GitHub-releases lookup. Cursor has no public version endpoint and stays manual.
- **Docs: plugin discovery via newer Claude Code CLI/UI (2.1.157–2.1.172).** Quick-start now points at the `/plugin` marketplace search bar, `claude plugin list --enabled/--disabled` filters for the verify step, and the Installed tab's Skills section.
- **Docs: `pluginSuggestionMarketplaces` for teams (2.1.152).** Concepts explains that org admins can allowlist `tamirs-plugins` so Claude Code surfaces its plugins as context-aware suggestions inside the organization.

### Fixed
- **The Codex install commands in the README, quick-start, and concepts could never have worked.** They documented `codex plugin install <name> --source plugins`; Codex 0.146.0 has no `install` subcommand and no `--source` flag. Verified against `codex plugin add --help`. Corrected everywhere to `codex plugin add <name>@tamirs-plugins` and `codex plugin list --marketplace tamirs-plugins`.
- **Removed the dead `production-master` catalog entry.** It pointed at `ProductionMasterAI/production-master-intel`, which 404s. `codex plugin add production-master@tamirs-plugins` failed with `remote: Repository not found` — the entry listed cleanly and then broke at clone time, which is the worst way for it to fail.
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

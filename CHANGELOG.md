# Changelog

All notable changes to the tamirs-marketplace catalog are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

### Changed
- **Platform target: Claude Code 2.1.234** (from 2.1.233). Docs-only bump. The 2.1.234
  delta reviewed against the catalog surface: `.claude-plugin/marketplace.json` stays
  valid as `github` sources, no schema change, nothing removed is relied on, and no
  marketplace-facing behavior changed. One entry extends documentation already in the
  install guide: the **GitLab MR footer/statusline badge** — an open GitLab MR for the
  current branch now also shows as a badge in the footer/statusline, alongside the
  2.1.233 `--worktree`/`claude agents` MR support already documented. The rest of the
  delta (`CLAUDE_CODE_PROJECT_DIR_NAME`, `selection:clear` keybinding, auto-continue on
  usage-limit reset, account-email-only identification, Windows NT-namespace path-read
  hardening, Remote Control cross-session/org-switch sync, claude-api skill context
  reduction, `/permissions`/`/add-dir` usable mid-turn, `/goal` improvements, removal of
  the "Default teammate model" setting, and background-task notifications moving to
  system-reminders) is host/session-side and touches nothing this catalog documents or
  ships.

### Added
- **`make validate-skills`: native skill frontmatter validation (Claude Code
  2.1.233).** 2.1.233 makes `claude plugin validate` check bare `.claude/skills`
  directories and report `SKILL.md` files whose frontmatter fails to parse. This
  new target runs `claude plugin validate --strict .agents/skills`, catching a
  frontmatter regression in this catalog's contributor skill
  (`run-plugins-catalog`) before it silently fails to load, instead of relying on
  manual review. It soft-skips if the `claude` CLI isn't installed locally
  (documented in `AGENTS.md` and `docs/agent-guidelines/testing.md`). **Not yet a
  CI job** — this automation's GitHub App token has no `workflows` scope, so it
  cannot push a `.github/workflows/*.yml` change; wiring `make validate-skills`
  into CI is a one-job follow-up for a human edit.

### Changed
- **Platform target: Claude Code 2.1.233** (from 2.1.232). Docs-only bump plus the
  `make validate-skills` addition above. The 2.1.233 delta reviewed against the catalog surface:
  `.claude-plugin/marketplace.json` stays valid as `github` sources, no schema
  change, nothing removed is relied on. Two entries are documented: the skill
  frontmatter validation described above, and **GitLab merge-request URL support**
  for `--worktree` and the `claude agents` view (MRs display as `!N`) — noted in
  the install guide's plugin-sources section as orthogonal to marketplace installs
  but relevant to anyone working against a GitLab mirror of a plugin repo. Also
  reviewed, host-side with no catalog-facing change: the bundled-skill-alias fix
  for `/checkup` and `/review` reporting "Unknown command" when shadowed by a
  same-named user/project skill (this catalog's plugins don't ship skills named
  `checkup` or `review`, so nothing here was affected, but it's noted in
  troubleshooting for completeness).
- **Platform target: Claude Code 2.1.232** (from 2.1.231). Docs-only bump. The
  2.1.232 delta reviewed against the catalog surface:
  `.claude-plugin/marketplace.json` stays valid as `github` sources, no schema
  change, nothing removed is relied on. Three entries are marketplace-facing and
  are now documented in the Claude Code install guide: **`/plugin install
  plugin@marketplace` refreshes the marketplace first** (troubleshooting now
  gives the version-scoped story: refresh-first on 2.1.232+, refresh-and-retry
  on 2.1.221–2.1.231, manual `marketplace update` before that); **settings
  aliases** — `additionalMarketplaces` / `allowedMarketplaces` accepted as
  friendlier names for `extraKnownMarketplaces` / `strictKnownMarketplaces`
  (managed-environments section shows both spellings, keeping the old names for
  configs that must run on older versions), plus the url-typed
  `blockedMarketplaces` entry now blocking a bare repo URL even when classified
  as a git clone; and **GitLab marketplace sources** — bare `gitlab.com` repo
  URLs (including nested subgroups) clone like `github.com` URLs, noted in the
  plugin-sources section for anyone mirroring this catalog into a GitLab group
  (the catalog itself stays on GitHub). Also now in troubleshooting: the
  2.1.232 fix for a startup race that could silently unregister a marketplace
  via concurrent `known_marketplaces.json` writes. The rest of the delta
  (session naming and `@`-mentions, subagent forking, GitLab token redaction,
  Remote Control and gateway fixes, sandbox `ripgrep` scoping) is host-side and
  touches nothing this catalog documents.
- **Platform target: Claude Code 2.1.231** (from 2.1.228). Docs-only bump. The
  2.1.229 + 2.1.231 delta (no 2.1.230 entry was published) reviewed against the
  catalog surface: `.claude-plugin/marketplace.json` stays valid as `github`
  sources, no schema change, nothing removed is relied on. One entry is
  marketplace-facing and is now documented: **plugin marketplace `command` sources
  (2.1.229)** — a local command prints the plugin directory, re-resolved at each
  session start and applied without a restart, with `mode: "link"` using the
  directory in place. The install guide's plugin-sources section now covers all
  three source types (git, archive 2.1.224+, command 2.1.229+) and points plugin
  developers at command-source link installs instead of hand-editing the plugin
  cache; the catalog's own entries deliberately stay `github` sources, since a
  published catalog must resolve on machines that don't have the plugins checked
  out. Also reviewed, host-side with no catalog change: both releases' MCP OAuth
  redirect-URI fixes, the `/install-github-app` review-workflow fix (this repo
  uses plain CI, not the generated review workflow), marketplace-unrelated crash
  and rendering fixes, and the `/commit-push-pr` auto-approval tightening.
- **Platform target: Claude Code 2.1.228** (from 2.1.226). Docs-only bump. The
  2.1.227 + 2.1.228 delta reviewed against the catalog surface:
  `.claude-plugin/marketplace.json` stays valid, no plugin renames needed, and
  nothing removed is relied on. One entry is marketplace-facing and now documented
  in the Claude Code install guide's managed-environments section: **2.1.228 makes
  marketplace entries merge as whole entries across settings tiers** — previously a
  marketplace redefined in a higher-precedence settings file could inherit another
  tier's custom headers. Also relevant to plugin authors working out of this
  catalog: 2.1.228's background plugin-cache cleanup no longer deletes a plugin's
  cache when its only version is a symlinked development checkout. The rest of the
  delta (self-hosted-runner, Remote Control, and cross-session-messaging fixes, a
  Write-tool rule change for newer models, slash-command menu polish) is host-side
  and touches nothing this catalog documents.
- **Cursor Origin + Builds default (2026-08-17).** Documented [Origin](https://cursor.com/docs/origin) (early-beta Cursor git forge; GitHub remains canonical for this catalog / `Tamircohen28/plugins` redirect) and flipped Cloud Agent Builds language to **now default**. Cursor-only pin bump: `changelog_date` **2026-08-13 → 2026-08-17**; desktop **3.16.17** / feature **3.11** unchanged.
- **Cursor Grok 4.6 + Builds T-1 readiness (2026-08-16).** Install guide documents Grok 4.6 and a T-1 Builds checklist before **2026-08-17**. Cursor-only pins stay **3.16.17** / **3.11** / **2026-08-13**.
- **Cursor desktop 3.16.17 + Builds skipped/staleness docs.** Desktop/`validated_against` pin **3.15.19 → 3.16.17**; install guide documents Builds Skipped checks, 24h staleness default, and install/start/terminals. Feature/date pins stay **3.11** / **2026-08-13**.
- **Cursor Builds Aug-17 readiness + CLI steer/`/goal`.** Install guide documents enable-Builds-now (default **2026-08-17**), team/environment secrets for Builds, CLI steer-while-running, and durable `/goal`. Cursor-only pins stay **3.16.17** / **3.11** / **2026-08-13**.
- **Cursor CLI Aug 11 advancement.** Install guide documents CLI sticky skills and that installed-plugin hooks execute in Cursor CLI once catalogued plugins ship Cursor-native hooks. `cli_changelog_date: 2026-08-11` in `.cursor-version`.
- **Cursor changelog through 2026-08-13 (Cloud Agent Builds).** `.cursor-version` / cursor-only `platform-targets.json` fields keep desktop **3.16.17** + feature **3.11** and advance `changelog_date` to **2026-08-13**. Install guide documents Cloud Agent Builds.
- **Cursor desktop pin → 3.16.17.** `.cursor-version`, cursor fields in `platform-targets.json`, README badge, and install docs track desktop **3.16.17**. Changelog feature coverage remains **3.11** / **2026-08-03**.
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

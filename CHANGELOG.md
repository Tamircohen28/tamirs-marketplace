# Changelog

All notable changes to the tamirs-marketplace catalog are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

### Added
- **Marketplace-refresh-race plugin-skills fix documented (Claude Code 2.1.251).**
  Before 2.1.251, a background session could start with zero plugin skills loaded
  — and stay that way — if another Claude Code process was refreshing the plugin
  marketplace at the same moment. Directly relevant to anyone running multiple
  Claude Code sessions against plugins installed from this catalog. Documented as
  a new Troubleshooting row and in the install guide's new "2.1.248 – 2.1.251"
  section.
- **GitLab `--worktree --tmux` fetch fix documented (Claude Code 2.1.251).** A
  `gitlab.com`-origin worktree no longer tries a doomed GitHub-style fetch first;
  it fetches the GitLab ref directly. Documented alongside the existing GitLab
  marketplace/worktree guidance in the install guide's plugin-sources section.
- **MCP `headersHelper` OAuth-retry-on-401 fix documented (Claude Code 2.1.248).**
  A `headersHelper` that supplies the `Authorization` header is now re-run and the
  call retried on a 401 instead of falling into OAuth discovery — matching what
  this guide always documented `headersHelper` to do. Noted alongside the
  existing `headersHelper` coverage in the install guide's plugin-sources section.
- **Version-less marketplace plugin cache directory fix documented (Claude Code
  2.1.247).** Before 2.1.247, installing a marketplace plugin that has no `version`
  field — installing it into a **second scope** (for example project-scope after an
  earlier user-scope install, or the reverse) could delete the cache directory the
  first scope's install was using. This is directly relevant here: none of this
  catalog's three plugin entries declare a `version` field in
  `.claude-plugin/marketplace.json` (confirmed — `tamirs-superpowers`,
  `jose-claudinho`, and `headhunter` each carry only `name`/`source`/`description`),
  so every install from this catalog is exactly the version-less case the bug
  describes. Fixed in 2.1.247 — documented as a new Troubleshooting row and a note
  in the install guide's Install section for anyone still on an older CLI who
  installs the same catalog plugin in more than one scope.
- **`claude plugin update <name>` bare-name fix and install-error fix documented
  (Claude Code 2.1.246).** `claude plugin update` now works given just a plugin's bare
  name, not only the fully-qualified `name@marketplace` form — documented in the
  install guide's Update section. `claude plugin install <name>` also now reports a
  clear error instead of exiting silently when `~/.claude/plugins/known_marketplaces.json`
  is missing or corrupted — added as a new Troubleshooting row.
- **`managed` connector marker documented (Claude Code 2.1.243).** `/mcp` and
  `/plugins` now show a `managed` badge next to a connector whose authentication
  is centrally controlled by an organization. Documented in the install guide
  right alongside the `name@synced` note, since both are about how Claude Code
  labels a plugin's *auth/source* metadata, not about anything this catalog's
  `.claude-plugin/marketplace.json` needs to change — a plugin installed from
  here via `/plugin install <name>@tamirs-marketplace` is a plain marketplace
  install and doesn't acquire the `managed` label on that basis alone.
- **`name@synced` non-override guarantee documented (Claude Code 2.1.239).** Since
  2.1.239, a plugin synced from claude.ai into a cloud session shows up as
  `name@synced` and works with `claude plugin enable/disable name@synced` — and it
  never overrides a same-named plugin installed from a marketplace like this one.
  Documented in the install guide as reassurance that `tamirs-superpowers@tamirs-marketplace`
  (or any plugin from this catalog) coexists safely with a claude.ai-synced plugin of
  the same name rather than either silently replacing the other.
- **`headersHelper` for marketplace/catalog entries documented (Claude Code
  2.1.238).** A url-typed marketplace or a catalog/`archive`-source entry can now
  declare a `headersHelper` command that mints HTTP headers (e.g. a short-lived
  token) for the catalog fetch and same-origin archive downloads, run only at
  install/update with a `[y/N]` confirmation (or `-y`). Documented in the install
  guide's plugin-sources section as an available capability for a future
  private/token-gated entry — this catalog's `github`-source entries are all
  public, so `.claude-plugin/marketplace.json` itself needs no change. Also noted:
  since 2.1.238, an MCP server's own `headersHelper` (in a project `.mcp.json`, a
  plugin, or an agent file) requires trust-dialog acceptance and runs without
  inherited credential env vars.

### Changed
- **Platform target: Claude Code 2.1.252 — `validated_against` and `latest_known`
  both 2.1.252**, real direct CLI check for the fourth run in a row (`claude
  --version` on this run's runner reports 2.1.252). `claude plugin validate
  --strict .agents/skills` and a full `make validate` (regenerate + validate
  manifests, 3 plugins in sync, no drift) both passed clean against the live
  2.1.252 CLI. The 2.1.252 changelog delta — four bug fixes, no Added/Improved/
  Changed entries — was reviewed line-by-line against the catalog surface and
  found to have **zero marketplace-manifest impact**: the Bash "task output swap
  refused (tasks dir moved or linked)" fix (macOS Bash-tool internals), the
  "always allow" not saving in a project with no `.claude/settings.local.json`
  yet (host permission-settings persistence), the Remote Control stalling fix for
  Claude Desktop/VS Code-hosted sessions, and the background-task-notification
  API-request-size-limit fix are all host/CLI-side with no plugin, marketplace,
  or skill-loading surface. Re-confirmed still not applicable: the 2.1.251
  plugin-command path-traversal rejection — checked again directly against
  `.claude-plugin/marketplace.json`, none of this catalog's three plugin entries
  declare a `commands` field. No new Troubleshooting rows or install-guide
  sections were needed for this delta.
- **Platform target: Claude Code 2.1.251 — `validated_against` and `latest_known`
  both 2.1.251**, real direct CLI check for the third run in a row (`claude
  --version` on this run's runner reports 2.1.251). `claude plugin validate
  --strict .agents/skills` and a full `make validate` (regenerate + validate
  manifests, 3 plugins in sync, no drift) both passed clean against the live
  2.1.251 CLI. The 2.1.248 → 2.1.251 changelog delta (2.1.249/2.1.250 published no
  changelog specifics beyond "bug fixes and reliability improvements") was
  reviewed line-by-line against the catalog surface. Three items are directly
  about marketplace/catalog/worktree behavior and got a real check against this
  repo, not a rubber stamp: **plugin-command path-traversal rejection** (2.1.251)
  — checked directly against `.claude-plugin/marketplace.json`, none of this
  catalog's three plugin entries declare a `commands` field, so not applicable;
  the **marketplace-refresh-race plugin-skills fix** (2.1.251) — catalog-facing,
  see Added above; and the **GitLab `--worktree --tmux` fetch fix** (2.1.251) —
  see Added above. Also checked: the 2.1.248 MCP `headersHelper` OAuth-retry fix
  (see Added above) and 2.1.248's `experimental.cacheTtl` agent-frontmatter
  setting — this catalog ships no agent definitions of its own, only the
  `run-plugins-catalog` contributor skill, so not applicable. Everything else in
  2.1.248–2.1.251 (`--restricted` mode, `PreModelSwitch`/`PostModelSwitch` hooks,
  live subagent tool-call streaming to Remote Control, the `/usage` spend-limit
  bar and `/cost` prompt-cache line, `claude --help` subcommands, symlink/Grep-
  Glob-deny-rule/Workflow-`scriptPath` security fixes with no plugin-loading
  surface, self-hosted-runner and `claude agents` UI/reliability fixes,
  cross-session messaging on Bedrock/Vertex/Foundry, Remote Control and
  cloud-session fixes, and analytics/gateway/sandbox-settings changes) is
  host/CLI/session-side with no marketplace-manifest surface.
- **Platform target: Claude Code 2.1.247 — `validated_against` and `latest_known`
  both 2.1.247**, real direct CLI check for the second run in a row (`claude
  --version` on this run's runner reports 2.1.247). `claude plugin validate --strict
  .agents/skills` and a full `make validate` (regenerate + validate manifests, 3
  plugins in sync, no drift) both passed clean against the live 2.1.247 CLI. The
  2.1.247 changelog delta was reviewed line-by-line against the catalog surface.
  Two items are directly about marketplace/catalog behavior and got a real check
  against this repo, not a rubber stamp: the **version-less plugin cache directory
  fix** — catalog-facing, see Added above, since all three of this catalog's plugin
  entries omit `version`; and **marketplace hardening (control/invisible character
  rejection, escape-safe text)** — checked directly against every plugin `name` and
  `description` string in all three manifests with a Unicode category scan (category
  `C*`, i.e. control/format/surrogate/private-use/unassigned) — **zero hits**, so
  this catalog's entries were already clean and the new host-side rejection changes
  nothing here. Also checked: the `/claude-api` skill Admin API coverage and the new
  `/claude-api cost-optimize` subcommand — this catalog ships no `claude-api` skill
  and no Python/Anthropic-SDK code of its own (unlike a repo that ships plugin
  source), so not applicable, matching the same non-applicability already
  established for sibling catalog-only repos. Everything else in 2.1.247 (the
  `SendFeedback` tool, `spinnerTipsOverride`/`tipsFile` tip rotation, the Bash
  permission-prompt auto-mode tip, arrow-key/history-search input fixes, sub-agent
  model-404 fallback-chain fix, hook/background-agent error-output overflow fix,
  non-Latin Ctrl-shortcut and split mouse-report fixes, Bash sandbox dotfile-symlink
  fix, `/terminal-setup` Zed keymap merge fix, `/rename` silent-confirm fix,
  `/compact`/"Summarize from here" system-prompt fix, background-session
  "opening…" and unbounded-memory-growth fixes, `/install-github-app` SSH messaging,
  background-session shell-logging fix, Remote Control diff reporting, self-hosted
  runner status timing, first-run managed-gateway connectivity fix, cloud-session
  permission-mode display and container-restart fixes, Bedrock/Vertex/Foundry
  MCP-failure messaging, Sonnet 5's full-1M auto-compact window, cross-session
  peer-message collapse, terminal hyperlink/control-character rendering, the PR-badge
  refresh-skip, and the analytics/gateway/sign-in changes) is host/CLI/session-side
  with no marketplace-manifest surface.
- **Platform target: Claude Code 2.1.246 — `validated_against` and `latest_known`
  equal again** (from `validated_against` 2.1.241 / `latest_known` 2.1.245). A live
  `claude` CLI was available this run and reports 2.1.246, so this is a real direct
  validation, not a changelog-only bump — closing the gap the previous two runs left
  open. `claude plugin validate --strict .agents/skills` and a full `make validate`
  (regenerate + validate manifests) both passed clean against the live 2.1.246 CLI.
  The 2.1.246 delta was reviewed against the catalog surface: the plugin-update
  bare-name fix and the marketplace-install error fix (see Added, above); a plugin.json
  UTF-8 BOM install-breaking bug, checked directly — no manifest in this repo carries a
  BOM (`.claude-plugin/marketplace.json`, `.cursor-plugin/marketplace.json`,
  `.agents/plugins/marketplace.json` all start with a bare `{`), and this catalog ships
  no `plugin.json` of its own; a `/reload-plugins` fix for a plugin's `skills/*/SKILL.md`
  layout, checked — this catalog's own skill lives in a bare `.agents/skills` directory,
  not a plugin's `skills/` tree, so unaffected; a skill-frontmatter `<plugin>:`
  name-doubling fix, checked — this catalog's skill frontmatter carries no plugin-name
  prefix, so unaffected. Everything else in 2.1.246 (an Auto mode `/permissions` tab, a
  plugin-cache duplicate-SHA-directory fix, hook-error `${CLAUDE_PLUGIN_ROOT}`
  resolution, an MCP `requiresUserInteraction` permission-prompt fix, subagent
  partial-output-on-`maxTurns`, deferred managed-settings consent prompts, and OTel
  `plugin_id_hash`/`enabled_via` changes) is host/CLI-side with no marketplace-manifest
  surface.
- **Platform target: Claude Code `latest_known` 2.1.245** (from 2.1.241; `validated_against`
  stays 2.1.241 — this run had no live CLI to re-check against, so it advances only the
  changelog-reviewed figure rather than claiming a validation that didn't happen). The
  2.1.242–2.1.245 delta was reviewed against the catalog surface: 2.1.245 (a Linux
  glibc 2.44 startup crash fix, host binary, no catalog impact), 2.1.244/2.1.242 (no
  separately documented changes), and 2.1.243 (the `managed` connector marker — see
  Added, above; a plugin-dependency-with-`marketplace`-field resolution fix scoped to
  dev-time `--plugin-dir` loading, which doesn't affect this catalog's normal install
  path even though `allowCrossMarketplaceDependenciesOn` uses that dependency
  mechanism; a `/reload-plugins` LSP-tool fix, not applicable — no plugin here ships
  an LSP integration). `claude plugin validate --strict .agents/skills` last passed
  clean against the live 2.1.241 CLI on 2026-08-23; not re-run this cycle.
- **Platform target: Claude Code 2.1.241** (from 2.1.238), verified directly from
  `claude --version` on the maintainer machine rather than changelog review alone.
  The 2.1.239 (`name@synced` plugin naming and non-override guarantee, Windows
  cross-session messaging) and 2.1.240/2.1.241 (bug fixes and reliability
  improvements, no changelog specifics) deltas were reviewed against the catalog
  surface. Only 2.1.239's `name@synced` guarantee is catalog-facing (see Added,
  above). `claude plugin validate --strict .agents/skills` re-ran clean on 2.1.241.
- **Platform target: Claude Code 2.1.238** (from 2.1.235, closing the 2.1.236 gap
  opened last run). `validated_against` and `latest_known` are equal again. The
  2.1.236 (`ANTHROPIC_DEFAULT_MODEL`, `notify_when_idle` for cross-session
  `SendMessage`, macOS sandbox wildcard-deny precedence fixes), 2.1.237 (built-in
  Concise output style, LLM-gateway prompt-cache fix) and 2.1.238
  (`keybindingFlavor`, marketplace/catalog `headersHelper`, output-style
  mid-session drift fix, stdio MCP `server/discover`-before-`initialize` fix,
  `claude mcp list`/`get` disabled-server display) deltas were all reviewed
  against the catalog surface. Only `headersHelper` is catalog-facing (see Added,
  above); everything else is editor/host/session-side and touches nothing this
  catalog documents or ships. The `known_marketplaces.json` startup-race fix that
  2.1.238's notes mention was already documented here under 2.1.232, where it
  first shipped — no new entry needed.
- **Platform target: Claude Code 2.1.235** (from 2.1.234). Docs-only bump. The 2.1.235
  delta reviewed against the catalog surface: `.claude-plugin/marketplace.json` stays
  valid as `github` sources, no schema change, nothing removed is relied on, and no
  marketplace-facing behavior changed. The full delta — the opt-in `spellcheck` setting,
  improved permission dialogs and context-limit error messages, Vim mode preserving
  NORMAL mode/cursor position across transcript toggles, and `claude rc` enterprise-gateway
  availability checks for Remote Control, plus the accompanying bug fixes (prompt-cache
  invalidation, nested markdown lists, Shift+Tab permission prompts, notebook approval
  dialogs, slash-command HTML entities, task-list collapse state, cloud session
  memory/CPU) — is editor/host-side and touches nothing this catalog documents or ships.
  `npm` already publishes **2.1.236**, but its changelog entry isn't live yet, so
  `latest_known` is bumped to 2.1.236 while `validated_against` holds at 2.1.235 until
  a future nightly run can read the 2.1.236 delta.
- **Platform target: Claude Code 2.1.234** (from 2.1.233). Docs-only bump. The 2.1.234
  delta reviewed against the catalog surface: `.claude-plugin/marketplace.json` stays
  valid as `github` sources, no schema change, nothing removed is relied on. One entry
  extends documentation already in the install guide: the **GitLab MR footer/statusline
  badge** — an open GitLab MR for the current branch now also shows as a badge in the
  footer/statusline, alongside the 2.1.233 `--worktree`/`claude agents` MR support
  already documented. The rest of the delta (`CLAUDE_CODE_PROJECT_DIR_NAME`,
  `selection:clear` keybinding, auto-continue on usage-limit reset,
  account-email-only identification, Windows NT-namespace path-read hardening, Remote
  Control cross-session/org-switch sync, claude-api skill context reduction,
  `/permissions`/`/add-dir` usable mid-turn, `/goal` improvements, removal of the
  "Default teammate model" setting, and background-task notifications moving to
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

# Changelog

All notable changes to the tamirs-marketplace catalog are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

### Added
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

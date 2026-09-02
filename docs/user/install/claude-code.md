# Install — Claude Code

| | |
|---|---|
| **Validated against** | Claude Code **2.1.257** |
| **Minimum supported** | **2.0.0** |
| **Marketplace manifest** | `.claude-plugin/marketplace.json` (canonical) |
| **Official docs** | [Marketplaces](https://code.claude.com/docs/en/plugin-marketplaces) · [Plugins reference](https://code.claude.com/docs/en/plugins-reference) |

Check your version:

```bash
claude --version
```

## Prerequisites

- Claude Code 2.0.0 or newer — 2.1.257 is what this release was validated on
- Nothing else. Installing plugins needs no Python and no clone; Python 3 is a
  **contributor**-only dependency for `make generate`.

## Install

```bash
# 1. Add the catalog
claude plugin marketplace add Tamircohen28/tamirs-marketplace

# 2. Install the plugins you want
claude plugin install tamirs-superpowers@tamirs-marketplace
claude plugin install jose-claudinho@tamirs-marketplace
claude plugin install headhunter@tamirs-marketplace

# 3. Verify
claude plugin list
```

> **Installing a catalog plugin in more than one scope?** Before Claude Code 2.1.247,
> installing a plugin that declares no `version` field into a **second scope** (say,
> project-scope after an earlier user-scope install, or the reverse) could delete the
> cache directory the first scope's install was using. None of this catalog's three
> plugins declare a `version` field, so this applied to every plugin here. Fixed in
> 2.1.247 — on an older CLI, avoid installing the same catalog plugin into two scopes
> at once, or upgrade first.

Inside an interactive session, the slash-command equivalent:

```text
/plugin marketplace add Tamircohen28/tamirs-marketplace
/plugin install tamirs-superpowers@tamirs-marketplace
/doctor
```

Since Claude Code 2.1.221, plugins installed with `/plugin install` activate immediately
when safe — no new session needed. On older versions (or when instant activation isn't
safe), open a **new** session after installing — skills load at session start.

## What you get

| Plugin | What it adds |
|--------|--------------|
| `tamirs-superpowers` | 26 skills, worktree hooks, statusline, MCP server stubs |
| `jose-claudinho` | Fantasy World Cup 2026 manager — market/team/league MCP tools |
| `headhunter` | Job-search CRM — pipeline, interviews, Gmail/Calendar/Notion/Todoist |

Each plugin's own repo documents its skills, commands, and integrations in detail.

## Useful flags (2.1.163+)

- `/plugin` has a **search bar** when browsing the marketplace — type instead of scrolling.
- `claude plugin list --enabled` / `--disabled` filters the verify step to what's active.
- The `/plugin` Installed tab has a **Skills** section listing every skill each plugin
  contributes.
- `claude plugin details <name>` prints a component inventory and projected token cost.

## Update

```bash
claude plugin marketplace update tamirs-marketplace
claude plugin update tamirs-superpowers@tamirs-marketplace
```

> **Claude Code caches installed plugins by the `version` field in the plugin's
> `plugin.json`.** If a plugin release did not bump its version, `plugin update` is a no-op
> — you stay on the cached copy. `/reload-plugins` does **not** re-fetch from GitHub; it
> only reloads what is already cached.

Since Claude Code 2.1.246, `claude plugin update <name>` also works given just the
plugin's **bare name** — before, only the fully-qualified `name@marketplace` form
resolved, and `claude plugin update tamirs-superpowers` (without `@tamirs-marketplace`)
failed. Both forms now work; the fully-qualified form above stays the recommended one
when a plugin name might exist in more than one marketplace you've added.

Updating the *catalog* (`marketplace update`) refreshes the plugin list — which plugins
exist and where they point. Updating a *plugin* fetches its source.

### Plugins synced from claude.ai (2.1.239+)

Since Claude Code 2.1.239, a plugin synced into a cloud session from claude.ai shows up
as `name@synced` — a distinct install source from `name@tamirs-marketplace` — and it
works with `claude plugin enable/disable name@synced` like any other install. Critically,
a `@synced` plugin **never overrides** a same-named plugin you installed from a
marketplace. So if you've installed `tamirs-superpowers@tamirs-marketplace` and later a
cloud session also syncs a plugin named `tamirs-superpowers` from claude.ai, the two
coexist as separate entries (`tamirs-superpowers@tamirs-marketplace` and
`tamirs-superpowers@synced`) rather than one silently replacing the other. Nothing to do
here — just don't be surprised to see both listed in `claude plugin list`.

Since Claude Code 2.1.243, `/mcp` and `/plugins` also show a **`managed`** marker next to
a connector whose authentication your organization controls centrally. That marker is
about *auth management*, not install source — a plugin installed from this catalog via
`/plugin install <name>@tamirs-marketplace` is a plain marketplace install either way, and
never shows as `managed` on that basis alone.

## Installing a plugin standalone instead

Every plugin in this catalog also carries its own `.claude-plugin/marketplace.json`, so you
can skip the catalog entirely:

```text
/plugin marketplace add TamirCohen28/headhunter
/plugin install headhunter@headhunter
```

## Plugin sources: git, archive, and command (2.1.224+ / 2.1.229+)

Every entry in this catalog is a `github` source pinned to a branch — installing fetches
the plugin's repo over git, and `plugin update` tracks that branch. Since Claude Code
2.1.224, marketplaces can alternatively distribute a plugin as an **`archive` source**: a
zip downloaded over HTTPS, with no git or npm required and optional SHA-256 pinning for
integrity. Since 2.1.229 there is also a **`command` source**: a local command prints the
plugin directory, the result is re-resolved at every session start and applied without a
restart, and `mode: "link"` uses the printed directory in place — built for cases where
another tool (an IDE, a monorepo script, a dev clone) owns the plugin's location. This
catalog itself offers neither — its entries stay `github` sources, and nothing changes
for installs from here — but plugin *developers* working on any plugin in this family
should prefer a local command-source entry with `mode: "link"` over hand-editing the
plugin cache; each plugin repo's development docs cover the pattern.

Since Claude Code 2.1.232, marketplaces themselves can also live on **GitLab**: a bare
`gitlab.com` repo URL (including nested subgroups) passed to `/plugin marketplace add`
clones just like a `github.com` URL, and clone auth-failure hints now name your actual
git host. This catalog stays on GitHub — nothing changes for installs from here — but
if you mirror or fork this catalog into a GitLab group, the mirror is now addable
directly by its repo URL. Since 2.1.233, GitLab merge-request URLs are also accepted by
`--worktree` and shown in the `claude agents` view (as `!N`) — orthogonal to marketplace
installs, but relevant if you work against a GitLab mirror of a plugin repo. Since 2.1.234,
an open GitLab MR for the current branch also shows as a badge in the footer/statusline,
extending the same MR-awareness to the session UI. Since 2.1.251, `--worktree --tmux`
against a `gitlab.com`-origin repo fetches the GitLab ref directly instead of first
attempting a doomed GitHub-style fetch — a startup-latency fix for anyone driving a
GitLab mirror of a plugin repo this way.

Since Claude Code 2.1.238, a **url-typed marketplace** or a catalog/`archive`-source entry
can declare a `headersHelper` — a local command that mints HTTP headers (for example a
short-lived token) for the marketplace catalog fetch and any same-origin archive downloads.
It runs only at install/update time, and Claude Code shows a `[y/N]` confirmation before
running it (skippable with `-y`). This catalog's entries are all public `github` sources —
no auth is needed to fetch them, so nothing in `.claude-plugin/marketplace.json` uses
`headersHelper` today — but it's now the documented answer if a future plugin here (or a
fork of this catalog) needs a private or token-gated archive/catalog source. Separately,
since 2.1.238 an MCP server's own `headersHelper` (in a project `.mcp.json`, a plugin, or
an agent file) requires trust-dialog acceptance and runs without inherited credential
env vars — relevant to `tamirs-superpowers`' MCP server stubs if any of them add header-based
auth, though none currently do. Since 2.1.248, a `headersHelper` that supplies the
`Authorization` header no longer falls into OAuth discovery on a 401 — the helper is
re-run and the call retried, matching how this was always documented to behave. Since
2.1.257, MCP connection and OAuth debug/error logs also redact any credentials carried
in a server's URL or request headers — hardening the same mechanism for whenever a
future private/token-gated entry here does put a token in a `headersHelper` response.

## Uninstall

```bash
claude plugin uninstall headhunter@tamirs-marketplace
claude plugin marketplace remove tamirs-marketplace
```

## Managed (enterprise) environments

Since Claude Code 2.1.223, the `strictKnownMarketplaces` and `blockedMarketplaces`
managed settings accept **owner wildcards**. An admin who wants to allow this catalog
*and* every standalone plugin repo it points at can allowlist the owner once instead
of enumerating repos:

```json
{ "strictKnownMarketplaces": ["Tamircohen28/*"] }
```

That covers `Tamircohen28/plugins` (this catalog) plus the standalone marketplaces the
plugins ship themselves (e.g. `Tamircohen28/tamirs-superpowers`, `TamirCohen28/headhunter`).
On versions older than 2.1.223, list each repo explicitly. The same wildcard form works
in `blockedMarketplaces`.

Since Claude Code 2.1.232, settings files also accept **`allowedMarketplaces`** as a
friendlier alias for `strictKnownMarketplaces`, and **`additionalMarketplaces`** as an
alias for `extraKnownMarketplaces` — the example above can be written
`{ "allowedMarketplaces": ["Tamircohen28/*"] }` on 2.1.232+. The original names keep
working, so settings that must run on older versions should stay on them. Also since
2.1.232, a url-typed `blockedMarketplaces` entry for a bare repo URL keeps blocking
that URL even when the CLI classifies it as a git clone — closing a gap where a
blocked marketplace could slip through under a different source classification.

Since Claude Code 2.1.228, marketplace entries defined in **settings files merge as
whole entries** across settings tiers. Before that, a marketplace redefined in a
higher-precedence tier (say, a user settings file overriding a managed one) could
silently inherit another tier's custom headers — for a catalog fetched over plain
git like this one that was mostly invisible, but if you pin marketplaces with custom
HTTP headers in one tier and redefine the same entry in another, 2.1.228 is where
the two stop bleeding into each other.

## Claude Code 2.1.258

Reviewed for catalog impact from the published changelog and npm's `latest` dist-tag
for `@anthropic-ai/claude-code` (2.1.258, with 2.1.259 already visible as `next`) — this
run's live CLI is still 2.1.257, so this is a changelog-reviewed bump to `latest_known`,
not a live-CLI `validated_against` bump (see
[platform-targets.md](../../engineering/build-and-release/platform-targets.md) for that
distinction). 2.1.258 shipped exactly two entries, both host/session-side bug fixes with
zero marketplace-manifest, plugin-source, or skill-loading surface:

- **macOS 12 (Monterey) launch-regression fix.** Claude Code was failing to launch on
  macOS 12 — a regression introduced in 2.1.255. Purely a startup fix on one host OS
  version; no plugin-loading or marketplace surface.
- **Remote/scheduled session permission-approval fix.** Remote and scheduled sessions
  could fail with "user messages must have non-empty content" after a re-sent
  permission approval couldn't be applied. A session-messaging fix; unrelated to
  catalog install.

No new Troubleshooting rows or other install-guide changes were needed for this delta.
`validated_against` stays at 2.1.257 until a future run has a live 2.1.258+ CLI to check
directly.

## Claude Code 2.1.257

Reviewed for catalog impact, with a live 2.1.257 CLI available this run (the fifth
consecutive run with direct CLI validation). 2.1.253–2.1.256 do not exist as public
releases, so this covers the full 2.1.252 → 2.1.257 delta. Two items have any
catalog-adjacent surface at all, and both were checked directly against this repo
rather than assumed:

- **Plugin symlink component-path rejection.** Claude Code now refuses, with an error,
  a plugin's declared command, agent, skill, hooks, or other component path that turns
  out to be a symlink escaping the plugin's own directory — broadening the 2.1.251
  commands-only path-traversal check to every declared component-path field. Checked
  directly against `.claude-plugin/marketplace.json` (and the generated
  `.agents/plugins/marketplace.json` / `.cursor-plugin/marketplace.json`): none of this
  catalog's three plugin entries (`tamirs-superpowers`, `jose-claudinho`, `headhunter`)
  declare a `commands`, `agents`, `skills`, or `hooks` field — each carries only
  `name`/`source`/`description`. Also re-confirmed with `find . -type l` that this
  repository itself has no symlinks anywhere, including under
  `.agents/skills/run-plugins-catalog`. Not applicable, on both counts.
- **MCP connection/OAuth log credential redaction.** Debug/error logs for MCP
  connections and OAuth now redact credentials carried in a server's URL or request
  headers. Noted above alongside the existing `headersHelper` coverage — this catalog's
  entries are all public `github` sources with no `headersHelper` in use today, so
  nothing here changes, but it hardens the exact mechanism this guide already points to
  for a future private/token-gated entry.

Everything else in 2.1.257 — Claude Fable 5.1 and the Fable-5.1-default-model change,
`timeFormat`/`timeZone` settings, the auto-mode Containment Escape rule,
`CLAUDE_CODE_SUBAGENT_MODEL_FORCE`, `/effort s`, the stale-sandbox-mask `/doctor`
warning, the auto-mode outside-working-directory read prompt and
`permissions.blockReadsOutsideWorkingDirectories`, gateway `/model` picker descriptions,
and the long list of host/session/Remote-Control/Bedrock-Vertex-Foundry/VS-Code bug
fixes and improvements — is host/CLI/editor-side with no marketplace, plugin-source, or
skill-loading surface. `claude plugin validate --strict .agents/skills` and `make
validate` both passed clean against the live 2.1.257 CLI. No new Troubleshooting rows
were needed for this delta.

## Claude Code 2.1.252

Reviewed for catalog impact, with a live 2.1.252 CLI available this run (the fourth
consecutive run with direct CLI validation). 2.1.252 shipped four bug fixes and no
Added/Improved/Changed entries — all host/CLI-side with zero marketplace-manifest
surface:

- **Bash "task output swap refused (tasks dir moved or linked)" fix** — a macOS-specific
  Bash-tool internals fix; no plugin or marketplace surface.
- **"always allow" not saving in a project with no `.claude/settings.local.json` yet** —
  a host permission-settings persistence fix; this catalog ships no
  `.claude/settings.local.json` of its own and the fix changes nothing about how
  plugins or marketplaces are installed or cached.
- **Remote Control sessions hosted by Claude Desktop or VS Code stalling for minutes**
  — a Remote Control connection-handling fix; unrelated to catalog install.
- **Background task notifications with very large failure output exceeding the API
  request size limit** — a notification-payload fix; unrelated to catalog install.

Re-checked directly against `.claude-plugin/marketplace.json` rather than assumed: the
2.1.251 plugin-command path-traversal rejection is still not applicable — none of this
catalog's three plugin entries (`tamirs-superpowers`, `jose-claudinho`, `headhunter`)
declare a `commands` field. `claude plugin validate --strict .agents/skills` and `make
validate` both passed clean against the live 2.1.252 CLI. No install-guide or
Troubleshooting changes were needed for this delta.

## Claude Code 2.1.248 – 2.1.251

Reviewed for catalog impact, with a live 2.1.251 CLI available this run (the third
consecutive run with direct CLI validation). 2.1.249 and 2.1.250 published no
changelog specifics beyond "bug fixes and reliability improvements." Three items
from 2.1.251 are directly about marketplace/catalog/worktree behavior and were
checked for real against this repo:

- **Plugin-command path-traversal rejection.** A marketplace entry's declared
  command that points outside the plugin directory is now rejected at load with a
  clear error, instead of being followed. Checked directly against
  `.claude-plugin/marketplace.json`: none of this catalog's three plugin entries
  (`tamirs-superpowers`, `jose-claudinho`, `headhunter`) declare a `commands` field
  at all — this catalog never exercised the vulnerable path, and nothing here
  changes.
- **Marketplace-refresh-race plugin-skills fix.** Before 2.1.251, a background
  session could start with **zero plugin skills loaded — and stay that way** — if
  another Claude Code process happened to be refreshing the plugin marketplace at
  the same moment. This is directly relevant to anyone running several Claude Code
  sessions against plugins installed from this catalog at once. Fixed in 2.1.251 —
  documented below in Troubleshooting.
- **GitLab `--worktree --tmux` fetch fix.** A `gitlab.com`-origin worktree no
  longer tries a doomed GitHub-style fetch first before fetching the GitLab ref
  directly — a startup-latency fix noted above in the plugin-sources section
  alongside the existing GitLab marketplace/worktree guidance.

Also checked from 2.1.248: the MCP `headersHelper`-with-`Authorization`
OAuth-discovery-on-401 fix (the helper is now re-run and the call retried on a
401, matching what this guide always documented — noted above alongside the
existing `headersHelper` coverage), and the new `experimental.cacheTtl`
agent-frontmatter setting — not applicable, this catalog ships no agent
definitions of its own, only the `run-plugins-catalog` contributor skill.

Everything else in 2.1.248–2.1.251 is host/CLI/session-side with no
marketplace-manifest surface, reviewed and confirmed: `--restricted` mode; the
`PreModelSwitch`/`PostModelSwitch` hook events; live subagent tool-call streaming
to Remote Control; the `/usage` spend-limit bar and per-session prompt-cache line
on `/cost`; `claude --help`'s `attach`/`logs`/`stop`/`respawn`/`rm`; the symlink,
Grep/Glob deny-rule, Workflow `scriptPath`, and sandbox security fixes (none touch
plugin/marketplace loading); self-hosted-runner and `claude agents` UI/reliability
fixes; cross-session messaging on Bedrock/Vertex/Foundry; Remote Control and
cloud-session fixes; and the analytics/gateway/sandbox-settings changes. `claude
plugin validate --strict .agents/skills` and `make validate` both passed clean
against the live 2.1.251 CLI.

## Claude Code 2.1.247

Reviewed for catalog impact, with a live 2.1.247 CLI available this run (the second
consecutive run with direct CLI validation). Two items are directly about
marketplace/catalog behavior and were checked for real against this repo, not
assumed:

- **Version-less marketplace plugin cache directory fix.** Before 2.1.247, installing
  a plugin with no `version` field into a second scope could delete the cache
  directory the first scope's install used. Checked directly against
  `.claude-plugin/marketplace.json`: none of this catalog's three plugin entries
  (`tamirs-superpowers`, `jose-claudinho`, `headhunter`) declare a `version` field, so
  every install from this catalog was exactly the version-less case this bug
  describes. Fixed in 2.1.247 — now documented above (Install section) and in
  Troubleshooting, below.
- **Plugin marketplace hardening: control/invisible character rejection, escape-safe
  text.** Checked directly with a Unicode category scan (`unicodedata.category`
  starting with `C`, covering control, format, surrogate, private-use, and unassigned
  code points) over every plugin `name` and `description` string in all three
  manifests (`.claude-plugin/marketplace.json`, `.agents/plugins/marketplace.json`,
  `.cursor-plugin/marketplace.json`) — **zero hits**. This catalog's entries were
  already clean plain ASCII, so the new host-side rejection changes nothing here.

Also checked and confirmed **not applicable**: the `/claude-api` skill's new Admin API
coverage (organization members, invites, workspaces, API keys, rate-limit reports,
workload identity federation, CMEK) and the new `/claude-api cost-optimize`
subcommand — this catalog ships no `claude-api` skill and no Python or Anthropic-SDK
code of its own, unlike a repo that ships its own plugin source.

Everything else in 2.1.247 is host/CLI/session-side with no marketplace-manifest
surface, reviewed and confirmed: the `SendFeedback` tool and `feedbackDrafts` setting;
`spinnerTipsOverride`'s `{id, text, cooldownSessions, priority}` entries, `tipsFile`,
and `label`; the Bash-permission-prompt "switch to auto mode" tip; fast arrow-key +
Enter fixes across history search, `/config`, `/mcp`, `/skills`, background tasks, and
`/model`; the sub-agent first-call-model-404 fallback-chain fix; the hook/background-
agent error-output overflow fix; non-Latin-keyboard Ctrl shortcuts and split
mouse-report-sequence fixes under kitty-protocol terminals; the Bash sandbox
dotfile-symlink deletion fix; `/terminal-setup`'s Zed `keymap.json` merge fix (instead
of overwrite); the `/rename` silent-confirm-on-failure fix; the `/compact`/"Summarize
from here" system-prompt fix; the background-session "opening…" and unbounded-
memory-growth fixes; the `/install-github-app` SSH messaging fix; the background-
session shell-logging fix; Remote Control working-tree diff reporting; self-hosted
runner session status timing; the first-run managed-gateway connectivity fix;
cloud-session permission-mode-display and container-restart fixes;
Bedrock/Vertex/Foundry MCP-connection-failure messaging; Sonnet 5's full-1M
auto-compact window; cross-session peer-message collapse-by-default; terminal
hyperlink/control-character rendering; the PR-badge GitHub-recheck skip; and the
analytics/gateway/organization-sign-in changes. `claude plugin validate
--strict .agents/skills` and `make validate` both passed clean against the live
2.1.247 CLI.

## Claude Code 2.1.246

Reviewed for catalog impact, with a live 2.1.246 CLI available this run (the first
direct CLI validation since 2.1.241). Catalog-relevant items: the `claude plugin update
<name>` bare-name fix and the `claude plugin install <name>` silent-exit-on-corrupted-
`known_marketplaces.json` fix, both now documented above (Update section and
Troubleshooting table); the plugin skill name-doubling fix and the `/reload-plugins`
`skills/*/SKILL.md` fix, both reviewed above under "Skill frontmatter validation" and
found not applicable to this catalog's own skill. The plugin.json UTF-8 BOM
install-breaking fix was also checked directly — none of this repo's three JSON
manifests (`.claude-plugin/marketplace.json`, `.cursor-plugin/marketplace.json`,
`.agents/plugins/marketplace.json`) carry a BOM, and this catalog ships no `plugin.json`
of its own (its plugins live in separate repos). Everything else in 2.1.246 (an Auto
mode tab in `/permissions`, a plugin-cache duplicate-SHA-directory fix, hook-error
`${CLAUDE_PLUGIN_ROOT}` resolution, an MCP `requiresUserInteraction` permission-prompt
fix, subagent partial-output-on-`maxTurns`, deferred managed-settings consent prompts,
and OTel `plugin_id_hash`/`enabled_via` changes for synced plugins) is host/CLI-side
with no marketplace-manifest surface. `claude plugin validate --strict .agents/skills`
and `make validate` both passed clean against the live 2.1.246 CLI.

## Claude Code 2.1.242 – 2.1.245

Reviewed for catalog impact. **2.1.245** ships only a Linux-glibc-2.44 startup crash
fix — a host binary issue with no catalog surface. **2.1.244** and **2.1.242** have no
separately documented changes. **2.1.243** is the delta with any marketplace-facing
content: the `managed` connector marker in `/mcp`/`/plugins` (documented above, under
"Plugins synced from claude.ai"); a fix for plugin dependencies declared with a
`marketplace` field never resolving when both plugins are loaded together via
`--plugin-dir` — this catalog's `allowCrossMarketplaceDependenciesOn` entry
(`superpowers-dev`) declares that kind of cross-marketplace dependency, but the bug
only manifested for dev-time `--plugin-dir` loading of two plugins together, not for a
normal `/plugin install` from this catalog, so no behavior here was ever affected; and a
`/reload-plugins` fix for a stale LSP tool after the last LSP plugin is disabled — no
plugin in this catalog ships an LSP integration, so not applicable. Everything else in
2.1.243 (the `/usage` Loops breakdown, `modelPicker`, `promptCacheTtl`/
`subagentPromptCacheTtl`, `modelPricing`, keyless Console sign-in, `/web-setup`, hook
`if`-condition fixes, `--agents` JSON validation) is host/editor-side with no
marketplace or plugin-manifest surface. `claude plugin validate --strict .agents/skills`
was re-run against the local 2.1.245 CLI and passed clean.

## Claude Code 2.1.239 – 2.1.241

Reviewed for catalog impact. **2.1.239** adds the `name@synced` naming and
never-override guarantee for plugins synced from claude.ai into a cloud session,
documented above under "Plugins synced from claude.ai", plus Windows cross-session
messaging (host-side, no catalog impact). **2.1.240** and **2.1.241** are both
"bug fixes and reliability improvements" with no changelog specifics — reviewed and
found to touch nothing this catalog's `.claude-plugin/marketplace.json` or manifests
rely on. `claude plugin validate --strict .agents/skills` was re-run directly against
the local 2.1.241 CLI and passed clean.

## Claude Code 2.1.236 – 2.1.238

Reviewed for catalog impact, closing the changelog gap noted after 2.1.235: **2.1.238**
adds a `keybindingFlavor` setting (a `readline`-style Ctrl+W). It also lists the
`known_marketplaces.json` concurrent-write startup race that could silently unregister a
marketplace — this catalog already documents that fix in the troubleshooting table below
under 2.1.232, where it first shipped, so no change was needed here. 2.1.238 also fixes
output styles drifting back to default voice mid-session, fixes stdio MCP servers receiving
`server/discover` before `initialize`, and changes
`claude mcp list`/`claude mcp get` to show disabled servers as `⊘ Disabled`. The one
catalog-facing item — marketplace/catalog `headersHelper`, plus the related MCP
`headersHelper` trust-dialog requirement — is documented above in the plugin-sources
section. **2.1.237** adds a built-in "Concise" output style and fixes prompt caching for
LLM-gateway/custom-base-URL sessions. **2.1.236** adds the `ANTHROPIC_DEFAULT_MODEL` env
var, `notify_when_idle` for cross-session `SendMessage`, and macOS sandbox wildcard
read-deny precedence fixes. All of these except the `headersHelper` pair are editor/host/
session-side and touch nothing this catalog's `.claude-plugin/marketplace.json` or
manifests rely on.

## Claude Code 2.1.235

Reviewed for catalog impact: the new opt-in `spellcheck` setting (underlines misspelled
words in the editor using `aspell`/`hunspell`/`ispell`), improved permission dialogs and
context-limit error messages, Vim mode preserving NORMAL mode and cursor position when
toggling the transcript, and `claude rc` applying enterprise-gateway availability checks
for Remote Control are all editor/host-side and touch nothing this catalog's
`.claude-plugin/marketplace.json` or manifests rely on — no marketplace or plugin-source
behavior changed. Nothing here is adopted as a catalog capability.

## Claude Code 2.1.234

Reviewed for catalog impact: `CLAUDE_CODE_PROJECT_DIR_NAME`, auto-continue on usage-limit
reset, account-email-only identification, Windows NT-namespace path-read hardening, Remote
Control cross-session/org-switch sync, `/permissions` and `/add-dir` usable mid-turn, `/goal`
improvements, and the removed "Default teammate model" setting are all host/session-side and
touch nothing this catalog's `.claude-plugin/marketplace.json` or manifests rely on. The one
catalog-adjacent item — the GitLab MR footer/statusline badge — is documented above.

## Skill frontmatter validation (2.1.233+)

Since Claude Code 2.1.233, `claude plugin validate` also checks **bare `.claude/skills`
directories**, reporting any `SKILL.md` whose frontmatter fails to parse. This catalog's
own contributor skill lives at `.agents/skills/run-plugins-catalog` — not a bare
`.claude/skills` directory, so the new check doesn't change how it's discovered — and CI
now runs `claude plugin validate --strict .agents/skills` on every push regardless, to
catch a frontmatter regression there before it reaches a session. If you fork this catalog and add a skill
under a bare `.claude/skills` directory of your own, the same 2.1.233 check applies to it
automatically — no extra setup needed.

Also fixed in 2.1.233: bundled skills like `/checkup` and `/review` no longer report
"Unknown command" in `-p` mode or with plugins/MCP loaded when a user or project skill of
the same name shadows them. None of this catalog's own plugins currently ship a skill
named `checkup` or `review`, so this fix is compatibility-relevant but not a functional
change here.

Two more skill/plugin-loading fixes landed in 2.1.246, both reviewed against this
catalog: a plugin skill whose frontmatter `name` field already includes the `<plugin>:`
prefix no longer shows it doubled in the slash menu (e.g. `/plugin:plugin:skill`) — this
catalog's own skill frontmatter (`name: run-plugins-catalog`) carries no plugin prefix,
so it was never affected; and `/reload-plugins` no longer reports 0 skills for a plugin
that defines skills under `skills/*/SKILL.md` — this catalog's skill lives in a bare
`.agents/skills` directory rather than inside a Claude Code plugin's own `skills/` tree,
so this bug never applied here either. Both are host-CLI fixes with no manifest change
required on this catalog's side.

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `Marketplace file not found` | The source has no `.claude-plugin/marketplace.json`. Check you passed `Tamircohen28/tamirs-marketplace` and not a plugin repo on an old revision. |
| Plugin installs but skills don't appear | On 2.1.221+ installs activate immediately when safe; otherwise start a **new** session. Skills load at session start, not on install. |
| `plugin update` does nothing | The plugin release didn't bump its `version`. Check that plugin's releases page. |
| A plugin name isn't found | Since 2.1.232 `/plugin install <name>@tamirs-marketplace` refreshes the catalog **first**, so a just-published plugin installs with no manual step. 2.1.221–2.1.231 refresh a stale catalog and retry on failure; on older versions run `claude plugin marketplace update tamirs-marketplace` first. |
| The marketplace vanished from `/plugin` | Before 2.1.232, a startup race between concurrent writes to `known_marketplaces.json` could silently unregister a marketplace. Fixed in 2.1.232 — on older versions, re-add with `claude plugin marketplace add Tamircohen28/tamirs-marketplace`. |
| A skill's `SKILL.md` frontmatter silently does nothing | Since 2.1.233, `claude plugin validate --strict <path>` reports the parse error directly instead of the skill just not loading. This catalog runs it in CI on `.agents/skills`. |
| `/doctor` reports a stale plugin | `claude plugin marketplace update tamirs-marketplace`, then `claude plugin update <name>@tamirs-marketplace`. |
| `claude plugin install <name>` exits with no output | Before 2.1.246, a missing or corrupted `~/.claude/plugins/known_marketplaces.json` made install fail silently instead of reporting an error. Fixed in 2.1.246 — on older versions, re-add the catalog with `claude plugin marketplace add Tamircohen28/tamirs-marketplace` first if install seems to do nothing. |
| Installing a catalog plugin in a second scope deletes the other scope's cache | Before 2.1.247, a plugin with no `version` field (true of all three plugins in this catalog) installed into a second scope could delete the first scope's cache directory. Fixed in 2.1.247 — on older versions, avoid installing the same catalog plugin into two scopes at once, or upgrade first. |
| A background session starts with no plugin skills loaded, and stays that way | Before 2.1.251, this could happen when another Claude Code process was refreshing the plugin marketplace at the same moment the background session started. Fixed in 2.1.251 — on older versions, avoid starting a new background session while `claude plugin marketplace update tamirs-marketplace` is running elsewhere, or restart the affected session. |

More: [troubleshooting.md](../troubleshooting.md).

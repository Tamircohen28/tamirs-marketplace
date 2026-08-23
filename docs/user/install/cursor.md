# Install — Cursor

| | |
|---|---|
| **Validated against** | Cursor **3.16.29** |
| **Minimum supported** | **3.16.29** |
| **Changelog covered through** | feature **3.11** + date-only entries to **2026-08-19** (see [`.cursor-version`](../../.cursor-version)) |
| **Marketplace manifest** | `.cursor-plugin/marketplace.json` (generated) |
| **Official docs** | [Cursor plugins](https://cursor.com/docs/plugins) · [Customize](https://cursor.com/docs/customize-cursor) |

Check your version — **Cursor → About Cursor**, or:

```bash
cursor --version
```

## About the version floor

Cursor's documentation states **no minimum version** for plugins. The 3.16.29 floor here is
simply the version this catalog was actually validated on, not a limit Cursor imposes. The
previous floor in this repo was `0.45.0`, which predates Cursor's plugin system entirely —
it could never have worked.

The public changelog's latest *feature* number can lag the desktop CLI patch line. This
catalog pins the CLI observation in `validated_against` and records the newest covered
changelog feature/date in `.cursor-version`.

## Method A — team marketplace (Teams / Enterprise)

An org admin imports this repo once; everyone in the assigned distribution groups then sees
the plugins in their in-editor marketplace panel.

1. **Dashboard → Plugins → Team Marketplaces → Add Marketplace**
2. Choose **Import from Repo**
3. Repository: `https://github.com/Tamircohen28/tamirs-marketplace`
4. Under **Marketplace Settings**:
   - Enable **Auto Refresh** so pushes to `main` re-index the catalog
   - Optionally restrict **Marketplace Access** to [Organization Groups](https://cursor.com/docs/enterprise/organization-groups) (Cursor **3.10**) — members outside those groups will not see the catalog
5. Save, then assign distribution groups / installation modes (Default Off / Default On / Required)

Developers: open **Customize** in the Cursor sidebar and install the plugins you want from
the team marketplace (and the team leaderboard of popular plugins/skills/MCPs, Cursor **3.9**).

> **Auto Refresh re-reads the whole manifest on push.** Unlike Claude Code, Cursor does not
> key updates off a `version` field, so a catalog change reaches your team without a version
> bump. There is no public Cursor version endpoint, which is why
> `make platform-targets-sync` cannot refresh Cursor's `latest_known` — that one is bumped
> by hand.

### Team MCPs alongside plugins (3.10)

Admins can link **Team MCP** servers (already available to Cloud Agents) into the Default
team marketplace from **Dashboard → Integrations & MCP → Add to Team Marketplace**. That
lets teammates install the same approved MCP servers from Customize without hand-editing
JSON. Marketplace access can use Organization Groups the same way as for plugins.

## Method B — local development (any plan)

Test a plugin before it's published or indexed remotely. This installs the plugin repo
directly and does not involve the catalog:

```bash
git clone https://github.com/Tamircohen28/tamirs-superpowers
ln -s "$(pwd)/tamirs-superpowers" ~/.cursor/plugins/local/tamirs-superpowers
```

Then restart Cursor, or run **Developer: Reload Window** from the command palette.

## What you get

| Plugin | What it adds |
|--------|--------------|
| `tamirs-superpowers` | 27 skills, MCP server stubs |
| `jose-claudinho` | Fantasy World Cup 2026 manager |
| `headhunter` | Job-search CRM |

Each plugin also ships `.cursor/rules/*.mdc` (Cursor-native rules pointing at its
`AGENTS.md`) and `.cursor/mcp.json` / `.mcp.json` for MCP servers.

## Optional — Google Workspace plugins (2026-08-03)

Cursor Marketplace plugins for Google Drive / Gmail / Calendar are unrelated to this
catalog. Install them from Customize / Marketplace if you want inbox or Drive context in
the agent. Never commit Workspace credentials into this repo or any catalogued plugin.

## Working tips (3.11 → 2026-08-19; desktop CLI 3.16.29; Grok 4.6)

- **Desktop CLI patch line** — pin is **3.16.29** (download line 2026-08-18; [CLI changelog](https://cursor.com/docs/cli/changelog) Aug 11). Newest feature write-up remains **3.11**; newest date-only entry **2026-08-19** (cloud-agent subscriptions / custom modes / isolated subagent VMs / `/goal` / steering).
- **Custom Modes (2026-08-19)** — from `/`, pick a skill and press ⌥⏎ / Alt+Enter → **Use as Mode** to keep a catalogued plugin skill pinned for the chat (always-on playbook). Prefer for long install/verify sessions.
- **`/goal` + non-interruptive steering (2026-08-19)** — long-lived objectives with `/goal`; Cloud Agents also expose native **CreateGoal** / **UpdateGoal** tools. Follow-ups wait for the next tool call (Send now, or ⏎ twice). CLI Aug 11 steer/`/goal` still apply for `agent` runs.
- **Subscriptions (Cloud Agents, 2026-08-19)** — wake on PR / Slack / schedule; agents auto-subscribe to PRs they create. Use for unattended catalog CI triage Automations.
- **Subagents on isolated VMs (2026-08-19)** — cloud subagents get their own project copy; prefer for parallel plugin install checks without collisions.
- **Origin (2026-08-17, early beta)** — Cursor's git forge ([docs](https://cursor.com/docs/origin)) can host or **mirror this catalog's GitHub repo** for browse/PR review in Cursor. Use the [Origin CLI](https://cursor.com/docs/origin/cli) for clone/push/pull; agents can [create Origin repos](https://cursor.com/docs/origin/create-repository); connect [Automations / Cloud Agents](https://cursor.com/docs/origin/integrations) and apps (Vercel / Depot / Buildkite) from repo settings. **GitHub remains canonical** for marketplace installs (`Tamircohen28/tamirs-marketplace` / `Tamircohen28/plugins` redirect) and CI. Do not switch catalog consumers to Origin-only remotes.
- **Cloud Agent Builds (2026-08-13; default as of 2026-08-17)** — warm environment snapshots for Cloud Agents (install pre-run; recurring refresh; failed builds stay inactive). **Builds is now the default** for all environments. Confirm each Cloud environment has Builds enabled (or inherited the default), a recent successful Build, `Update stale builds` on with a sensible Staleness threshold (default 24h), and install credentials as team/environment secrets. Private-registry credentials for Builds must be **team/environment secrets** (user secrets are session-only). Recurring Builds **Skip** when nothing changed since the last completed Build (no new default-branch commits / config / secret changes) — a Skipped stream is healthy. Enable **Update stale builds** and set the **Staleness threshold** (default **24 hours**; `0` = always pull latest default-branch at agent start). Phase split: durable work in `install` (Build-time), fresh services in `start`, shared app processes in `terminals` (both at agent start). See [announcement](https://cursor.com/blog/builds) · [Builds docs](https://cursor.com/docs/cloud-agent/builds).
- **CLI sticky skills (Aug 11)** — Option+Enter keeps a mode-backed skill sticky across turns in Cursor CLI — useful when validating a catalogued plugin's install skill without re-invoking it each message.
- **CLI plugin hooks (Aug 11)** — Cursor CLI now runs hooks from installed plugins (and `--plugin-dir`). Catalogued plugins still need a Cursor-native hooks bundle (not Claude-shaped `hooks/hooks.json`) before that path helps; see each plugin's Cursor install guide.
- **Agent Plugins standard** — Cursor loads [Agent Plugins](https://agent-plugins.org) (portable skills/MCP) alongside Cursor Plugins. Catalogued plugins ship `.cursor-plugin/plugin.json`.
- **`workspaceOpen` hook** — desktop/CLI app-lifecycle hook can return `pluginPaths` for workspace-specific plugin dirs (not Cloud Agents). Optional when developing catalogued plugins in a multi-root workspace.
- **Side chats (3.11)** — `/side` / `/btw` to research a catalogued plugin's install path without interrupting the main thread.
- **Cursor Router / Auto (2026-07-22)** — prefer Balance for routine catalog edits; Intelligence when auditing platform-target parity.
- **Grok 4.6 (2026-08-14)** — frontier model for long-running agents and stronger interactive/visual first passes ([announcement](https://cursor.com/blog/grok-4-6)). Prefer for multi-plugin catalog audits and visual marketplace demos; Router **Balance** for routine manifest edits. Host-side only — no catalog change.
- **Cursor Automations (3.8)** — can **delete memory files** from the UI (or when prompted). `/automate` with **Workflow run completed** to triage catalog CI (`make validate` / `make agent:check`) and open a fix PR; **PR review comment** for auto-addressing review threads. Computer use is available for demo artifacts.
- **Inbox + multi-PR sessions (2026-07-29)** — track cloud-agent / automation PRs from phone or desktop. When one chat opens catalog + plugin PRs together, open **every** PR from the session — not only the last.
- **Third-party hooks** — Claude settings-based hooks can load in Cursor when third-party skills/hooks are enabled; catalogued plugins still need their own Cursor install path (see each plugin's Cursor guide).

## Verify

Cursor has no `plugin list` CLI. Confirm in the editor:

- **Customize** lists the installed plugins and MCP toggles
- The marketplace panel shows `tamirs-marketplace` as a source
- Ask the agent to run one of the plugin's skills

## Update

Team marketplace installs refresh automatically on push (Auto Refresh). For a
Method B symlink:

```bash
cd tamirs-superpowers && git pull
```

Then **Developer: Reload Window**.

## Uninstall

- **Team marketplace:** uninstall from **Customize** / **Settings → Plugins**; the admin removes the
  marketplace from the Dashboard.
- **Local symlink:** `rm ~/.cursor/plugins/local/tamirs-superpowers`, then reload the window.

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| "Add Marketplace" isn't in the Dashboard | Team marketplaces are a Teams/Enterprise feature. Use Method B on an individual plan. |
| Import succeeds but no plugins appear | Assign distribution groups / Marketplace Access — an imported marketplace with no audience reaches nobody. |
| A plugin fails to install from the catalog | That plugin repo must ship `.cursor-plugin/plugin.json`. All three in this catalog do. |
| Symlinked plugin isn't picked up | The symlink must be in `~/.cursor/plugins/local/` and point at the repo **root**, not a subdirectory. Reload the window. |
| Rules aren't applying | Rules load from the *workspace* `.cursor/rules/` — open the plugin repo as a workspace, or copy the `.mdc` files into yours. |
| Expected Claude worktree hooks didn't fire | Those hooks are Claude-shaped; Cursor uses a different hooks schema. See the plugin's Cursor install guide. |

More: [troubleshooting.md](../troubleshooting.md).

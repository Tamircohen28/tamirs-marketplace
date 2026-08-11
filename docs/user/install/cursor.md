# Install — Cursor

| | |
|---|---|
| **Validated against** | Cursor **3.15.6** |
| **Minimum supported** | **3.15.6** |
| **Changelog covered through** | feature **3.11** + date-only entries to **2026-08-03** (see [`.cursor-version`](../../.cursor-version)) |
| **Marketplace manifest** | `.cursor-plugin/marketplace.json` (generated) |
| **Official docs** | [Cursor plugins](https://cursor.com/docs/plugins) · [Customize](https://cursor.com/docs/customize-cursor) |

Check your version — **Cursor → About Cursor**, or:

```bash
cursor --version
```

## About the version floor

Cursor's documentation states **no minimum version** for plugins. The 3.15.6 floor here is
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

## Working tips (3.11 → 2026-08-03; desktop CLI 3.15.6)

- **Desktop CLI patch line** — pin is **3.15.6** (download line 2026-08-06). Newest feature write-up remains **3.11**; newest date-only entry **2026-08-03**.
- **Agent Plugins standard** — Cursor loads [Agent Plugins](https://agent-plugins.org) (portable skills/MCP) alongside Cursor Plugins. Catalogued plugins ship `.cursor-plugin/plugin.json`.
- **`workspaceOpen` hook** — desktop/CLI app-lifecycle hook can return `pluginPaths` for workspace-specific plugin dirs (not Cloud Agents). Optional when developing catalogued plugins in a multi-root workspace.
- **Side chats (3.11)** — `/side` / `/btw` to research a catalogued plugin's install path without interrupting the main thread.
- **Cursor Router / Auto (2026-07-22)** — prefer Balance for routine catalog edits; Intelligence when auditing platform-target parity.
- **Cursor Automations (3.8)** — `/automate` with **Workflow run completed** to triage catalog CI (`make validate` / `make agent:check`) and open a fix PR; **PR review comment** for auto-addressing review threads. Computer use is available for demo artifacts.
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

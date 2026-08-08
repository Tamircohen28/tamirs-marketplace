# Install — Cursor

| | |
|---|---|
| **Validated against** | Cursor **3.14.7** |
| **Minimum supported** | **3.14.7** |
| **Marketplace manifest** | `.cursor-plugin/marketplace.json` (generated) |
| **Official docs** | [Cursor plugins](https://cursor.com/docs/plugins) |

Check your version — **Cursor → About Cursor**, or:

```bash
cursor --version
```

## About the version floor

Cursor's documentation states **no minimum version** for plugins. The 3.14.7 floor here is
simply the version this catalog was actually validated on, not a limit Cursor imposes. The
previous floor in this repo was `0.45.0`, which predates Cursor's plugin system entirely —
it could never have worked.

## Method A — team marketplace (Teams / Enterprise)

An org admin imports this repo once; everyone in the assigned distribution groups then sees
the plugins in their in-editor marketplace panel.

1. **Dashboard → Plugins → Team Marketplaces → Add Marketplace**
2. Choose **Import from Repo**
3. Repository: `https://github.com/Tamircohen28/tamirs-marketplace`
4. Save, then assign distribution groups

Developers: open the marketplace panel in Cursor and install the plugins you want.

> **Auto Refresh re-reads the whole manifest on push.** Unlike Claude Code, Cursor does not
> key updates off a `version` field, so a catalog change reaches your team without a version
> bump. There is no public Cursor version endpoint, which is why
> `make platform-targets-sync` cannot refresh Cursor's `latest_known` — that one is bumped
> by hand.

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
| `tamirs-superpowers` | 26 skills, MCP server stubs |
| `jose-claudinho` | Fantasy World Cup 2026 manager |
| `headhunter` | Job-search CRM |

Each plugin also ships `.cursor/rules/*.mdc` (Cursor-native rules pointing at its
`AGENTS.md`) and `.cursor/mcp.json` for MCP servers.

## Verify

Cursor has no `plugin list` CLI. Confirm in the editor:

- **Settings → Plugins** lists the installed plugins
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

- **Team marketplace:** uninstall from **Settings → Plugins**; the admin removes the
  marketplace from the Dashboard.
- **Local symlink:** `rm ~/.cursor/plugins/local/tamirs-superpowers`, then reload the window.

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| "Add Marketplace" isn't in the Dashboard | Team marketplaces are a Teams/Enterprise feature. Use Method B on an individual plan. |
| Import succeeds but no plugins appear | Assign distribution groups — an imported marketplace with no groups reaches nobody. |
| A plugin fails to install from the catalog | That plugin repo must ship `.cursor-plugin/plugin.json`. All three in this catalog do. |
| Symlinked plugin isn't picked up | The symlink must be in `~/.cursor/plugins/local/` and point at the repo **root**, not a subdirectory. Reload the window. |
| Rules aren't applying | Rules load from the *workspace* `.cursor/rules/` — open the plugin repo as a workspace, or copy the `.mdc` files into yours. |

More: [troubleshooting.md](../troubleshooting.md).

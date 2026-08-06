# Install — Claude Code

| | |
|---|---|
| **Validated against** | Claude Code **2.1.223** |
| **Minimum supported** | **2.0.0** |
| **Marketplace manifest** | `.claude-plugin/marketplace.json` (canonical) |
| **Official docs** | [Marketplaces](https://code.claude.com/docs/en/plugin-marketplaces) · [Plugins reference](https://code.claude.com/docs/en/plugins-reference) |

Check your version:

```bash
claude --version
```

## Prerequisites

- Claude Code 2.0.0 or newer — 2.1.223 is what this release was validated on
- Nothing else. Installing plugins needs no Python and no clone; Python 3 is a
  **contributor**-only dependency for `make generate`.

## Install

```bash
# 1. Add the catalog
claude plugin marketplace add Tamircohen28/plugins

# 2. Install the plugins you want
claude plugin install tamirs-superpowers@tamirs-plugins
claude plugin install jose-claudinho@tamirs-plugins
claude plugin install headhunter@tamirs-plugins

# 3. Verify
claude plugin list
```

Inside an interactive session, the slash-command equivalent:

```text
/plugin marketplace add Tamircohen28/plugins
/plugin install tamirs-superpowers@tamirs-plugins
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
claude plugin marketplace update tamirs-plugins
claude plugin update tamirs-superpowers@tamirs-plugins
```

> **Claude Code caches installed plugins by the `version` field in the plugin's
> `plugin.json`.** If a plugin release did not bump its version, `plugin update` is a no-op
> — you stay on the cached copy. `/reload-plugins` does **not** re-fetch from GitHub; it
> only reloads what is already cached.

Updating the *catalog* (`marketplace update`) refreshes the plugin list — which plugins
exist and where they point. Updating a *plugin* fetches its source.

## Installing a plugin standalone instead

Every plugin in this catalog also carries its own `.claude-plugin/marketplace.json`, so you
can skip the catalog entirely:

```text
/plugin marketplace add TamirCohen28/headhunter
/plugin install headhunter@headhunter
```

## Uninstall

```bash
claude plugin uninstall headhunter@tamirs-plugins
claude plugin marketplace remove tamirs-plugins
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

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `Marketplace file not found` | The source has no `.claude-plugin/marketplace.json`. Check you passed `Tamircohen28/plugins` and not a plugin repo on an old revision. |
| Plugin installs but skills don't appear | On 2.1.221+ installs activate immediately when safe; otherwise start a **new** session. Skills load at session start, not on install. |
| `plugin update` does nothing | The plugin release didn't bump its `version`. Check that plugin's releases page. |
| A plugin name isn't found | Since 2.1.221 `/plugin install` refreshes a stale catalog and retries on its own; on older versions run `claude plugin marketplace update tamirs-plugins` first. |
| `/doctor` reports a stale plugin | `claude plugin marketplace update tamirs-plugins`, then `claude plugin update <name>@tamirs-plugins`. |

More: [troubleshooting.md](../troubleshooting.md).

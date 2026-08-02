# Concepts

## What is a plugin marketplace?

A **marketplace** is a catalog file (`marketplace.json`) that lists multiple plugins by name and their source repos. Instead of installing each plugin directly from its GitHub URL, you add the marketplace once and install by name.

This catalog ships three platform-specific manifests, all generated from the same canonical Claude manifest:

| Platform | Manifest path |
|----------|---------------|
| Claude Code | `.claude-plugin/marketplace.json` |
| Codex | `.agents/plugins/marketplace.json` |
| Cursor | `.cursor-plugin/marketplace.json` |

## Claude Code

A Claude Code plugin is a directory published to GitHub that Claude Code can install at session start. A plugin can bundle:

- **Skills** — slash commands that give Claude a workflow
- **Hooks** — shell scripts that run automatically on events
- **MCP servers** — Model Context Protocol integrations
- **Settings** — status line config and permissions

```bash
/plugin marketplace add Tamircohen28/plugins
/plugin install tamirs-superpowers@tamirs-plugins
```

The `@tamirs-plugins` suffix tells Claude Code which marketplace to resolve the name from.

**For teams:** Claude Code only suggests plugins contextually from marketplaces an
admin has allowlisted via the `pluginSuggestionMarketplaces` managed setting
(2.1.152+). Adding `tamirs-plugins` to that allowlist lets Claude Code surface
these plugins as context-aware tips inside your organization's sessions.

## Codex

Codex plugins bundle skills, MCP servers, hooks, and app integrations. Add this repo as a marketplace source, then install plugins from the CLI or in-app plugin directory.

```bash
codex plugin marketplace add Tamircohen28/plugins --ref main --sparse .agents/plugins
codex plugin install tamirs-superpowers --source plugins
```

Codex cannot use Claude-style `{ "source": "github" }` entries — it needs the generated `.agents/plugins/marketplace.json` with `url` sources.

## Cursor

Cursor plugins bundle rules, skills, agents, commands, MCP servers, and hooks.

- **Team marketplace** — Teams/Enterprise admins import this GitHub repo; developers install from the in-editor marketplace panel.
- **Local development** — symlink a cloned plugin repo into `~/.cursor/plugins/local/<name>`.

Cursor reads `.cursor-plugin/marketplace.json` from this catalog repo. Each plugin repo must ship its own `.cursor-plugin/plugin.json`.

## How this catalog works

`tamirs-plugins` is a **catalog-only** repo. It contains marketplace manifests that point at each plugin's real repo. The actual plugin source (skills, hooks, MCP config) lives in those repos.

```
plugins/
  .claude-plugin/marketplace.json   ← canonical (edit this)
  .agents/plugins/marketplace.json  ← generated for Codex
  .cursor-plugin/marketplace.json   ← generated for Cursor
```

When you install a plugin from this catalog, your assistant fetches it directly from the source repo listed in the manifest.

## Plugin inventory

| Plugin | What it does |
|--------|-------------|
| `tamirs-superpowers` | 17 bundled skills, smart worktree hooks, statusline, and MCP server stubs — plan, implement, review, debug, and audit code from one plugin |
| `jose-claudinho` | Fantasy World Cup AI — lineup/transfer/captain recommendations via Sport5 API |
| `headhunter` | Job search CRM — pipeline, interview prep, Gmail/Notion/Todoist integrations |

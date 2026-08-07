# Concepts

## The four targets

`tamirs-plugins` and every plugin in it support four agent hosts:

**Claude Code · Cursor · Codex · OpenCode**

Three of them have a marketplace concept and can install this catalog directly. OpenCode
does not — see [What OpenCode does instead](#what-opencode-does-instead).

Version floors and how each was verified live in
[platform-targets.md](../engineering/build-and-release/platform-targets.md).

## What is a plugin marketplace?

A **marketplace** is a catalog file (`marketplace.json`) that lists multiple plugins by name
and their source repos. Instead of installing each plugin directly from its GitHub URL, you
add the marketplace once and install by name.

This catalog ships three platform-specific manifests, all generated from the same canonical
Claude manifest:

| Platform | Manifest path | |
|----------|---------------|---|
| Claude Code | `.claude-plugin/marketplace.json` | canonical — edit this one |
| Codex | `.agents/plugins/marketplace.json` | generated |
| Cursor | `.cursor-plugin/marketplace.json` | generated |
| OpenCode | *no marketplace format exists* | — |

`make generate` rebuilds the two generated manifests; CI fails if they drift.

## Claude Code

A Claude Code plugin is a directory published to GitHub that Claude Code can install at
session start. A plugin can bundle:

- **Skills** — slash commands that give Claude a workflow
- **Hooks** — shell scripts that run automatically on events
- **MCP servers** — Model Context Protocol integrations
- **Settings** — status line config and permissions

```bash
claude plugin marketplace add Tamircohen28/plugins
claude plugin install tamirs-superpowers@tamirs-plugins
```

The `@tamirs-plugins` suffix tells Claude Code which marketplace to resolve the name from.

Claude Code caches installed plugins by the `version` field in each plugin's `plugin.json`.
A plugin release that doesn't bump its version never reaches installed users.

**Plugin sources — git and archive:** every entry in this catalog is a `github` source
pinned to a branch, so installs fetch the plugin repo over git and updates track that
branch. Since Claude Code 2.1.224 a plugin can also be distributed as an **`archive`
source** — a zip fetched over HTTPS, needing neither git nor npm, with optional SHA-256
pinning. This catalog does not currently publish archive sources; the git-pinned entries
are what keep installs auto-updating.

**For teams:** Claude Code only suggests plugins contextually from marketplaces an
admin has allowlisted via the `pluginSuggestionMarketplaces` managed setting
(2.1.152+). Adding `tamirs-plugins` to that allowlist lets Claude Code surface
these plugins as context-aware tips inside your organization's sessions.

## Codex

Codex plugins bundle skills, MCP servers, hooks, and app integrations. Add this repo as a marketplace source, then install plugins from the CLI or in-app plugin directory.

```bash
codex plugin marketplace add Tamircohen28/plugins --ref main --sparse .agents/plugins
codex plugin add tamirs-superpowers@tamirs-plugins
```

Two things to know:

- The subcommand is **`codex plugin add`**, not `install`, and the marketplace is selected
  with `@MARKETPLACE` or `-m` — there is no `--source` flag.
- Codex cannot use Claude-style `{ "source": "github" }` entries — it needs the generated
  `.agents/plugins/marketplace.json` with `url` sources, and it reads **that** path, not
  `.codex-plugin/marketplace.json`.

## Cursor

Cursor plugins bundle rules, skills, agents, commands, MCP servers, and hooks.

- **Team marketplace** — Teams/Enterprise admins import this GitHub repo (Dashboard →
  Plugins → Team Marketplaces → Add Marketplace → Import from Repo); developers install from
  the in-editor marketplace panel.
- **Local development** — symlink a cloned plugin repo into `~/.cursor/plugins/local/<name>`.

Cursor reads `.cursor-plugin/marketplace.json` from this catalog repo. Each plugin repo must ship its own `.cursor-plugin/plugin.json`.

Unlike Claude Code, Cursor's Auto Refresh re-reads the whole manifest on push — no version
bump is needed for a catalog change to reach your team.

## What OpenCode does instead

OpenCode has no plugin marketplace and no plugin manifest format, so this catalog cannot be
added as an install source there. Instead, OpenCode reads skills **natively** from a set of
known directories, and each plugin repo ships an `opencode.json` declaring where its skills
live:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "skills": { "paths": ["skills"] }
}
```

So installing a plugin on OpenCode is just: clone the plugin repo and run `opencode` in it.
The [plugin table in the README](../../README.md#plugins) is the discovery surface a
marketplace would otherwise provide.

Full detail, including OpenCode's config strictness and its documented capability gaps:
[install/opencode.md](install/opencode.md).

## How this catalog works

`tamirs-plugins` is a **catalog-only** repo. It contains marketplace manifests that point at each plugin's real repo. The actual plugin source (skills, hooks, MCP config) lives in those repos.

```
plugins/
  .claude-plugin/marketplace.json   ← canonical (edit this)
  .agents/plugins/marketplace.json  ← generated for Codex
  .cursor-plugin/marketplace.json   ← generated for Cursor
```

When you install a plugin from this catalog, your assistant fetches it directly from the source repo listed in the manifest.

**Every plugin in this catalog is also installable standalone on all four targets** — each
one carries its own marketplace manifests and its own per-target install guides. The catalog
is a convenience, not a requirement.

## Plugin inventory

| Plugin | What it does |
|--------|-------------|
| `tamirs-superpowers` | 26 bundled skills, smart worktree hooks, statusline, and MCP server stubs — plan, implement, review, debug, and audit code from one plugin |
| `jose-claudinho` | Fantasy World Cup AI — lineup/transfer/captain recommendations via Sport5 API |
| `headhunter` | Job search CRM — pipeline, interview prep, Gmail/Notion/Todoist integrations |

# Platform equivalence — catalog repo

`tamirs-plugins` is a **catalog-only** marketplace. It ships marketplace manifests,
not plugin source. Feature parity across Claude Code, Cursor, and Codex applies to
**manifest generation and install docs**, not skills, hooks, or MCP servers.

## What this repo ships per platform

| Capability | Claude Code | Cursor | Codex |
|------------|-------------|--------|-------|
| Marketplace manifest | `.claude-plugin/marketplace.json` (canonical) | `.cursor-plugin/marketplace.json` (generated) | `.agents/plugins/marketplace.json` (generated) |
| Contributor policy | `AGENTS.md` + `CLAUDE.md` | `AGENTS.md` + `.cursor/rules/` | `AGENTS.md` + `.codex/config.toml` |
| Skills | — | — | — |
| Hooks | — | — | — |
| MCP | — | — | — |

Listed plugins (e.g. `tamirs-superpowers`) ship skills, hooks, and MCP stubs in
their own repositories.

## MCP and Codex

User docs mention MCP because **installed plugins** may expose MCP servers. This
catalog does not include `.mcp.json`. `.codex/config.toml` is a stub pointing
contributors to plugin repos for MCP configuration.

## Portable skills

`.agents/skills/run-plugins-catalog/` is a minimal project skill for contributors
running `make validate` — not a consumer-facing slash command.

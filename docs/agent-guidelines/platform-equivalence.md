# Platform equivalence — catalog repo

`tamirs-plugins` is a **catalog-only** marketplace. It ships marketplace manifests,
not plugin source. Feature parity across the four targets — Claude Code, Cursor,
Codex, and OpenCode — applies to **manifest generation and install docs**, not
skills, hooks, or MCP servers.

Version floors and verification methods:
[`../engineering/build-and-release/platform-targets.md`](../engineering/build-and-release/platform-targets.md).
Per-target install guides: [`../user/install/`](../user/install/README.md).

## What this repo ships per platform

| Capability | Claude Code | Cursor | Codex | OpenCode |
|------------|-------------|--------|-------|----------|
| Marketplace manifest | `.claude-plugin/marketplace.json` (canonical) | `.cursor-plugin/marketplace.json` (generated) | `.agents/plugins/marketplace.json` (generated) | ❌ no format exists |
| Contributor policy | `AGENTS.md` + `CLAUDE.md` | `AGENTS.md` + `.cursor/rules/` | `AGENTS.md` + `.codex/config.toml` | `AGENTS.md` (read natively) |
| Install guide | [claude-code.md](../user/install/claude-code.md) | [cursor.md](../user/install/cursor.md) | [codex.md](../user/install/codex.md) | [opencode.md](../user/install/opencode.md) |
| Skills | — | — | — | — |
| Hooks | — | — | — | — |
| MCP | — | — | — | — |

Listed plugins (e.g. `tamirs-superpowers`) ship skills, hooks, and MCP stubs in
their own repositories.

## The OpenCode asymmetry

OpenCode has no plugin marketplace and no plugin manifest format, so **this catalog
cannot be installed there at all**. That is the one place the four targets are not
equivalent for this repo, and it is a platform gap rather than an omission —
tracked under `targets.opencode.capability_gaps` in
[`platform-targets.json`](../engineering/build-and-release/platform-targets.json).

**Substitute:** each plugin repo is installed directly. OpenCode reads skills
natively from `.opencode/skills/`, `.claude/skills/`, `.agents/skills/`, and any
path listed in `skills.paths`; every plugin in this catalog ships its own
`opencode.json` declaring where its skills live. The plugin table in the README is
the discovery surface a marketplace would otherwise provide.

## Manifest path trap

Codex reads `.agents/plugins/marketplace.json`. It does **not** read
`.codex-plugin/marketplace.json`, even though the plugin-side manifest *is*
`.codex-plugin/plugin.json`. A catalog shipping only the latter fails with
`marketplace root does not contain a supported manifest`.

## MCP and Codex

User docs mention MCP because **installed plugins** may expose MCP servers. This
catalog does not include `.mcp.json`. `.codex/config.toml` is a stub pointing
contributors to plugin repos for MCP configuration.

## Portable skills

`.agents/skills/run-plugins-catalog/` is a minimal project skill for contributors
running `make validate` — not a consumer-facing slash command.

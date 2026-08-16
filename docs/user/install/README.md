# Install guides

`tamirs-marketplace` is a **catalog**: it holds marketplace manifests only. The plugin source
lives in each plugin's own repository. Adding this catalog gives you one install point for
every plugin in it.

Pick your host:

| Target | Catalog install | Validated against | Minimum | Guide |
|--------|-----------------|-------------------|---------|-------|
| Claude Code | ✅ marketplace | 2.1.233 | 2.0.0 | [claude-code.md](claude-code.md) |
| Cursor | ✅ team marketplace | 3.14.7 | 3.14.7 | [cursor.md](cursor.md) |
| Codex | ✅ marketplace | 0.146.0 | 0.40.0 | [codex.md](codex.md) |
| OpenCode | ❌ no marketplace — install per plugin | 1.18.11 | 1.16.2 | [opencode.md](opencode.md) |

Version floors and how each was verified: [platform-targets.md](../../engineering/build-and-release/platform-targets.md).

## The four targets

These are the four agent hosts this catalog and every plugin in it support. Adding a fifth
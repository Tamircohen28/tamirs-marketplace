# Install guides

`tamirs-marketplace` is a **catalog**: it holds marketplace manifests only. The plugin source
lives in each plugin's own repository. Adding this catalog gives you one install point for
every plugin in it.

Pick your host:

| Target | Catalog install | Validated against | Minimum | Guide |
|--------|-----------------|-------------------|---------|-------|
| Claude Code | ✅ marketplace | 2.1.226 | 2.0.0 | [claude-code.md](claude-code.md) |
| Cursor | ✅ team marketplace | 3.14.7 | 3.14.7 | [cursor.md](cursor.md) |
| Codex | ✅ marketplace | 0.146.0 | 0.40.0 | [codex.md](codex.md) |
| OpenCode | ❌ no marketplace — install per plugin | 1.18.11 | 1.16.2 | [opencode.md](opencode.md) |

Version floors and how each was verified: [platform-targets.md](../../engineering/build-and-release/platform-targets.md).

## The four targets

These are the four agent hosts this catalog and every plugin in it support. Adding a fifth
means adding it to `supported_targets` in
[`platform-targets.json`](../../engineering/build-and-release/platform-targets.json) — the
CI check is data-driven and picks it up with no script change.

## Which manifest each host reads

Only `.claude-plugin/marketplace.json` is edited by hand. The other two are **generated**
from it by `make generate`, and CI fails if they drift.

| Host | Manifest path | Generated? |
|------|---------------|------------|
| Claude Code | `.claude-plugin/marketplace.json` | canonical — edit this one |
| Cursor | `.cursor-plugin/marketplace.json` | generated |
| Codex | `.agents/plugins/marketplace.json` | generated |
| OpenCode | *none — no marketplace format exists* | — |

> Codex reads `.agents/plugins/marketplace.json`, **not** `.codex-plugin/marketplace.json`.
> This trips people up because the plugin-side manifest *is* `.codex-plugin/plugin.json`.

## OpenCode is different

OpenCode has no plugin marketplace and no plugin manifest format, so **this catalog cannot
be added as an install source there**. Each plugin repo is installed directly instead —
clone it and OpenCode discovers its skills natively. Every plugin in this catalog ships its
own `opencode.json` and its own OpenCode install guide. See [opencode.md](opencode.md).

## Plugins in this catalog

| Plugin | Repo | Standalone install docs |
|--------|------|-------------------------|
| `tamirs-superpowers` | [Tamircohen28/tamirs-superpowers](https://github.com/Tamircohen28/tamirs-superpowers) | [docs/user/install/](https://github.com/Tamircohen28/tamirs-superpowers/tree/master/docs/user/install) |
| `jose-claudinho` | [Tamircohen28/jose-claudinho](https://github.com/Tamircohen28/jose-claudinho) | [docs/user/install/](https://github.com/Tamircohen28/jose-claudinho/tree/main/docs/user/install) |
| `headhunter` | [Tamircohen28/headhunter](https://github.com/Tamircohen28/headhunter) | [docs/user/install/](https://github.com/Tamircohen28/headhunter/tree/main/docs/user/install) |

Each of those repos is **independently installable on all four targets** without this
catalog — the catalog is a convenience, not a requirement.

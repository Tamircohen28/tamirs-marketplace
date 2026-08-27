# Platform target versions

`tamirs-marketplace` supports **four** agent targets. This file is the human mirror of
[`platform-targets.json`](platform-targets.json), which is the machine-readable source
enforced by `scripts/check-platform-targets.sh`.

| Platform | Min supported | Validated against | Latest known | Install guide |
|----------|---------------|-------------------|--------------|---------------|
| Claude Code | 2.0.0 | 2.1.247 | 2.1.247 | [claude-code.md](../../user/install/claude-code.md) |
| Cursor | 3.16.17 | 3.16.17 | 3.16.17 | [cursor.md](../../user/install/cursor.md) |
| Codex | 0.40.0 | 0.147.0 | 0.147.0 | [codex.md](../../user/install/codex.md) |
| OpenCode | 1.16.2 | 1.18.11 | 1.18.15 | [opencode.md](../../user/install/opencode.md) |

All four versions were read from the CLIs themselves on 2026-08-03. Claude Code is now
directly CLI-validated at **2.1.247** on **2026-08-27** (`claude --version` on the
runner reports 2.1.247) — the second consecutive run with a live CLI available, so
`validated_against` and `latest_known` stay equal. The 2.1.247 delta was reviewed
against the catalog surface. Two items are directly about marketplace/catalog behavior
and got a real check rather than a rubber stamp: the **version-less marketplace plugin
cache directory fix** (a plugin install into a second scope could delete the cache
directory of a plugin declaring no `version` field, installed in another scope) — all
three of this catalog's plugin entries omit `version`, so this catalog's installs are
exactly the case the bug describes; now documented in the install guide's Install
section and Troubleshooting table. And **plugin marketplace hardening** (control/
invisible character rejection, escape-safe text) — checked with a Unicode
category scan over every plugin `name`/`description` string in all three manifests,
zero hits, already clean. Also checked and not applicable: the `/claude-api` skill's
new Admin API coverage and `cost-optimize` subcommand — this catalog ships no
`claude-api` skill and no Python/Anthropic-SDK code of its own. Everything else in
2.1.247 (`SendFeedback`, tip-rotation and permission-prompt UI, arrow-key/history-search
input fixes, sub-agent fallback-chain fix, hook/background-agent error-output fix,
terminal/keyboard fixes, `/terminal-setup`, `/rename`, `/compact`, background-session
UI/memory fixes, Remote Control diff reporting, self-hosted runner status, gateway/
MCP-failure messaging, Sonnet 5's auto-compact window, and analytics/sign-in changes)
is host/CLI/session-side with no marketplace-manifest surface.
`.claude-plugin/marketplace.json` itself is unchanged — nothing in 2.1.247 requires a
manifest schema or field change. CI still runs `claude plugin validate --strict
.agents/skills`, adopting 2.1.233's native skill-frontmatter check; it passed clean
against the live 2.1.247 CLI on 2026-08-27, as did a full `make validate` (regenerate +
validate manifests, 3 plugins in sync, no drift).
Codex was revalidated against the **0.147.0** release on **2026-08-09** by comparing the
official release delta with this catalog's `.agents/plugins/marketplace.json`
installation surface. Cursor was revalidated against **3.16.17** on **2026-08-17**.
Claude Code's 2026-08-27 direct CLI validation is now the most recent review of any
target and therefore the `last_reviewed` date. Each target's `verification_method` in
the JSON records exactly how.

## Two corrected version floors

Both of these were fiction before 2026-08-03:

- **Cursor `0.45.0`** predates Cursor's plugin system entirely — a 0.x release could never
  have imported a team marketplace. Cursor's docs state **no** minimum version for plugins,
  so the floor is now the version this catalog was actually validated on (3.16.17) rather
  than a guess.
- **Codex `0.40.0`** is kept as the floor because that is the earliest release this catalog
  has claimed `.agents/plugins/marketplace.json` support for. The catalog was exercised on
  0.146.0 and revalidated for 0.147.0's portable Agent Plugin catalog support.

## What "supported" means per target

This repo is a **catalog**, not a plugin: it holds marketplace manifests only, and the
plugin source lives in each plugin's own repository. So "supported" means different things
on different hosts.

| Target | Catalog install | Manifest read | Notes |
|--------|-----------------|---------------|-------|
| Claude Code | ✅ `claude plugin marketplace add` | `.claude-plugin/marketplace.json` | Canonical manifest — the other two are generated from it |
| Cursor | ✅ Dashboard → Import from Repo | `.cursor-plugin/marketplace.json` | Teams/Enterprise feature; no CLI equivalent |
| Codex | ✅ `codex plugin marketplace add` | `.agents/plugins/marketplace.json` | **Not** `.codex-plugin/marketplace.json`; compatible with 0.147.0 portable Agent Plugin catalogs |
| OpenCode | ❌ no marketplace concept | — | Install each plugin repo directly; see below |

### OpenCode

OpenCode has no plugin marketplace and no plugin manifest format, so **this catalog cannot
be added as an install source there**. That is a platform gap, not an omission — it is
recorded under `targets.opencode.capability_gaps` in the JSON.

What works instead: every plugin in this catalog ships its own `opencode.json` and its own
OpenCode install guide. Clone the plugin repo and OpenCode discovers its skills natively
via `skills.paths`. The plugin table in the [README](../../../README.md) is the discovery
surface that a marketplace would otherwise provide.

## Keeping this current

```bash
make platform-targets-sync    # refresh latest_known from npm / GitHub releases
make validate                 # regenerate manifests and re-check everything
```

`--sync` refreshes `latest_known` for Claude Code (`@anthropic-ai/claude-code`), OpenCode
(`opencode-ai`), and Codex (GitHub releases). **Cursor has no public version endpoint**, so
its entry is bumped by hand — read `cursor --version` and update the JSON.

`scripts/check-platform-targets.sh` enforces that every target listed in `supported_targets`
has a `validated_against` value and a matching README badge. The target list is data-driven:
adding a fifth target means adding it to `supported_targets`, and the check picks it up with
no script change.

# Platform target versions

`tamirs-marketplace` supports **four** agent targets. This file is the human mirror of
[`platform-targets.json`](platform-targets.json), which is the machine-readable source
enforced by `scripts/check-platform-targets.sh`.

| Platform | Min supported | Validated against | Latest known | Install guide |
|----------|---------------|-------------------|--------------|---------------|
| Claude Code | 2.0.0 | 2.1.251 | 2.1.251 | [claude-code.md](../../user/install/claude-code.md) |
| Cursor | 3.16.17 | 3.16.17 | 3.16.17 | [cursor.md](../../user/install/cursor.md) |
| Codex | 0.40.0 | 0.147.0 | 0.147.0 | [codex.md](../../user/install/codex.md) |
| OpenCode | 1.16.2 | 1.18.11 | 1.18.15 | [opencode.md](../../user/install/opencode.md) |

All four versions were read from the CLIs themselves on 2026-08-03. Claude Code is now
directly CLI-validated at **2.1.251** on **2026-08-30** (`claude --version` on the
runner reports 2.1.251) — the third consecutive run with a live CLI available, so
`validated_against` and `latest_known` stay equal. The 2.1.248 → 2.1.251 delta (2.1.249
and 2.1.250 published no separate changelog specifics) was reviewed against the catalog
surface. Three items are directly about marketplace/catalog/worktree behavior and got a
real check rather than a rubber stamp: **plugin-command path-traversal rejection**
(2.1.251) — a marketplace entry's declared command pointing outside the plugin directory
is now rejected at load; checked directly against `.claude-plugin/marketplace.json`, none
of this catalog's three plugin entries declare a `commands` field at all, so not
applicable. **The marketplace-refresh-race plugin-skills fix** (2.1.251) — a background
session could start with zero plugin skills, and stay that way, if another Claude Code
process refreshed the plugin marketplace at the same moment; now documented as a
Troubleshooting row. And **the GitLab `--worktree --tmux` fetch fix** (2.1.251) — a
`gitlab.com`-origin worktree no longer tries a doomed GitHub-style fetch first; documented
alongside the existing GitLab marketplace/worktree guidance. Also checked: 2.1.248's MCP
`headersHelper`-with-`Authorization` fix (the helper is now re-run and the call retried on
a 401, instead of falling into OAuth discovery, matching what was always documented) —
noted alongside this guide's existing `headersHelper` coverage; and 2.1.248's
`experimental.cacheTtl` agent-frontmatter setting — not applicable, this catalog ships no
agent definitions. Everything else in 2.1.248–2.1.251 (`--restricted`, self-hosted-runner
and `claude agents` UI/reliability fixes, cross-session messaging on Bedrock/Vertex/
Foundry, spend-limit/`/cost`/`/usage` UI, `PreModelSwitch`/`PostModelSwitch` hooks,
Remote Control and cloud-session fixes, unrelated sandbox/security hardening, and
terminal/UI polish) is host/CLI/session-side with no marketplace-manifest surface.
`.claude-plugin/marketplace.json` itself is unchanged — nothing in 2.1.248–2.1.251
requires a manifest schema or field change. CI still runs `claude plugin validate
--strict .agents/skills`, adopting 2.1.233's native skill-frontmatter check; it passed
clean against the live 2.1.251 CLI on 2026-08-30, as did a full `make validate`
(regenerate + validate manifests, 3 plugins in sync, no drift).
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

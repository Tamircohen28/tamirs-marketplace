# Platform target versions

`tamirs-marketplace` supports **four** agent targets. This file is the human mirror of
[`platform-targets.json`](platform-targets.json), which is the machine-readable source
enforced by `scripts/check-platform-targets.sh`.

| Platform | Min supported | Validated against | Latest known | Install guide |
|----------|---------------|-------------------|--------------|---------------|
| Claude Code | 2.0.0 | 2.1.263 | 2.1.263 | [claude-code.md](../../user/install/claude-code.md) |
| Cursor | 3.18.9 | 3.18.9 | 3.18.9 | [cursor.md](../../user/install/cursor.md) |
| Codex | 0.40.0 | 0.147.0 | 0.147.0 | [codex.md](../../user/install/codex.md) |
| OpenCode | 1.16.2 | 1.18.11 | 1.18.15 | [opencode.md](../../user/install/opencode.md) |

All four versions were read from the CLIs themselves on 2026-08-03. Claude Code is now
directly CLI-validated at **2.1.263** on **2026-09-06** (`claude --version` on the
runner reports `2.1.263 (Claude Code)`), continuing the run of live-CLI validation since
2.1.257 and covering the 2.1.260 → 2.1.263 delta. `validated_against` and `latest_known`
both land on **2.1.263** together this run — no divergence. 2.1.263 shipped only "bug
fixes and reliability improvements" with no itemized changelog entries — reviewed,
nothing to adopt. Three items from 2.1.260/2.1.261 are documented: **Claude apps gateway
`userPluginMarketplacesEnabled`/`userPluginUploadsEnabled`** (2.1.260) — new `desktop`
policy keys letting an admin block end users from adding their own marketplaces or
uploading local plugins in Claude Desktop, now noted in the install guide's managed-
environments section; the **`@synced`-plugin/managed-`enabledPlugins` marketplace-clone-
fallback fix** (2.1.261) — a cloud session could previously discard a plugin already
synced from claude.ai when managed settings force-enabled it via `enabledPlugins`, then
fall back to a marketplace clone that could itself fail, now noted alongside the existing
`@synced` coexistence documentation; and **`/reload-plugins` in headless sessions**
(2.1.260) — now available to the Desktop app and SDK command lists. Reviewed and found
not applicable, each checked directly rather than assumed: `/skill-doctor` (2.1.261, a
runtime loaded-skill-pruning tool, not a static frontmatter check); `bashOutputMaxChars`/
`taskOutputMaxChars` and `--append-subagent-system-prompt-file` (2.1.261, no script here
approaches any output limit or passes a subagent system prompt); the reverted 2.1.259
`Read()`-deny-rule-on-Bash-args change (2.1.260, no `Read(...)`/`Edit(...)` permission
rule examples exist anywhere in this repo); the URL-typed-marketplace-directory path-
containment fix (2.1.260, this catalog is always added via the `github` shorthand, never
a raw URL-typed marketplace source); the two model-switching-blocked fixes for a failed
plugin hook load and a failed managed-plugin-marketplace load (2.1.260, no hooks and no
managed org here); and the managed `skillOverrides`-alias / `Skill(name)`-deny-rule-on-
nested-skill fixes (2.1.260, this catalog's skill lives at the bare path
`.agents/skills/run-plugins-catalog`, not behind a plugin-bundled `<dir>:name` alias). The
prior 2.1.258 changelog (two host/session-side bug fixes) and the 2.1.252 → 2.1.259
review (the plugin symlink component-path rejection, the marketplace URL trailing-slash
fix, and MCP OAuth/connection log credential redaction — all checked directly and found
not applicable or already adopted) remain documented in the install guide's per-version
sections; nothing about that prior review changes now that it's been reconfirmed against
a live 2.1.263 CLI. `.claude-plugin/marketplace.json` itself is unchanged — nothing from
2.1.252 through 2.1.263 requires a manifest schema or field change. CI still runs `claude
plugin validate --strict --json .agents/skills` (via `make validate-skills`); it passed
clean against the live 2.1.263 CLI on 2026-09-06, as did a full `make validate`
(regenerate + validate manifests, `make agent:check`, 3 plugins in sync, no drift). Codex
was revalidated against the **0.147.0** release on **2026-08-09** by comparing the
official release delta with this catalog's `.agents/plugins/marketplace.json`
installation surface. Cursor was revalidated against **3.18.9** on **2026-09-06** (changelog through the
date-only **2026-09-02** Self-Hosted Machines entry). Claude Code and Cursor were both
reviewed on **2026-09-06**, which is therefore the `last_reviewed` date. Each target's
`verification_method` in the JSON records exactly how.

## Two corrected version floors

Both of these were fiction before 2026-08-03:

- **Cursor `0.45.0`** predates Cursor's plugin system entirely — a 0.x release could never
  have imported a team marketplace. Cursor's docs state **no** minimum version for plugins,
  so the floor is now the version this catalog was actually validated on (3.18.9) rather
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

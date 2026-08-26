# Platform target versions

`tamirs-marketplace` supports **four** agent targets. This file is the human mirror of
[`platform-targets.json`](platform-targets.json), which is the machine-readable source
enforced by `scripts/check-platform-targets.sh`.

| Platform | Min supported | Validated against | Latest known | Install guide |
|----------|---------------|-------------------|--------------|---------------|
| Claude Code | 2.0.0 | 2.1.246 | 2.1.246 | [claude-code.md](../../user/install/claude-code.md) |
| Cursor | 3.16.17 | 3.16.17 | 3.16.17 | [cursor.md](../../user/install/cursor.md) |
| Codex | 0.40.0 | 0.147.0 | 0.147.0 | [codex.md](../../user/install/codex.md) |
| OpenCode | 1.16.2 | 1.18.11 | 1.18.15 | [opencode.md](../../user/install/opencode.md) |

All four versions were read from the CLIs themselves on 2026-08-03. Claude Code is now
directly CLI-validated at **2.1.246** on **2026-08-26** (`claude --version` on the
runner reports 2.1.246), closing the gap the prior two runs left between
`validated_against` (stuck at 2.1.241) and a changelog-only `latest_known` (2.1.245) —
both figures are equal again. The 2.1.242-2.1.246 delta was reviewed against the catalog
surface: 2.1.245 (a Linux glibc 2.44 startup crash fix, host binary, no catalog
surface), 2.1.244/2.1.242 (no separately documented changes), 2.1.243 (the `managed`
connector marker in `/mcp`/`/plugins`, documented in the Claude Code install guide; a
`--plugin-dir` cross-marketplace-dependency resolution fix that doesn't affect this
catalog's normal `/plugin install` path; a `/reload-plugins` LSP-tool fix not applicable
since no plugin here ships an LSP integration), and 2.1.246 (a `claude plugin update
<name>` bare-name fix and a `claude plugin install <name>` clear-error-on-corrupted-
`known_marketplaces.json` fix, both documented in the install guide; a plugin.json
UTF-8 BOM install-breaking bug — checked, no manifest in this repo carries a BOM and
this catalog ships no `plugin.json` of its own; a `/reload-plugins` fix for skills under
a plugin's `skills/*/SKILL.md` — checked, this catalog's own skill lives in a bare
`.agents/skills` directory, not a plugin's `skills/` tree, so unaffected; a skill-
frontmatter `<plugin>:` name-doubling fix — checked, this catalog's skill frontmatter
carries no plugin-name prefix). `.claude-plugin/marketplace.json` itself is unchanged —
this catalog's `github`-source entries are all public and need no auth. CI still runs
`claude plugin validate --strict .agents/skills`, adopting 2.1.233's native
skill-frontmatter check; it passed clean against the live 2.1.246 CLI on 2026-08-26, as
did a full `make validate` (regenerate + validate manifests, 3 plugins in sync).
Codex was revalidated against the **0.147.0** release on **2026-08-09** by comparing the
official release delta with this catalog's `.agents/plugins/marketplace.json`
installation surface. Cursor was revalidated against **3.16.17** on **2026-08-17**.
Claude Code's 2026-08-26 direct CLI validation is now the most recent review of any
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

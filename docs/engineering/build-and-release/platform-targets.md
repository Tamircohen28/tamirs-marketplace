# Platform target versions

`tamirs-marketplace` supports **four** agent targets. This file is the human mirror of
[`platform-targets.json`](platform-targets.json), which is the machine-readable source
enforced by `scripts/check-platform-targets.sh`.

| Platform | Min supported | Validated against | Latest known | Install guide |
|----------|---------------|-------------------|--------------|---------------|
| Claude Code | 2.0.0 | 2.1.257 | 2.1.257 | [claude-code.md](../../user/install/claude-code.md) |
| Cursor | 3.16.17 | 3.16.17 | 3.16.17 | [cursor.md](../../user/install/cursor.md) |
| Codex | 0.40.0 | 0.147.0 | 0.147.0 | [codex.md](../../user/install/codex.md) |
| OpenCode | 1.16.2 | 1.18.11 | 1.18.15 | [opencode.md](../../user/install/opencode.md) |

All four versions were read from the CLIs themselves on 2026-08-03. Claude Code is now
directly CLI-validated at **2.1.257** on **2026-09-02** (`claude --version` on the
runner reports 2.1.257) — the fifth consecutive run with a live CLI available, so
`validated_against` and `latest_known` stay equal. 2.1.253–2.1.256 do not exist as
public releases, so the reviewed delta is 2.1.252 → 2.1.257 in full, reviewed
line-by-line against the catalog surface. Two items had any catalog-adjacent surface at
all, and both were checked directly, not assumed: **plugin symlink component-path
rejection** — Claude Code now refuses a plugin's declared command, agent, skill, hooks,
or other component path that is a symlink escaping the plugin's own directory,
broadening 2.1.251's commands-only path-traversal check to every declared
component-path field; checked directly against `.claude-plugin/marketplace.json` and
the generated manifests — none of this catalog's three plugin entries declare a
`commands`, `agents`, `skills`, or `hooks` field, and `find . -type l` confirms this
repository has no symlinks anywhere, so not applicable on both counts; and **MCP
connection/OAuth log credential redaction** — debug/error logs now redact credentials
carried in a server's URL or request headers, hardening the `headersHelper` mechanism
this guide already documents (2.1.238, OAuth-retry fixed 2.1.248) for a future
private/token-gated entry, though none of this catalog's public `github`-source entries
use it today. Everything else in 2.1.257 (Fable 5.1, `timeFormat`/`timeZone` settings,
the auto-mode Containment Escape rule, `CLAUDE_CODE_SUBAGENT_MODEL_FORCE`, and a long
list of host/session/IDE bug fixes and VS Code changes) is host/CLI/editor-side with no
plugin, marketplace, or skill-loading surface — none touch how a marketplace or plugin
manifest is read, cached, or validated, so no new install-guide section beyond a short
summary or Troubleshooting row was needed. The prior 2.1.248 → 2.1.252 review remains
documented below and in the install guide's "Claude Code 2.1.248 – 2.1.251" and
"Claude Code 2.1.252" sections: the marketplace-refresh-race plugin-skills fix, the
GitLab `--worktree --tmux` fetch fix, and the MCP `headersHelper`-with-`Authorization`
OAuth-retry fix. `.claude-plugin/marketplace.json` itself is unchanged — nothing in
2.1.257 (or 2.1.252 and earlier before it) requires a manifest schema or field change.
CI still runs `claude plugin validate --strict .agents/skills`, adopting 2.1.233's
native skill-frontmatter check; it passed clean against the live 2.1.257 CLI on
2026-09-02, as did a full `make validate` (regenerate + validate manifests, 3 plugins in
sync, no drift). Codex was revalidated against the **0.147.0** release on **2026-08-09**
by comparing the official release delta with this catalog's
`.agents/plugins/marketplace.json` installation surface. Cursor was revalidated against
**3.16.17** on **2026-08-17**. Claude Code's 2026-09-02 direct CLI validation is now the
most recent review of any target and therefore the `last_reviewed` date. Each target's
`verification_method` in the JSON records exactly how.

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

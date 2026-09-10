# Platform target versions

`tamirs-marketplace` supports **four** agent targets. This file is the human mirror of
[`platform-targets.json`](platform-targets.json), which is the machine-readable source
enforced by `scripts/check-platform-targets.sh`.

| Platform | Min supported | Validated against | Latest known | Install guide |
|----------|---------------|-------------------|--------------|---------------|
| Claude Code | 2.0.0 | 2.1.268 | 2.1.268 | [claude-code.md](../../user/install/claude-code.md) |
| Cursor | 3.18.9 | 3.18.9 | 3.18.9 | [cursor.md](../../user/install/cursor.md) |
| Codex | 0.40.0 | 0.153.4 | 0.153.4 | [codex.md](../../user/install/codex.md) |
| OpenCode | 1.16.2 | 1.18.29 | 1.18.29 | [opencode.md](../../user/install/opencode.md) |

All four versions were read from the CLIs themselves on 2026-08-03. Claude Code is now
directly CLI-validated at **2.1.268** on **2026-09-10** (`claude --version` on the
runner reports `2.1.268 (Claude Code)`), continuing the run of live-CLI validation since
2.1.257 and covering the 2.1.264 → 2.1.268 delta. `validated_against` and `latest_known`
both land on **2.1.268** together this run — no divergence. 2.1.264 and 2.1.266 shipped
no itemized changelog entries beyond "bug fixes and reliability improvements" — reviewed,
nothing to adopt; 2.1.267's own two items (the Discover/Browse missing-description fix and
the marketplace-description-authority change) plus its marketplace-entry-backslash
containment security fix were reviewed and documented in the prior run. Three items from
2.1.268 are newly documented: **`--json` added to `claude plugin install/uninstall/
update/enable/disable`, plus `errorDetails`/`noteDetails` added to each `claude plugin
list --json` row** — noted in the install guide's Useful-flags section and a new
Troubleshooting row, giving a contributor scripting an install smoke test or diagnosing a
broken install structured output from every plugin lifecycle subcommand, not just `plugin
validate`; **`/plugin` install/enable/disable now take effect on menu close with no
`/reload-plugins` needed** — extends the existing 2.1.221 instant-activation note
(previously install-only) to enable/disable too; and **plugin/marketplace error messages
no longer leak a token or password embedded in a git source URL** — noted in
`docs/agent-guidelines/security.md` as a defense-in-depth confirmation (this catalog's
entries use the credential-free `github`+`repo` shorthand, never a raw URL with embedded
credentials, so it was never exposed either way). Reviewed and found not applicable, each
checked directly rather than assumed: `claude plugin validate` rejecting a plugin path
whose directory name begins with two dots (2.1.268 fix) — this catalog's entries are
always `github` sources, never local directories; a default monitors file or root
`SKILL.md` silently skipped when it can't be checked (2.1.268 fix) — re-ran `claude
plugin validate --strict --json .agents/skills` live against the 2.1.268 CLI and it
reports `"success": true` with an empty `contents` array, so this catalog's root
`SKILL.md` was already checked cleanly either way; the Claude apps gateway `pricing:`/
`gatewayInternalNetworks` additions and `claude self-hosted-runner --remove-session-state`
(all 2.1.268) — no gateway or self-hosted runner is configured for this personal catalog;
and `configDirectory` added to `claude auth status --json` (2.1.268) — no script here
calls `claude auth status`. The prior 2.1.263 review (three 2.1.260/2.1.261 items
documented, `/skill-doctor` and several other 2.1.260/2.1.261 items found not applicable)
and the 2.1.252 → 2.1.259 review remain documented in the install guide's per-version
sections; nothing about those prior reviews changes now that they've been reconfirmed
against a live 2.1.268 CLI. `.claude-plugin/marketplace.json` itself is unchanged —
nothing from 2.1.264 through 2.1.268 requires a manifest schema or field change. CI still
runs `claude plugin validate --strict --json .agents/skills` (via `make
validate-skills`); it passed clean against the live 2.1.268 CLI on 2026-09-10, as did a
full `make validate` (regenerate + validate manifests, `make agent:check`, 3 plugins in
sync, no drift). Codex
was revalidated against the **0.153.4** release on **2026-09-08** by comparing the
0.148.0 → 0.153.4 release delta with this catalog's `.agents/plugins/marketplace.json`
installation surface. That delta is additive for catalogs: 0.153.0 added
remote-marketplace support to the `codex plugin` CLI (#42150) and began upgrading Git
marketplaces from merged configuration (#42149), while #41953's marketplace source
policy applies only to OpenAI-curated plugins. The portable catalog shape is unchanged.
Codex is validated documentarily — the CLI is not installed on the review machine, which
is why `verification_method` in the JSON says so rather than implying a live run. Cursor was revalidated against **3.18.9** on **2026-09-06** (changelog through the
date-only **2026-09-02** Self-Hosted Machines entry). OpenCode was revalidated against
**1.18.29** on **2026-09-08** — `opencode --version` reported `1.18.29` on the
maintainer machine, and `opencode debug skill` with `skills.paths` pointed at this repo's
`.agents/skills` resolved `run-plugins-catalog` to its `SKILL.md`, so native skill
discovery still works unchanged. Reviewing the 1.18.12 → 1.18.29 release notes turned up
exactly one skills-related entry (a docs path fix, #42337) and no plugin-marketplace or
plugin-manifest concept, so both OpenCode capability gaps below stand as written.
Claude Code's **2026-09-10** review (above) is the most recent verification of any
target and is therefore the `last_reviewed` date. Each target's `verification_method` in
the JSON records exactly how.

## Two corrected version floors

Both of these were fiction before 2026-08-03:

- **Cursor `0.45.0`** predates Cursor's plugin system entirely — a 0.x release could never
  have imported a team marketplace. Cursor's docs state **no** minimum version for plugins,
  so the floor is now the version this catalog was actually validated on (3.18.9) rather
  than a guess.
- **Codex `0.40.0`** is kept as the floor because that is the earliest release this catalog
  has claimed `.agents/plugins/marketplace.json` support for. The catalog was exercised on
  0.146.0 and revalidated through 0.153.4's portable Agent Plugin catalog support.

## What "supported" means per target

This repo is a **catalog**, not a plugin: it holds marketplace manifests only, and the
plugin source lives in each plugin's own repository. So "supported" means different things
on different hosts.

| Target | Catalog install | Manifest read | Notes |
|--------|-----------------|---------------|-------|
| Claude Code | ✅ `claude plugin marketplace add` | `.claude-plugin/marketplace.json` | Canonical manifest — the other two are generated from it |
| Cursor | ✅ Dashboard → Import from Repo | `.cursor-plugin/marketplace.json` | Teams/Enterprise feature; no CLI equivalent |
| Codex | ✅ `codex plugin marketplace add` | `.agents/plugins/marketplace.json` | **Not** `.codex-plugin/marketplace.json`; compatible with 0.153.4 portable Agent Plugin catalogs |
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

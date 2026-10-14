# Platform target versions

`tamirs-marketplace` supports **four** agent targets. This file is the human mirror of
[`platform-targets.json`](platform-targets.json), which is the machine-readable source
enforced by `scripts/check-platform-targets.sh`.

| Platform | Min supported | Validated against | Latest known | Install guide |
|----------|---------------|-------------------|--------------|---------------|
| Claude Code | 2.0.0 | 2.1.300 | 2.1.300 | [claude-code.md](../../user/install/claude-code.md) |
| Cursor | 3.18.9 | 3.18.9 | 3.18.9 | [cursor.md](../../user/install/cursor.md) |
| Codex | 0.40.0 | 0.153.4 | 0.153.4 | [codex.md](../../user/install/codex.md) |
| OpenCode | 1.16.2 | 1.18.29 | 1.18.29 | [opencode.md](../../user/install/opencode.md) |

Claude Code now tracks **2.1.300**, reviewed live on **2026-10-14** — this run's runner
has the `claude` CLI installed and `claude --version` reported `2.1.300 (Claude Code)`,
matching the target exactly, continuing the live-CLI confirmation from the prior
2.1.293 run (2026-10-07). `make validate`, `make validate-skills`, `make assert-contract`,
and `scripts/check-platform-targets.sh --assert-current` all passed clean against it.
`validated_against` and `latest_known` both land on **2.1.300** together — no
divergence, covering seven releases (2.1.294 → 2.1.300; 2.1.297/2.1.298 do not exist as
public releases) in one pass. The reviewed delta:

- **2.1.294 – 2.1.299: a hook-failure semantics change spanning three releases.** This
  manifest-only catalog ships no `hooks.json`/`plugin.json` itself, so this was audited
  against the sibling plugin repos instead. 2.1.295 added `onFailure: "block"` for
  command/HTTP hooks (a hook that can't start, times out, or exits unexpectedly now
  blocks the action under that explicit setting); 2.1.299 then changed the **unset
  default itself** — an action a plugin hook can block is now *refused*, not let
  through, when the hook can't be handed the call or can't hand back an answer; and
  2.1.294 separately fixed `prompt`/`agent` hooks written as natural-language
  instructions allowing what they should have blocked. Re-ran `claude plugin validate
  --strict --json` against all three listed plugin repos on the live 2.1.300 CLI:
  `tamirs-superpowers`' mod (`mod/register.tsx`) still registers its 4 gating hooks
  (`agent.spawn`, `prompt.submit`, `tool.call`, `session.compact`) with no `.catch` —
  previously a soft finding ("fails open or closed depending on the mod runtime's own
  default"), now resolved by 2.1.299 to fail **closed**: safer by default, but an
  unhandled exception in any of those four hooks now blocks an action it would have let
  through before. Escalated below under Future opportunities for that repo's own
  nightly — not actionable from this manifest-only catalog.
- **New, undated finding:** `claude plugin validate --strict --json` on the live 2.1.300
  CLI reports a "CLAUDE.md at the plugin root is not loaded as project context" warning
  for all three listed plugin repos (each ships a root `CLAUDE.md` beside
  `.claude-plugin/plugin.json`), not present in the 2026-10-07 audit on 2.1.293 and not
  tied to a specific numbered changelog entry in the 2.1.294 → 2.1.300 range. `headhunter`
  still separately carries its 3 pre-existing unknown-field warnings
  (`engines`/`peerDependencies`/`requiredEnvVars`); `jose-claudinho` is otherwise clean.
  Flagged for those repos' own maintenance, not actionable here.
- **2.1.300:** Re-ran `claude plugin test .` against `tamirs-superpowers`' mod suite
  live: 21/21 pass, unchanged from the 2.1.293 run. Reviewed with no catalog surface:
  `virtualText` mod decorations, `$.ui.view({agentId})`, the new `prompt.change` mod
  hook, `updatedInput` from PreToolUse/PermissionRequest hooks now being validated (all
  mod-dev/hooks surface relevant to `tamirs-superpowers`' own mod, not to this
  manifest-only catalog), and the removal of the no-op `--sandbox`/`--no-sandbox` flags
  from `claude remote-control` (this catalog's scripts never invoke it).
Reviewed and found no further catalog surface across the whole range: 2.1.295's Program
Status Protocol, `$.ui.notify` and mod-`Button` children (mod-dev/terminal-UI only), the
MCP tool-description cut raised to 16,384 characters and claude.ai-connector MCP
protocol 2026-07-28 default (no `.mcp.json` here), and the README-install-line advice in
`claude plugin validate` (this catalog's own README already has one); 2.1.296's `code`
gateway-policy key, `autoCompactWindow` for subagents, the default MCP
description/instruction limit rising 2,048→4,096, and Sonnet 5.5 cache-read pricing (no
gateway, subagents, `.mcp.json`, or billing surface here); and 2.1.299's
`$.prompt.media`/`$.session.identity()` for managed-settings mods, idle compaction,
`UserPromptSubmit` now running before skill/command expansion, and MCP allow rules
matching only the exact named server (no `.mcp.json` or Bash permission-rule examples
in this catalog's docs — checked directly). None of the 2.1.294 → 2.1.300 delta requires
a manifest schema or field change. `claude plugin validate --strict --json
.agents/skills` (via `make validate-skills`) and the structural checks
(`scripts/validate-marketplaces.py`: JSON schema and plugin-name parity across the
three generated manifests) were both re-run live against the 2.1.300 CLI and passed.
The full 2.1.264 → 2.1.293 history (2.1.275's `--marketplace <source>` and
terminal-session claude.ai sync, 2.1.277's AGENTS.md fallback and TaskOutput removal,
2.1.278's auto-mode classifier change, 2.1.280's `installed_plugins.json` and
`manifest.json` fixes, 2.1.281's `claude plugin update` scope fix and hook/MCP validate
checks, 2.1.282's uninstall settings-safety fix, 2.1.283's validate checks, 2.1.284's
marketplace-add replace-notice, 2.1.285's `--config`/`configure`, 2.1.286's npm install
restriction, 2.1.287's Claude Mods, 2.1.289's plugin-folder validate-skip fix, 2.1.290's
gating-hooks report, and 2.1.292's name-length cap/test-`expect`-fix/marketplace
autoadd) remains documented in the install guide's per-version sections; nothing about
those prior reviews changes now. Codex was revalidated against the **0.153.4**
release on
**2026-09-08** by comparing the 0.148.0 → 0.153.4 release delta with this catalog's
`.agents/plugins/marketplace.json` installation surface. That delta is additive for
catalogs: 0.153.0 added remote-marketplace support to the `codex plugin` CLI (#42150)
and began upgrading Git marketplaces from merged configuration (#42149), while #41953's
marketplace source policy applies only to OpenAI-curated plugins. The portable catalog
shape is unchanged. Codex is validated documentarily — the CLI is not installed on the
review machine, which is why `verification_method` in the JSON says so rather than
implying a live run. Cursor was revalidated against **3.18.9** on **2026-09-06**
(changelog through the date-only **2026-09-02** Self-Hosted Machines entry). OpenCode
was revalidated against **1.18.29** on **2026-09-08** — `opencode --version` reported
`1.18.29` on the maintainer machine, and `opencode debug skill` with `skills.paths`
pointed at this repo's `.agents/skills` resolved `run-plugins-catalog` to its `SKILL.md`,
so native skill discovery still works unchanged. Reviewing the 1.18.12 → 1.18.29 release
notes turned up exactly one skills-related entry (a docs path fix, #42337) and no
plugin-marketplace or plugin-manifest concept, so both OpenCode capability gaps below
stand as written. Claude Code's **2026-10-14** live-CLI confirmation (above) is the most
recent verification of any target and is therefore the `last_reviewed` date. Each target's
`verification_method` in the JSON records exactly how.

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

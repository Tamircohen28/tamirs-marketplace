# Platform target versions

`tamirs-marketplace` supports **four** agent targets. This file is the human mirror of
[`platform-targets.json`](platform-targets.json), which is the machine-readable source
enforced by `scripts/check-platform-targets.sh`.

| Platform | Min supported | Validated against | Latest known | Install guide |
|----------|---------------|-------------------|--------------|---------------|
| Claude Code | 2.0.0 | 2.1.293 | 2.1.293 | [claude-code.md](../../user/install/claude-code.md) |
| Cursor | 3.18.9 | 3.18.9 | 3.18.9 | [cursor.md](../../user/install/cursor.md) |
| Codex | 0.40.0 | 0.153.4 | 0.153.4 | [codex.md](../../user/install/codex.md) |
| OpenCode | 1.16.2 | 1.18.29 | 1.18.29 | [opencode.md](../../user/install/opencode.md) |

Claude Code now tracks **2.1.293**, reviewed live on **2026-10-07** — this run's runner
has the `claude` CLI installed and `claude --version` reported `2.1.293 (Claude Code)`,
matching the target exactly, continuing the live-CLI confirmation from the prior
2.1.286 run (2026-09-30). `make validate`, `make validate-skills`, `make assert-contract`,
and `scripts/check-platform-targets.sh --assert-current` all passed clean against it.
`validated_against` and `latest_known` both land on **2.1.293** together — no
divergence, covering seven releases (2.1.287 → 2.1.293) in one pass. The reviewed delta:

- **2.1.287:** Added **Claude Mods** — a new plugin component type that runs in-process
  on Claude Code and the Desktop Code tab (panes, the band above the prompt, reacting to
  pushed state). This catalog ships no `plugin.json` of its own, so it cannot carry a mod
  directly, but `tamirs-superpowers` already ships one (`mod/register.tsx`) — confirmed
  live by re-cloning that repo and running `claude plugin test .`: 21/21 mod tests pass on
  2.1.293. Documented in the install guide's What-you-get row.
- **2.1.289:** Fixed `claude plugin validate` silently **skipping** a plugin folder that
  also held a marketplace manifest. Directly relevant here — all three listed plugin
  repos ship both `plugin.json` and `marketplace.json` side by side for standalone
  installs. Re-ran `claude plugin validate --strict --json` against each on this fixed
  CLI: `headhunter` still has its 3 pre-existing unknown-field warnings
  (`engines`/`peerDependencies`/`requiredEnvVars`), `tamirs-superpowers` and
  `jose-claudinho` are clean. Also: as part of this audit, the `tamirs-superpowers`
  hooks.json issue flagged in the 2.1.286 pass (27 unquoted-`${CLAUDE_PLUGIN_ROOT}`
  warnings) is **confirmed fixed upstream** — zero warnings now.
- **2.1.290:** Added `claude plugin validate --json`'s `gatingHooks` report (each gating
  hook and whether it has a `.catch`). Empty for this catalog's own manifest (no
  `plugin.json` here); run as a deeper audit against `tamirs-superpowers`' mod, which
  surfaced 4 gating hooks (`agent.spawn`, `prompt.submit`, `tool.call`,
  `session.compact`) with no `.catch` — flagged below under Future opportunities for
  that repo's own nightly.
- **2.1.292:** Three catalog-relevant changes. (1) Plugin/skill names over 256 characters
  are now ignored — checked every name in this catalog's and all three plugin repos'
  manifests; the longest is `tamirs-superpowers` at 19 characters, far under the cap.
  (2) `claude plugin test` now reports a mod's `expect` failures instead of passing
  silently — re-ran it live against `tamirs-superpowers`' mod suite (21 pass, 0 fail).
  (3) `claude plugin install --marketplace <source>` now adds the marketplace first if
  it isn't already added, instead of only selecting among already-added ones — a genuine
  one-step alternative to `marketplace add` + `install`, documented in the install
  guide's Useful-flags section.
None of the 2.1.287 → 2.1.293 delta requires a manifest schema or field change.
`claude plugin validate --strict --json .agents/skills` (via `make validate-skills`) and
the structural checks (`scripts/validate-marketplaces.py`: JSON schema and plugin-name
parity across the three generated manifests) were both re-run live against the 2.1.293
CLI and passed. The full 2.1.264 → 2.1.286 history (2.1.275's `--marketplace <source>`
and terminal-session claude.ai sync, 2.1.277's AGENTS.md fallback and TaskOutput removal,
2.1.278's auto-mode classifier change, 2.1.280's `installed_plugins.json` and
`manifest.json` fixes, 2.1.281's `claude plugin update` scope fix and hook/MCP validate
checks, 2.1.282's uninstall settings-safety fix, 2.1.283's validate checks, 2.1.284's
marketplace-add replace-notice, 2.1.285's `--config`/`configure`, and 2.1.286's npm
install restriction) remains documented in the install guide's per-version sections;
nothing about those prior reviews changes now. Codex was revalidated against the **0.153.4**
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
stand as written. Claude Code's **2026-10-07** live-CLI confirmation (above) is the most
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

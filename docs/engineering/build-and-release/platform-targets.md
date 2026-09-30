# Platform target versions

`tamirs-marketplace` supports **four** agent targets. This file is the human mirror of
[`platform-targets.json`](platform-targets.json), which is the machine-readable source
enforced by `scripts/check-platform-targets.sh`.

| Platform | Min supported | Validated against | Latest known | Install guide |
|----------|---------------|-------------------|--------------|---------------|
| Claude Code | 2.0.0 | 2.1.286 | 2.1.286 | [claude-code.md](../../user/install/claude-code.md) |
| Cursor | 3.18.9 | 3.18.9 | 3.18.9 | [cursor.md](../../user/install/cursor.md) |
| Codex | 0.40.0 | 0.153.4 | 0.153.4 | [codex.md](../../user/install/codex.md) |
| OpenCode | 1.16.2 | 1.18.29 | 1.18.29 | [opencode.md](../../user/install/opencode.md) |

Claude Code now tracks **2.1.286**, reviewed live on **2026-09-30** — this run's runner
has the `claude` CLI installed and `claude --version` reported `2.1.286 (Claude Code)`,
matching the target exactly, continuing the live-CLI confirmation from the prior
2.1.281 run (2026-09-23). `make validate`, `make validate-skills`, and
`scripts/check-platform-targets.sh --assert-current` all passed clean against it.
`validated_against` and `latest_known` both land on **2.1.286** together — no
divergence, covering five releases (2.1.282 → 2.1.286) in one pass. The reviewed delta:

- **2.1.282:** `claude plugin uninstall` now stops and names the settings file instead
  of silently deleting a plugin's saved options/secrets when that file still enables the
  plugin or can't be read, in either direction (before or after the uninstall list write)
  — host-lifecycle hardening with no manifest surface, noted as a new troubleshooting row
  in the install guide.
- **2.1.283:** `claude plugin validate` gained two checks relevant to a catalog
  maintainer: a `marketplace.json` entry naming a plugin/marketplace Claude Code can't
  actually install now **fails** validation instead of passing silently, and a plugin
  declaring `outputStyles`/`themes`/`monitors`/`lspServers` paths that are missing or
  point outside its own directory is now caught too. Re-ran `claude plugin validate
  --strict .` against this catalog's own manifest (clean — plain lowercase-hyphen names)
  and against all three listed plugin repos as an audit (read-only clones; no findings).
  Also fixed: `claude plugin details` showing 0 MCP servers for a plugin that declares
  them in `plugin.json`, `claude plugin marketplace remove` now listing which installed
  plugins it removed, and plugins with no `version` field restoring at their source's
  newest commit (not the installed one) when their cache is missing — the last one
  already describes all three of this catalog's plugins, which have tracked their source
  branch head all along, so behavior here is unchanged, not newly exposed.
- **2.1.284:** `claude plugin marketplace add` now says when it replaces a marketplace
  already added under the same name from a different source, and how to undo it —
  documented as a new troubleshooting row. Also fixed a `sparsePaths` marketplace cloning
  empty and replacing a working local copy on older git (this catalog's manifest sets no
  `sparsePaths`) and a failed first `claude plugin install` leaving the plugin enabled
  when a dependency's version range couldn't be met (this catalog's one cross-marketplace
  dependency, `allowCrossMarketplaceDependenciesOn: [superpowers-dev]`, has never hit
  this path in review).
- **2.1.285:** Added **`claude plugin install --config <server>.<key>=<value>`**, which
  sets a bundled `.mcpb` MCP server's own settings at install time so it starts without a
  manual `/plugin` → Configure visit, and **`claude plugin configure <plugin>`**, which
  shows a plugin's options and which are unset or saves new values from stdin with
  `--values-stdin`. Both documented in the install guide's Useful-flags section —
  directly relevant to `headhunter`, whose Gmail/Calendar/Notion/Todoist integrations are
  exactly the kind of bundled MCP server `--config` targets, and noted in
  `docs/agent-guidelines/security.md` as the preferred, non-interactive way to set a
  bundled server's secrets. Also fixed plugin/marketplace installs over SSH ignoring the
  `GIT_SSH`/`core.sshCommand` program, `claude plugin disable`/`enable` with a full
  `name@marketplace` id touching a settings entry in the wrong letter case (this
  catalog's own name and all three plugin names are already consistently lowercase), and
  improved marketplace git-address-refused and git-URL-validation error messages (this
  catalog's sources are the credential-free `github`+`repo` shorthand, never a raw URL).
- **2.1.286:** Fixed plugin errors for a marketplace Claude Code refuses to load to say
  why and how to fix it instead of "not found" — a refinement to this guide's existing
  "Marketplace file not found" troubleshooting row. Changed plugin installs to refuse npm
  sources that are git repositories or folders and to install plugin dependencies only
  from registry packages — this catalog's manifests use only `github` sources, per
  AGENTS.md's "Never change `source: github`" rule, so unaffected either way.

None of the 2.1.282 → 2.1.286 delta requires a manifest schema or field change.
`claude plugin validate --strict --json .agents/skills` (via `make validate-skills`) and
the structural checks (`scripts/validate-marketplaces.py`: JSON schema and plugin-name
parity across the three generated manifests) were both re-run live against the 2.1.286
CLI and passed. The full 2.1.264 → 2.1.281 history (2.1.275's `--marketplace <source>`
and terminal-session claude.ai sync, 2.1.277's AGENTS.md fallback and TaskOutput removal,
2.1.278's auto-mode classifier change, 2.1.280's `installed_plugins.json` and
`manifest.json` fixes, and 2.1.281's `claude plugin update` scope fix and hook/MCP
validate checks) remains documented in the install guide's per-version sections; nothing
about those prior reviews changes now. Codex was revalidated against the **0.153.4**
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
stand as written. Claude Code's **2026-09-30** live-CLI confirmation (above) is the most
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

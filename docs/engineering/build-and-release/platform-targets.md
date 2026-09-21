# Platform target versions

`tamirs-marketplace` supports **four** agent targets. This file is the human mirror of
[`platform-targets.json`](platform-targets.json), which is the machine-readable source
enforced by `scripts/check-platform-targets.sh`.

| Platform | Min supported | Validated against | Latest known | Install guide |
|----------|---------------|-------------------|--------------|---------------|
| Claude Code | 2.0.0 | 2.1.278 | 2.1.278 | [claude-code.md](../../user/install/claude-code.md) |
| Cursor | 3.18.9 | 3.18.9 | 3.18.9 | [cursor.md](../../user/install/cursor.md) |
| Codex | 0.40.0 | 0.153.4 | 0.153.4 | [codex.md](../../user/install/codex.md) |
| OpenCode | 1.16.2 | 1.18.29 | 1.18.29 | [opencode.md](../../user/install/opencode.md) |

Claude Code now tracks **2.1.278**, reviewed on **2026-09-20** by changelog (no `claude`
CLI on that run's runner; the prior run's live 2.1.274 verification stood for the
2.1.274 baseline). Confirmed live the following run, **2026-09-21** — that runner had the
`claude` CLI installed and `claude --version` reported `2.1.278 (Claude Code)`, matching
the target exactly; `make validate` and `make validate-skills` both passed clean against
it. `validated_against` and `latest_known` both land on **2.1.278** together — no
divergence, covering the 2.1.274 → 2.1.278 delta:

- **2.1.275:** Added `/plugin install <plugin> --marketplace <source>` for explicit
  marketplace targeting — documented in the install guide's Useful-flags section, useful
  when a plugin name exists in more than one marketplace you've added. Added syncing of
  skills/plugins enabled on the claude.ai account into **terminal** sessions (previously
  cloud-session-only), opt-out via `syncClaudeAiSkills: false` / `syncClaudeAiPlugins:
  false` — this extends the existing `@synced` behavior documented under 2.1.239 to
  terminal sessions too, noted there. A plugin/marketplace secret-in-URL leak fix and a
  `marketplace update` fetch-failure-deletes-local-copy fix are both reviewed and
  inapplicable: this catalog's manifests use the credential-free `github`+`repo`
  shorthand, never a raw URL with embedded credentials.
- **2.1.276:** Shipped no itemized changelog entries beyond bug fixes — reviewed,
  nothing to adopt, matching the 2.1.264/2.1.266/2.1.270/2.1.272 fix-only precedent.
- **2.1.277:** Added **AGENTS.md as a CLAUDE.md fallback** — in a project with no
  CLAUDE.md, Claude Code now reads AGENTS.md instead. This repo ships both `AGENTS.md`
  and `CLAUDE.md` (the latter just imports the former), so contributors working in this
  repo are unaffected either way, but it's now documented in `AGENTS.md` that the file is
  read directly by Claude Code on any project that lacks its own CLAUDE.md, not only via
  the `@AGENTS.md` import this repo's CLAUDE.md uses. **Removed the deprecated TaskOutput
  tool** — a breaking change for anything referencing it. Searched the full repo
  (`search_code` for `TaskOutput` across every skill, doc, and script) and found zero
  references, so nothing here breaks. Also shipped a batch of `claude plugin
  install`-related bug fixes (reinstalling a plugin version already in use, `/plugin`
  stripping terminal control characters, property-named plugins/skills crashing
  `/plugin`, uninstalled plugins reappearing as failed rows, plugins not recording their
  commit in `installed_plugins.json`, plugin reload previews leaving unpacked copies
  behind) — all host-side install-flow fixes with no marketplace-manifest or
  skill-loading surface for a catalog to act on.
- **2.1.278:** Changed Auto mode's default classifier for API/Enterprise/Bedrock/
  Vertex/Foundry/gateway users to the server-side one (no billing for classifier
  overhead), with `CLAUDE_CODE_AUTO_MODE_SERVER=0` to opt out, plus a new "Auto mode
  server" `/status` row. A billing/runtime behavior with zero marketplace-manifest,
  plugin-source, or skill-loading surface for this catalog.

None of the 2.1.275 → 2.1.278 delta requires a manifest schema or field change.
`claude plugin validate --strict --json .agents/skills` could not be re-run live this
cycle (no CLI on the runner) — CI's `skill-validate` job runs it for real on every push —
but the structural checks (`scripts/validate-marketplaces.py`: JSON schema and
plugin-name parity across the three generated manifests) were run locally against the
updated files and passed. Codex was revalidated against the **0.153.4** release on
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
stand as written. Claude Code's **2026-09-21** live-CLI confirmation (above) is the most
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

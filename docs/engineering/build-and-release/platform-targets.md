# Platform target versions

`tamirs-marketplace` supports **four** agent targets. This file is the human mirror of
[`platform-targets.json`](platform-targets.json), which is the machine-readable source
enforced by `scripts/check-platform-targets.sh`.

| Platform | Min supported | Validated against | Latest known | Install guide |
|----------|---------------|-------------------|--------------|---------------|
| Claude Code | 2.0.0 | 2.1.273 | 2.1.273 | [claude-code.md](../../user/install/claude-code.md) |
| Cursor | 3.18.9 | 3.18.9 | 3.18.9 | [cursor.md](../../user/install/cursor.md) |
| Codex | 0.40.0 | 0.153.4 | 0.153.4 | [codex.md](../../user/install/codex.md) |
| OpenCode | 1.16.2 | 1.18.29 | 1.18.29 | [opencode.md](../../user/install/opencode.md) |

All four versions were read from the CLIs themselves on 2026-08-03. Claude Code now
tracks **2.1.273**, validated live on **2026-09-16** — the runner's `claude --version`
reports `2.1.273 (Claude Code)`, matching the target exactly (the prior run, on
2026-09-15, landed one release behind the runner's live CLI and had to fall back to a
changelog-based review for 2.1.271/2.1.272 — see the Claude Code 2.1.258 section of
[claude-code.md](../../user/install/claude-code.md) for that precedent). `validated_against`
and `latest_known` both land on **2.1.273** together this run — no divergence, covering
the 2.1.272 → 2.1.273 delta. Reviewed the full published 2.1.273 changelog entry
line by line: every New-Features line restates or extends an item from the 2.1.271
delta already reviewed below (gateway hint headers, MCP-disconnect notification,
`--remote-control` session forking, Remote Control fast mode, `/config` panel mouse
support, `--drain-marker-file`, per-command `allowed_domains`, `omitClaudeMd`,
`--accept-command <sha256>`, the `modelPricing` multiplier, and a spinner tip) — nothing
new to adopt or exempt on a second look. None of 2.1.273's Bug Fixes, Improvements, or
Changes entries touch marketplace-manifest, plugin-source, or skill-loading behavior;
checked directly for the closest candidates: skills synced from claude.ai staying
available after an org disables Skills (this catalog's own skill is a plain repo skill,
never cloud-synced) and 'sign-in with a Claude account also requests access to your
claude.ai plugins' (an account-scope change, not a marketplace or install-flow change).
2.1.273's Platform-Specific entries (VSCode, Windows, Claude Code on the web, Claude Tag,
Code Review) are all host/editor/chat-app-side with zero surface here. **2.1.272**
shipped only "bug fixes and reliability improvements" with no itemized entries —
reviewed, nothing to adopt, matching the 2.1.263/2.1.264/2.1.266 fix-only precedent.
**2.1.271** is the most recent substantive delta:

- **`--accept-command <sha256>` added to `claude plugin install` and `claude plugin
  update`.** Lets a script accept exactly the command a previous `--json` run
  displayed, instead of the broader `-y`. Documented in the install guide's Useful-flags
  section alongside the existing 2.1.268 `--json` note.
- Reviewed and found not applicable, each checked directly: **enterprise
  `managed-mcp.json` parse-failure fix** (an unreadable/unparseable file now keeps
  exclusive MCP control and warns at startup instead of being silently ignored) — this
  personal catalog configures no `managed-mcp.json` and no managed MCP servers (checked
  via `grep`; the only existing mention of `managed-mcp.json` in this repo's docs is the
  unrelated 2.1.259 `allowedMcpServers` scoping note); **`omitClaudeMd`** agent
  frontmatter / `--agents` JSON field — this catalog ships no custom or plugin subagents,
  only the `run-plugins-catalog` contributor skill; **per-command `allowed_domains` on
  Bash/PowerShell/Monitor in auto mode with sandboxing** — this catalog's own scripts run
  local checks only, with no network-domain requirements, and this repo documents no
  Bash permission-rule examples for a consuming user to update either; **`modelPricing`
  multiplier above 1** — no gateway or chargeback configuration exists here.

Everything else in 2.1.271 (Remote/self-hosted-runner fast mode and
`--drain-marker-file`, `/config` panel mouse support, org-policy-cache/tool-list-refresh
fixes, `ANTHROPIC_UNIX_SOCKET` proxy fix, cloud-session subagent schema-validation fix,
`/fast` fixes, the Bash-permission-check/`git`/sandbox fixes, MCP OAuth/tool-search/
reconnect fixes, cross-session-message delivery notices, background-command double-start
fix, `/model`/`/reload-skills`/`/resume`/`/teleport`/`--resume` fixes,
artifact-watching/Markdown-artifact-rendering improvements, terminal/rendering/spinner/
hook-feedback polish, dynamic-workflow pause/resume, Claude in Chrome messaging, and
`claude mcp serve` progress pings) is host/session/CI-side with zero marketplace-manifest,
plugin-source, or skill-loading surface. The prior 2.1.270 review (2.1.269's `claude
plugin eval` and archive-extraction security items, both documented; 2.1.270 itself a
pure compatibility bump) and everything from 2.1.252 through 2.1.269 remain documented
in the install guide's per-version sections; nothing about those prior reviews changes
now. `.claude-plugin/marketplace.json` itself is unchanged — nothing from 2.1.271 through
2.1.273 requires a manifest schema or field change. CI still runs `claude plugin
validate --strict --json .agents/skills` (via `make validate-skills`); it passed clean
on this run against the live 2.1.273 CLI, as did a full `make validate` (regenerate +
validate manifests, `make agent:check`, 3 plugins in sync, no drift). Codex
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
Claude Code's **2026-09-16** review (above) is the most recent verification of any
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

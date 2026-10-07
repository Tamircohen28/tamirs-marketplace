# Testing — validating changes

There is no application to run; "tests" here mean manifest validation.

- Run `make validate` before committing. It regenerates the Codex/Cursor
  manifests, validates all three, and fails if generated files are out of sync.
- CI runs the same `make validate` on every push and pull request, plus a skill
  frontmatter check, a secret scan and a README non-empty check.
- `scripts/check-agent-drift.sh` verifies the agent-instruction files stay
  consistent (AGENTS.md present, CLAUDE.md imports it, Cursor rule points to it).
- `make validate-skills` runs Claude Code 2.1.233's native `claude plugin validate
  --strict` against `.agents/skills`, catching a `SKILL.md` frontmatter parse error
  that would otherwise just make the skill silently fail to load. Since 2.1.259 it
  also passes `--json`, piping the machine-readable report through
  `scripts/report-skill-validation.py` for a short pass/fail summary (still driven
  by the report's own `success` field, not `claude`'s raw exit code). It's a soft
  no-op locally if the `claude` CLI isn't installed. Run it before committing a
  skill change. **CI runs it for real** in the `skill-validate` job, which installs
  `@anthropic-ai/claude-code` on the runner and then calls `make validate-skills`,
  so a `SKILL.md` frontmatter error fails the build rather than passing silently
  through the local soft-skip.
- **Validating a plugin repo this catalog points at.** This repo ships no `plugin.json`,
  `hooks.json` or `.mcp.json`, so `claude plugin validate --strict .` here only checks the
  marketplace manifest. When working on one of the listed plugins (`tamirs-superpowers`,
  `jose-claudinho`, `headhunter`), run `claude plugin validate` against its
  `.claude-plugin/plugin.json` too: since Claude Code 2.1.281 it warns when a shell-form
  hook leaves `${CLAUDE_PLUGIN_ROOT}` unquoted (breaks on plugin paths with spaces —
  quote it or use exec form), and checks `.mcp.json` for entries that would be silently
  dropped, undeclared `${user_config.*}` references, and insecure URLs. It also no longer
  reports `privacyPolicyUrl`/`supportUrl` as unknown `plugin.json` fields, so there is no
  need to strip them to get a clean run on 2.1.281+. Since Claude Code 2.1.283, the same
  command also fails a `marketplace.json` entry that names a plugin or marketplace Claude
  Code can't actually install (previously accepted silently), and warns when a plugin's
  `outputStyles`/`themes`/`monitors`/`lspServers` paths are missing or point outside its
  own directory — check a listed plugin repo's own `plugin.json` against these when it
  ships any of those four fields.
- **Before Claude Code 2.1.289, this audit could silently miss findings.** `claude plugin
  validate` used to skip a plugin folder entirely when it also held a marketplace
  manifest — and all three listed plugin repos ship both `plugin.json` and
  `marketplace.json` side by side in `.claude-plugin/` (for their standalone install
  path). Fixed in 2.1.289. Re-run the audit above on 2.1.289+ to get real results; a
  2026-10-07 re-run against the live 2.1.293 CLI found `headhunter` still has 3
  pre-existing unknown-field warnings (`engines`/`peerDependencies`/`requiredEnvVars`,
  harmless at load time) and the other two clean — including confirmation that
  `tamirs-superpowers`' hooks.json unquoted-`${CLAUDE_PLUGIN_ROOT}` warnings (27 of them,
  flagged in a prior pass) are now fixed upstream.
- **`claude plugin validate --json`'s `gatingHooks` report (Claude Code 2.1.290+).**
  Lists each gating hook a plugin's mod registers and whether it has a `.catch`. No
  surface on this catalog's own manifest (empty — no `plugin.json` here); run as a
  deeper audit against a listed plugin's `plugin.json` when it ships a mod.
  `tamirs-superpowers`' mod currently has 4 gating hooks with no `.catch`
  (`agent.spawn`, `prompt.submit`, `tool.call`, `session.compact`) — a finding for that
  repo's own maintenance, not this one.
- **Mod tests (Claude Code 2.1.287+ `claude plugin test [dir]`).** Runs a plugin's mod
  test suite. `tamirs-superpowers` is the only one of the three with a mod
  (`mod/register.tsx` + `mod/mods.test.tsx`); its suite passes 21/21 live against
  2.1.293. Since Claude Code 2.1.292, a failing `expect` inside a mod hook test is
  reported instead of passing silently — re-run after any CLI upgrade if a mod-bearing
  plugin's test suite hasn't been re-checked since.
- **Plugin/skill name length (Claude Code 2.1.292+).** A `name` over 256 characters is
  now ignored at load time instead of partially working. Checked this catalog's own
  manifest and all three listed plugins' manifests — the longest name is
  `tamirs-superpowers` at 19 characters.
- **This catalog's own `claude plugin validate --strict .`** re-runs clean on 2.1.283+'s
  marketplace-name check (all three entries use plain lowercase-hyphen names); the
  `outputStyles`/`themes`/`monitors`/`lspServers` check has no surface on this repo's own
  manifest, which declares none of those fields.

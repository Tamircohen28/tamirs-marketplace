# Testing — validating changes

There is no application to run; "tests" here mean manifest validation.

- Run `make validate` before committing. It regenerates the Codex/Cursor
  manifests, validates all three, and fails if generated files are out of sync.
- CI runs the same `make validate` on every push and pull request, plus a secret
  scan and a README non-empty check.
- `scripts/check-agent-drift.sh` verifies the agent-instruction files stay
  consistent (AGENTS.md present, CLAUDE.md imports it, Cursor rule points to it).
- `make validate-skills` runs Claude Code 2.1.233's native `claude plugin validate
  --strict` against `.agents/skills`, catching a `SKILL.md` frontmatter parse error
  that would otherwise just make the skill silently fail to load. Since 2.1.259 it
  also passes `--json`, piping the machine-readable report through
  `scripts/report-skill-validation.py` for a short pass/fail summary (still driven
  by the report's own `success` field, not `claude`'s raw exit code). It's a soft
  no-op locally if the `claude` CLI isn't installed. Run it before committing a
  skill change. **Not yet wired into CI** — the GitHub App token this catalog's
  automation runs under has no `workflows` scope, so it cannot push
  `.github/workflows/*.yml` changes; adding a `skill-validate` job (install
  `@anthropic-ai/claude-code`, then run this command) is a small follow-up for
  whoever next edits a workflow file by hand — the `--json` report is already in
  the shape that job would want to consume.

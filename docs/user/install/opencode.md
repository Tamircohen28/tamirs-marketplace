# Install — OpenCode

| | |
|---|---|
| **Validated against** | OpenCode **1.18.11** |
| **Minimum supported** | **1.16.2** |
| **Marketplace manifest** | *none — OpenCode has no marketplace format* |
| **Official docs** | [Skills](https://opencode.ai/docs/skills/) · [Agents](https://opencode.ai/docs/agents/) · [Config schema](https://opencode.ai/config.json) |

Check your version:

```bash
opencode --version
```

## This catalog cannot be installed on OpenCode

OpenCode has no plugin marketplace and no plugin manifest format, so there is nothing for
`tamirs-plugins` to hook into. This is a platform gap, tracked under
`targets.opencode.capability_gaps` in
[`platform-targets.json`](../../engineering/build-and-release/platform-targets.json) — not
an omission in this repo.

**What works instead:** install each plugin repo directly. OpenCode reads skills natively,
and every plugin in this catalog ships its own `opencode.json` declaring where its skills
live. The [plugin table in the README](../../../README.md#plugins) is the discovery surface
a marketplace would otherwise provide.

## Install a plugin

Pick the repo you want and clone it:

```bash
git clone https://github.com/Tamircohen28/tamirs-superpowers
cd tamirs-superpowers
opencode          # skills load from the repo's own opencode.json
```

That works because OpenCode reads skills natively from, in order of precedence:

- `.opencode/skills/`
- `.claude/skills/`
- `.agents/skills/`
- any directory listed in `skills.paths` in `opencode.json`

Each plugin repo ships an `opencode.json` like:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "skills": { "paths": ["skills"] }
}
```

### Using a plugin's skills from *your* project

Clone the plugin somewhere permanent and point your own `opencode.json` at it with an
**absolute** path:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "skills": { "paths": ["/Users/you/src/tamirs-superpowers/skills"] }
}
```

## Verify

```bash
opencode debug skill                  # lists every skill OpenCode resolved
opencode debug agent <agent-name>     # shows an agent's resolved model and tools
opencode debug config                 # shows the merged config
```

> **Do not paste raw `opencode debug config` output into an issue or a PR.** It resolves
> `{env:...}` interpolation, so any token you have configured appears in cleartext.

## Config gotchas

OpenCode's config is stricter than the other three hosts. Every one of these has bitten
someone:

| Gotcha | Detail |
|--------|--------|
| `mcp[name].command` is an **array** | `["npx", "-y", "server"]`, never a single string |
| `type` is required on MCP entries | `"local"` for stdio servers |
| Interpolation is `{env:VAR}` | Shell-style `${VAR}` is **not** substituted |
| Paths must be absolute | Relative `skills.paths` resolve against the project root only |
| Unknown top-level keys fail hard | `ConfigInvalidError` at startup, not a warning |
| No hot reload | Config loads once at startup — restart after editing |

Escape hatches when a project config is in your way:

```bash
OPENCODE_DISABLE_PROJECT_CONFIG=1 opencode
OPENCODE_CONFIG=/path/to/opencode.json opencode
OPENCODE_CONFIG_CONTENT='{"skills":{"paths":["/abs/path"]}}' opencode
OPENCODE_DISABLE_EXTERNAL_SKILLS=1 opencode
```

## Known gaps versus the other three targets

| Feature | On OpenCode |
|---------|-------------|
| Marketplace / catalog install | ❌ none — clone each plugin repo |
| Slash commands (`/plugin:command`) | ❌ none — skills are model-invoked by description |
| `hooks/hooks.json` | ❌ none — lifecycle automation is JS/TS plugin modules only |
| `.mcp.json` autowiring | ❌ not read — declare MCP servers by hand under `mcp` |
| Agent frontmatter | ⚠️ incompatible schema — `tools` must be an object of tool→bool and `model` must be provider-prefixed (`anthropic/claude-sonnet-4-6`). Plugins that ship agents commit generated adapters under `.opencode/agent/`. |
| Agent tool restriction | ⚠️ `tools` is an enable/disable **overlay** on the default set, not a whitelist like Claude Code's — OpenCode agents see more tools than their frontmatter lists |
| Web search | ❌ no `websearch` tool exists. The resolved set is `bash, read, glob, grep, edit, write, task, webfetch, todowrite, skill`. Agents that lean on search degrade to `webfetch` on explicit URLs. |

Skills themselves are **identical** across all four targets — only discovery and invocation
differ.

## Update

```bash
cd tamirs-superpowers && git pull
```

Restart OpenCode. There is no `plugin update` equivalent.

## Uninstall

Delete the clone and remove its path from `skills.paths`.

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `ConfigInvalidError` at startup | An unknown top-level key, or `mcp.command` given as a string instead of an array. `opencode debug config` shows the merged result. |
| Skills don't appear | Run `opencode debug skill`. A relative `skills.paths` entry resolves against the project root — use an absolute path when pointing outside it. |
| An MCP token isn't picked up | Use `{env:VAR}`, not `${VAR}` — OpenCode does not do shell interpolation. |
| Config edits have no effect | Config loads once at startup. Restart OpenCode. |
| An agent has tools it shouldn't | Expected — `tools` is an overlay, not a whitelist. See the gaps table above. |
| An agent can't search the web | Expected — OpenCode has no `websearch` tool. Give it an explicit URL so it can `webfetch`. |

More: [troubleshooting.md](../troubleshooting.md).

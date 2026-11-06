# Maintaining the catalog

This repository is a plugin marketplace. It has one catalog and three manifests, because
each platform that has a marketplace reads its own file. Only the Claude manifest is edited
by hand. `make generate` writes the Cursor and Codex manifests from it, and `make validate`
fails when they drift.

| Platform | Manifest | How it is produced | Who reads it |
|---|---|---|---|
| Claude Code / Claude Desktop | `.claude-plugin/marketplace.json` | hand-edited (canonical) | `claude plugin marketplace add Tamircohen28/tamirs-marketplace` |
| Cursor | `.cursor-plugin/marketplace.json` | `make generate` | Dashboard → Plugins & MCPs → Team Marketplaces → Import from Repo |
| Codex | `.agents/plugins/marketplace.json` | `make generate` | `codex plugin marketplace add Tamircohen28/tamirs-marketplace` |
| OpenCode | none | none | OpenCode has no marketplace; install each plugin repo per [install/opencode.md](install/opencode.md) |

## Add a plugin

Every plugin in this catalog lives in its own GitHub repository. The catalog holds no plugin
code of its own.

1. Add an entry to `.claude-plugin/marketplace.json`. Use a `url` source with an `https`
   Git URL, so installs do not need a GitHub SSH key:

   ```json
   {
     "name": "your-plugin",
     "source": {
       "source": "url",
       "url": "https://github.com/Tamircohen28/your-plugin.git",
       "ref": "main"
     },
     "description": "Filled in by make sync-descriptions."
   }
   ```

2. Run `make sync-descriptions`. It copies the plugin repo's GitHub description into the
   entry and regenerates the Cursor and Codex manifests. For Codex, each entry gets
   `policy.installation: AVAILABLE`, `policy.authentication: ON_INSTALL` and a `category`.
   For Cursor, the source is written as the repository's GitHub URL.
3. Add a row to the [README catalog table](../../README.md#catalog) and a `CHANGELOG.md`
   entry under `[Unreleased]`.
4. Run `make validate`.

The plugin repository must ship `.claude-plugin/plugin.json`, `.cursor-plugin/plugin.json`
and `.codex-plugin/plugin.json`, and the `name` in each must equal the catalog entry name.
See [CONTRIBUTING.md](../CONTRIBUTING.md) for the full requirements.

## Known limitation: Cursor URL sources

Cursor's [plugin reference](https://cursor.com/docs/reference/plugins) documents only path
sources (a directory inside the marketplace repository). This catalog has no local plugin
directories, so its Cursor manifest uses each plugin's GitHub URL as the source.
`scripts/validate-marketplace.sh` reports these entries as warnings instead of errors so
the gap stays visible. If Cursor rejects URL sources on import, the fallback is the
per-plugin local install in [install/cursor.md](install/cursor.md).

## Versioning

- A plugin's version lives in its own `plugin.json`. Catalog entries carry no `version`, so
  installs always resolve the plugin's own value.
- Removing a plugin from the Claude manifest does not uninstall it for users unless
  `forceRemoveDeletedPlugins` is `true`.

## Validate

```bash
make validate                          # generate, drift checks, both validators
bash scripts/validate-marketplace.sh . # also runs `claude plugin validate` when the CLI is installed
```

Cursor and Codex document no validator. The `jq` checks in `scripts/validate-marketplace.sh`
cover their documented rules: kebab-case names, the 10 MB cap, `policy.installation`
values, and a `category` on every entry.

## Sources

Read on 2026-11-06:

- <https://code.claude.com/docs/en/plugins/marketplace-reference>
- <https://cursor.com/docs/reference/plugins>
- <https://developers.openai.com/codex/plugins>
- <https://opencode.ai/docs/plugins/>

---

<p align="center"><a href="https://github.com/Tamircohen28">Have a Question?</a>&nbsp;·&nbsp;<a href="https://github.com/Tamircohen28/tamirs-marketplace/issues/new/choose">Open an Issue</a></p>

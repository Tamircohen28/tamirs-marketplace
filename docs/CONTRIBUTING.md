# Contributing

## Adding a plugin to the catalog

This repo is a catalog. Edit the canonical Claude manifest, then regenerate the Codex and Cursor manifests.

### Steps

1. Fork this repo and create a branch: `git checkout -b feat/add-<plugin-name>`

2. Open `.claude-plugin/marketplace.json` and add your plugin entry inside the `"plugins"` array:

```json
{
  "name": "your-plugin-name",
  "source": {
    "source": "github",
    "repo": "YourGitHubHandle/your-plugin-repo",
    "ref": "main"
  },
  "description": "One sentence describing what the plugin does."
}
```

3. Regenerate the Codex and Cursor manifests, then validate all three:

```bash
make generate && make validate
```

4. Add a row to the plugin table in `README.md` and a `CHANGELOG.md` entry under `[Unreleased]`.

5. Open a pull request. CI will regenerate manifests and fail if anything is out of sync.

## Requirements for listed plugins

- Plugin must have a public GitHub repo
- Plugin must contain a `.claude-plugin/` directory with a valid `plugin.json`
- Plugin must contain a `.cursor-plugin/plugin.json` for Cursor installs
- Plugin must contain a `.codex-plugin/plugin.json` for Codex installs
- Plugin must not contain employer-internal references, credentials, or proprietary IP
- Description must be one sentence, 10–100 characters

## Code of Conduct

Be respectful. This is a personal catalog — the maintainer reserves the right to decline additions that don't fit the project's scope.

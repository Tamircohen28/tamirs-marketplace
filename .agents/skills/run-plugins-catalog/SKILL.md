---
name: run-plugins-catalog
description: Validate and regenerate tamirs-marketplace marketplace manifests for contributors.
when_to_use: Contributor wants to verify manifest changes before opening a PR.
argument-hint: '[validate|generate]'
arguments: []
disable-model-invocation: true
user-invocable: true
allowed-tools:
- Bash
disallowed-tools: []
model: claude-sonnet-4-6
effort: low
context: ''
agent: ''
hooks: {}
paths: []
shell: bash
metadata:
  updated-date: '2026-07-10'
---

# run-plugins-catalog

Contributor skill for the tamirs-marketplace catalog.

```bash
make generate   # regenerate Codex + Cursor manifests
make validate     # full validation gate
make agent:check  # drift + platform targets
```

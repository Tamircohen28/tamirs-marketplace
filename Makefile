.PHONY: help install update uninstall generate validate validate-skills agent\:check agent-polish-gate \
	check-agent-drift check-feature-equivalence check-platform-targets \
	platform-targets-sync platform-targets-assert assert-contract repo-standards-gate

help:
	@echo "install update uninstall generate validate agent\:check repo-standards-gate"

install:
	@bash scripts/install.sh

update:
	@bash scripts/update.sh

uninstall:
	@bash scripts/uninstall.sh

generate:
	python3 scripts/generate-marketplaces.py

validate: generate agent-check
	python3 scripts/validate-marketplaces.py
	@git diff --exit-code -- .agents/plugins/marketplace.json .cursor-plugin/marketplace.json \
		|| (echo "Generated manifests are out of sync. Run 'make generate' and commit the results." >&2; exit 1)

# Native Claude Code (2.1.233+) SKILL.md frontmatter check. Soft-skips locally if the
# `claude` CLI isn't installed; CI (skill-validate job) installs it and runs this for real.
validate-skills:
	@if command -v claude >/dev/null 2>&1; then \
		claude plugin validate --strict .agents/skills; \
	else \
		echo "claude CLI not found — skipping local skill frontmatter check (CI runs this via the skill-validate job)"; \
	fi

check-agent-drift:
	bash scripts/check-agent-drift.sh .

check-feature-equivalence:
	bash scripts/check-feature-equivalence.sh .

check-platform-targets:
	bash scripts/check-platform-targets.sh .

platform-targets-sync:
	bash scripts/check-platform-targets.sh . --sync

platform-targets-assert:
	bash scripts/check-platform-targets.sh . --assert-current

# Canonical agent validation command: `make agent:check` (alias: `make agent-check`)
agent\:check: agent-check
agent-check: check-agent-drift check-feature-equivalence check-platform-targets

agent-polish-gate: platform-targets-sync platform-targets-assert agent\:check

assert-contract:
	@PROFILE=$$(bash scripts/contract/detect-contract-profile.sh .); \
	bash scripts/contract/assert-contract.sh . "$$PROFILE" --manifests-only

repo-standards-gate: agent-polish-gate validate assert-contract

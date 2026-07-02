.PHONY: generate validate agent-check

generate:
	python3 scripts/generate-marketplaces.py

validate: generate agent-check
	python3 scripts/validate-marketplaces.py
	@git diff --exit-code -- .agents/plugins/marketplace.json .cursor-plugin/marketplace.json \
		|| (echo "Generated manifests are out of sync. Run 'make generate' and commit the results." >&2; exit 1)

# Canonical agent validation command: `make agent:check` (alias: `make agent-check`)
agent\:check: agent-check
agent-check:
	bash scripts/check-agent-drift.sh

ANSIBLE_PLAYBOOK ?= site.yaml
ANSIBLE_FLAGS ?=

.PHONY: help
help: ## Show this help
	@awk 'BEGIN {FS=":|##"} \
	/^#--/ {gsub(/^#--[ \t]*/, "", $$0); printf "\033[33m%s\033[0m\n", $$0; next} \
	/^[A-Za-z0-9_.\/-]+:.*##/ { \
		target = $$1; gsub(/[ \t]+$$/, "", target); \
		deps = $$2; gsub(/^[ \t]+|[ \t]+$$/, "", deps); \
		desc = $$3; gsub(/^[ \t]+|[ \t]+$$/, "", desc); \
		if (deps == "") deps = "(no deps)"; \
		printf "\033[32m %-30s\033[0m %-25s %s\n", target, deps, desc; \
	}' $(MAKEFILE_LIST)

.PHONY: bootstrap ansible/install deps lint syntax check apply

#-- Bootstrap
bootstrap: ansible/install deps ## Install system Ansible and project collections

ansible/install: ## Install Ansible tools into the system
	sudo pacman -S --needed ansible-core ansible-lint

deps: ## Install Ansible Galaxy collections
	ansible-galaxy collection install -r requirements.yaml

#-- Checks
lint: ## Run ansible-lint
	ansible-lint $(ANSIBLE_PLAYBOOK) --offline

syntax: ## Run playbook syntax check
	ansible-playbook $(ANSIBLE_PLAYBOOK) --syntax-check

check: syntax lint ## Run all checks

#-- Apply
apply: ## Apply playbook locally
	./$(ANSIBLE_PLAYBOOK) $(ANSIBLE_FLAGS)

.DEFAULT_GOAL := help

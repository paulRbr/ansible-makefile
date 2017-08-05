playbook ?= setup
env      ?= hosts
opts     ?= $(args) --vault-password-file=pass.sh
ifneq ("$(limit)", "")
  opts   := $(opts) --limit $(limit)
endif
ifneq ("$(tag)", "")
  opts   := $(opts) --tag $(tag)
endif

.PHONY: install
install: ## make install # Install roles dependencies
	@ansible-galaxy install --roles-path vendor/ -r requirements.yml

.PHONY: lint
lint: ## make lint playbook=setup # Check syntax of a playbook
	@ansible-playbook -i $(env) --syntax-check $(opts) $(playbook).yml

.PHONY: debug
debug: mandatory-host-param ## make debug host=myhost # Debug a host's variable
	@ansible -i $(env) $(opts) -m debug -a "var=hostvars[inventory_hostname]" $(host)

.PHONY: dry-run
dry-run: ## make dry-run [playbook=setup] [env=integration] [tag=<ansible tag>] [limit=<ansible host limit>] [args=<ansible arguments>] # Run a playbook in dry run mode
	@ansible-playbook -i $(env) --diff --check $(opts) $(playbook).yml

.PHONY: run
run: ## make run [playbook=setup] [env=integration] [tag=<ansible tag>] [limit=<ansible host limit>] [args=<ansible arguments>] # Run a playbook
	@ansible-playbook -i $(env) --diff $(opts) $(playbook).yml

.PHONY: list
list: ## make list # List hosts inventory
	@[ -f $(env) ] && cat $(env) || \
	[ -f $(env)/hosts ] && cat $(env)/hosts

.PHONY: vault
vault: mandatory-file-param ## make vault file=/tmp/vault.yml # Edit or create a vaulted file
	@[ -f $(file) ] && ansible-vault $(opts) edit $(file) || \
	ansible-vault $(opts) create $(file)

.PHONY: console
console: ## make console # Run an ansible console
	@ansible-console -i $(env) $(opts)

group ?=all
.PHONY: facts
facts: ## make facts group=all # Gather facts from your hosts
	@ansible -m setup -i $(env) $(opts) --tree out/ $(group)

.PHONY: inventory-report
inventory-report: ## make inventory-report #
	@ansible-cmdb out/ > list-servers.html

.PHONY: mandatory-host-param mandatory-file-param
mandatory-host-param:
	[ ! -z $(host) ]
mandatory-file-param:
	[ ! -z $(file) ]

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

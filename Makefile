##
# VARIABLES
##
playbook   ?= setup
roles_path ?= "roles/"
env        ?= hosts
ifeq ("$(wildcard pass.sh)", "")
  opts     ?= $(args)
else # Handle vault password if any
  opts     ?= $(args) --vault-password-file=pass.sh
endif
ifneq ("$(limit)", "")
  opts     := $(opts) --limit $(limit)
endif
ifneq ("$(tag)", "")
  opts     := $(opts) --tag $(tag)
endif

##
# TASKS
##
.PHONY: install
install: ## make install [roles_path=roles/] # Install roles dependencies
	@ansible-galaxy install --roles-path="$(roles_path)" --role-file="requirements.yml"

.PHONY: lint
lint: ## make lint [playbook=setup] [env=hosts] [args=<ansible-playbook arguments>] # Check syntax of a playbook
	@env=$(env) ansible-playbook --inventory-file="$(env)" --syntax-check $(opts) "$(playbook).yml"

.PHONY: debug
debug: mandatory-host-param ## make debug host=hostname [env=hosts] [args=<ansible arguments>] # Debug a host's variable
	@env=$(env) ansible --inventory-file="$(env)" $(opts) --module-name="debug" --args="var=hostvars[inventory_hostname]" $(host)

.PHONY: dry-run
dry-run: ## make dry-run [playbook=setup] [env=hosts] [tag=<ansible tag>] [limit=<ansible host limit>] [args=<ansible-playbook arguments>] # Run a playbook in dry run mode
	@env=$(env) ansible-playbook --inventory-file="$(env)" --diff --check $(opts) "$(playbook).yml"

.PHONY: run
run: ## make run [playbook=setup] [env=hosts] [tag=<ansible tag>] [limit=<ansible host limit>] [args=<ansible-playbook arguments>] # Run a playbook
	@env=$(env) ansible-playbook --inventory-file="$(env)" --diff $(opts) "$(playbook).yml"

.PHONY: list
list: ## make list [env=hosts] # List hosts inventory
	@[ -f "$(env)" ] && cat "$(env)" || \
	[ -f "$(env)/hosts" ] && cat "$(env)/hosts"

.PHONY: vault
vault: mandatory-file-param ## make vault file=/tmp/vault.yml [env=hosts] [args=<ansible-vault arguments>] # Edit or create a vaulted file
	@[ -f "$(file)" ] && env=$(env) ansible-vault $(opts) edit "$(file)" || \
	env=$(env) ansible-vault $(opts) create "$(file)"

.PHONY: console
console: ## make console [env=hosts] [args=<ansible-console arguments>] # Run an ansible console
	@env=$(env) ansible-console --inventory-file="$(env)" $(opts)

group ?=all
.PHONY: facts
facts: ## make facts group=all [env=hosts] [args=<ansible arguments>] # Gather facts from your hosts
	@env=$(env) ansible --module-name="setup" --inventory-file="$(env)" $(opts) --tree="out/" $(group)

.PHONY: cmdb
cmdb: ## make cmdb # Create HTML inventory report
	@ansible-cmdb "out/" > list-servers.html

.PHONY: bootstrap
bootstrap: ## make bootstrap # Install ansible (Ubuntu only)
	@apt-get install -y software-properties-common && \
	apt-add-repository ppa:ansible/ansible && \
	apt-get update && \
	apt-get install -y ansible

.PHONY: mandatory-host-param mandatory-file-param
mandatory-host-param:
	@[ ! -z $(host) ]
mandatory-file-param:
	@[ ! -z $(file) ]

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

playbook ?= setup
opts     ?= $(args) --vault-password-file=pass.sh
env      ?= integration

install: ## make install # Install roles dependencies
	ansible-galaxy install --roles-path vendor/ -r requirements.yml

lint: ## make lint playbook=setup # Check syntax of a playbook
	ansible-playbook -i $(env) --syntax-check $(opts) $(playbook).yml

debug: mandatory-host-param ## make debug host=myhost # Debug a host's variable
	ansible -i $(env) $(opts) -m debug -a "var=hostvars[inventory_hostname]" $(host)

dry-run: ## make dry-run playbook=setup # Run a playbook in dry run mode
	ansible-playbook -i $(env) --diff --check $(opts) $(playbook).yml

run: ## make run playbook=setup # Run a playbook
	ansible-playbook -i $(env) $(opts) $(playbook).yml

list: ## make list # List hosts inventory
	cat hosts

mandatory-host-param:
	[ ! -z $(host) ]

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

.PHONY: install lint run dry-run debug list mandatory-host-param

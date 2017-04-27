# Makefile for Ansible users

This repository provides a Makefile to give you a simple interface for Ansible.

## Why?

- Simplify your CLI ansible runs
- Don't Repeat Yourself while typing ansible commands
- Easier adoption for people that are not used to Ansible
- Document common usage

## Available Commands

This is the list of commands made available

~~~bash
> make
console                        make console # Run an ansible console
debug                          make debug host=myhost # Debug a host's variable
dry-run                        make dry-run playbook=setup # Run a playbook in dry run mode
facts                          make facts group=all # Gather facts from your hosts
install                        make install # Install roles dependencies
inventory-report               make inventory-report #
lint                           make lint playbook=setup # Check syntax of a playbook
list                           make list # List hosts inventory
run                            make run playbook=setup # Run a playbook
vault                          make vault file=/tmp/vault.yml # Edit or create a vaulted file
~~~

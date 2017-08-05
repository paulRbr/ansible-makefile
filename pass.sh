#!/bin/bash

# ########################
#
# Output your vault passphrase within this script
#
# ===============
#
# = Recommended approach is to use a password manager:
#   1- GPG encrypted password manager (https://www.passwordstore.org/)
#   2- Vault from Hashicorp for example (https://www.hashicorp.com/blog/vault.html)
#   3- ...
#
# ===============
#
# This script is 1- GPG password manager "pass"
#
# ########################

if [ $(which pass) ];
then
    pass ansible-vault/$env
fi

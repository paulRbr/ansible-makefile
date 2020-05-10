#!/usr/bin/env bash

set -e

env=${env:-}

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

if (command -v pass >/dev/null 2>&1)
then
    existingVault=$(pass "ansible-vault/${env}" || true)

    if [ -n "${existingVault}" ]
    then
        >&2 echo "Using passphrase found at 'ansible-vault/${env}' in your password store."
        echo "${existingVault}"
    else
        >&2 echo "No passphrase found at 'ansible-vault/${env}' in your password store."
        >&2 echo "Defaulting to an random vault pass. Don't trust it if you are using vaulted variables!"
        echo "invalid_vault_pass"
    fi
fi

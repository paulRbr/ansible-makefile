#!/usr/bin/env bash

set -eo pipefail

current_version=$(cat VERSION)
bump_version=${1}

if [ -n "${bump_version}" ]
then
    echo "Bumping version from ${current_version} to ${bump_version}..."
    find . -maxdepth 1 -type f -exec sed -i "s|${current_version}|${bump_version}|" {} \;
    printf "\\033[32mDONE!\\033[0m ✔️\\n"
    echo "Bye 👋"
else
    echo "Usage: ${0} <new_version>"
    exit 1
fi

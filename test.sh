#!/bin/bash -e

echo "Checking Makefile syntax with simple run..."
make run  || (printf "\033[31mFAILED!\033[0m\n" && exit 1)
printf "\033[32mOK\033[0m\n"

echo "Checking difference between README.md and make help output..."
readme_help="$(awk '/> make/{f=1;next} /~~~/{f=0} f' README.md)"
make_help="$(make | sed 's,\x1B\[[0-9;]*[a-zA-Z],,g')"
diff <(echo "$readme_help") <(echo "$make_help") || (printf "\033[31mFAILED!\033[0m\n" && exit 1)
printf "\033[32mOK\033[0m\n"

echo "Checking version..."
[ "$(git grep $(cat VERSION) | wc -l)" -eq 3 ] || (printf "\033[31mFAILED!\033[0m\n" && exit 1)
printf "\033[32mOK\033[0m\n"

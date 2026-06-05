#!/bin/bash
# Find all test scripts and execute them in lexical order of script name.

# shellcheck disable=SC2034

dir=$(readlink -f "$(dirname "$0")")

while read -r script ; do
    echo "### RUNNING TESTS: $script ..." >&2
    if ! "$script" ; then
        echo "### SOME OR ALL TESTS FAILED: $script" >&2
        echo failed > /results/status
    else
        echo "### ALL TESTS SUCCEEDED: $script" >&2
        echo succeeded > /results/status
    fi
done < <(find "$dir" -name 'custom-*.sh')

read -r -p "Entering idle mode ..." noreply

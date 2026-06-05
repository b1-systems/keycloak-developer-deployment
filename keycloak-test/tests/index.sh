#!/bin/bash
# Find all test scripts and execute them in lexical order of script name.

# shellcheck disable=SC2034

dir=$(readlink -f "$(dirname "$0")")

echo running > /opt/keycloak/status.txt

while read -r script ; do
    echo "### RUNNING TESTS: $script ..." >&2
    if ! "$script" ; then
        echo "### SOME OR ALL TESTS FAILED: $script" >&2
        echo failed > /opt/keycloak/status.txt
    else
        echo "### ALL TESTS SUCCEEDED: $script" >&2
        echo succeeded > /opt/keycloak/status.txt
    fi
done < <(find "$dir" -name 'custom-*.sh')

echo "Entering idle mode ..." >&2
tail -f /opt/keycloak/status.txt

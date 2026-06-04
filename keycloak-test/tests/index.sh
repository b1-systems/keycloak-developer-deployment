#!/bin/bash

dir=$(readlink -f "$(dirname "$0")")

while read -r script ; do
    echo "### RUNNING TEST: $script ..."
    "$script"
done < <(find "$dir" -name 'custom-*.sh')

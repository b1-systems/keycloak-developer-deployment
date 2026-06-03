#!/bin/bash

dir=$(readlink -f "$(dirname "$0")")

"$dir"/custom-jpa-user-storage.sh

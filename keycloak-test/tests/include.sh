#!/bin/bash

##
# Configuration

keycloak_url="http://keycloak:8080"
keycloak_realm="master"
keycloak_admin_user="admin"
keycloak_admin_password="admin"

##
# Functions

check() {
    for status in "$@" ; do
        [[ $status -ne 0 ]] && {
            return 1
        }
    done

    return 0
}

kcadm_cmdline=(
    /opt/keycloak/bin/kcadm.sh
)

kcadm() {
    "${kcadm_cmdline[@]}" "$@"
}

##
# Main Program

kcadm config credentials \
    --server "$keycloak_url" \
    --realm "$keycloak_realm" \
    --user "$keycloak_admin_user" \
    --password "$keycloak_admin_password"

if check "${PIPESTATUS[@]}" ; then
    echo "INFO: Authenticated to Keycloak REST-API." >&2
else
    echo "ERROR: Authenticating to Keycloak REST-API failed." >&2
    exit 1
fi

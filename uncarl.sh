#!/usr/bin/env bash

ACCESSOR_ID="$(vault auth list -format=json | jq -r '.["oidc/"].accessor')"

echo "Accessor ID: ${ACCESSOR_ID}"

#
# unelevate carl
#

echo
echo "Unelevate Carl"
echo

ENTITY_ID="$(vault write -field=id -format=json identity/lookup/entity \
    alias_name='carldoe@contoso.com' \
    alias_mount_accessor="${ACCESSOR_ID}" | jq -r '.')"

if [[ -n "${ENTITY_ID}" ]]; then

vault delete identity/entity/id/"${ENTITY_ID}"

fi

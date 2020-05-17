#!/usr/bin/env bash

ACCESSOR_ID="$(vault auth list -format=json | jq -r '.["oidc/"].accessor')"

echo "Accessor ID: ${ACCESSOR_ID}"

#for id in $(vault list -format=json identity/entity/id | jq -r '.[]' ); do
#  vault delete identity/entity/id/"${id}"
#done

#for id in $(vault list -format=json identity/entity/id | jq -r '.[]' ); do
#  vault read identity/entity/id/"${id}"
#done

#for id in $(vault list -format=json identity/entity-alias/id | jq -r '.[]' ); do
#  vault read identity/entity-alias/id/"${id}"
#done

#
# elevate carl
#

echo
echo "Elevate Carl"
echo

ENTITY_ID="$(vault write -field=id -format=json identity/lookup/entity \
    alias_name='carldoe@contoso.com' \
    alias_mount_accessor="${ACCESSOR_ID}" | jq -r '.')"

if [[ -z "${ENTITY_ID}" ]]; then

ENTITY_ID="$(vault write -field=id identity/entity \
    name='carl' \
    policies='oidc-admin' \
    metadata=scope=hacker \
    metadata=responsibility='system takeover')"

echo "Entity ID: ${ENTITY_ID}"

ALIAS_ID="$(vault write -field=id identity/entity-alias \
    name='carldoe@contoso.com' \
    canonical_id="${ENTITY_ID}" \
    mount_accessor="${ACCESSOR_ID}")"

echo "Entity Alias ID: ${ALIAS_ID}"

else

vault write identity/entity/id/"${ENTITY_ID}" \
    policies='oidc-admin'

fi

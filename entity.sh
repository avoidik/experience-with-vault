#!/usr/bin/env bash

for id in $(vault list -format=json identity/group/id | jq -r '.[]' ); do
  vault delete identity/group/id/"${id}"
done

for id in $(vault list -format=json identity/entity/id | jq -r '.[]' ); do
  vault delete identity/entity/id/"${id}"
done

ACCESSOR_ID="$(vault auth list -format=json | jq -r '.["oidc/"].accessor')"

echo "Accessor ID: ${ACCESSOR_ID}"

#
# add groups
#

echo
echo "Add developers group with oidc-reader"
echo

GROUP_ID="$(vault write -field=id identity/group \
    name='oidc-reader' \
    type='external' \
    policies='oidc-reader' \
    metadata=scope=dev \
    metadata=responsibility='read secrets')"

echo "Group ID: ${GROUP_ID}"

ALIAS_ID="$(vault write -field=id identity/group-alias \
    name='developers' \
    mount_accessor="${ACCESSOR_ID}" \
    canonical_id="${GROUP_ID}")"

echo "Group Alias ID: ${ALIAS_ID}"

echo
echo "Add admins group with oidc-admin"
echo

GROUP_ID="$(vault write -field=id identity/group \
    name='oidc-admin' \
    type='external' \
    policies='oidc-admin' \
    metadata=scope=mgmt \
    metadata=responsibility='manage cluster')"

echo "Group ID: ${GROUP_ID}"

ALIAS_ID="$(vault write -field=id identity/group-alias \
    name='admins' \
    mount_accessor="${ACCESSOR_ID}" \
    canonical_id="${GROUP_ID}")"

echo "Group Alias ID: ${ALIAS_ID}"

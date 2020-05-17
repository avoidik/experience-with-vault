#!/usr/bin/env bash

vault auth disable ldap
vault auth enable ldap

vault write auth/ldap/config \
    url=ldaps://openldap \
    certificate=@tls/ca.pem \
    binddn='cn=readonly,dc=contoso,dc=com' \
    bindpass='readonly' \
    insecure_tls=false \
    starttls=true \
    userdn='ou=People,dc=contoso,dc=com' \
    userattr='cn' \
    groupfilter='(|(member={{.UserDN}})(uniqueMember={{.UserDN}}))' \
    groupdn='ou=Groups,dc=contoso,dc=com' \
    groupattr='cn'

vault write auth/ldap/groups/admins policies=oidc-admin

vault write auth/ldap/groups/developers policies=oidc-reader

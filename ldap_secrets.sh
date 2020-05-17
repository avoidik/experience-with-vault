#!/usr/bin/env bash

vault secrets disable openldap
vault secrets enable openldap

vault write openldap/config \
    binddn='cn=vault,dc=contoso,dc=com' \
    bindpass='vault' \
    url=ldaps://openldap \
    certificate=@tls/ca.pem

vault write -f openldap/rotate-root

vault write openldap/static-role/carl \
    username='carl' \
    dn='cn=carl,ou=People,dc=contoso,dc=com' \
    rotation_period='30m'

vault write -f openldap/rotate-role/carl

vault read openldap/static-cred/carl

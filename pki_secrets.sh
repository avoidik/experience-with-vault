#!/usr/bin/env bash

vault secrets disable pki
vault secrets enable pki

cat tls/ca-int-signed.pem tls/ca-int-key.pem tls/ca.pem > tls/ca-int-bundle.pem

vault write pki/config/ca \
    pem_bundle=@tls/ca-int-bundle.pem

vault write pki/roles/oidc-reader \
    server_flag=false \
    client_flag=true \
    allow_any_name=true \
    country='Latvia' \
    province='Latvia' \
    locality='Riga' \
    organization='Home' \
    ou='DevOps' \
    basic_constraints_valid_for_non_ca=true

CERT_DATA="$(vault write -format=json pki/issue/oidc-reader\
    common_name=blah)"

jq -r '.data.certificate' <<< "${CERT_DATA}" > tls/test.pem
jq -r '.data.private_key' <<< "${CERT_DATA}" > tls/test-key.pem

vault login \
    -method=cert \
    -ca-cert=tls/ca.pem \
    -client-cert=tls/test.pem \
    -client-key=tls/test-key.pem \
    name=oidc-reader

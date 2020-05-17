#!/usr/bin/env bash

vault auth disable cert
vault auth enable cert

vault write auth/cert/certs/oidc-reader \
    policies=oidc-reader \
    certificate=@tls/ca-int-signed.pem \
    allowed_organizational_units='DevOps' \
    token_period=168h \
    token_explicit_max_ttl=0

vault login \
    -method=cert \
    -ca-cert=tls/ca.pem \
    -client-cert=tls/auth.pem \
    -client-key=tls/auth-key.pem \
    name=oidc-reader

#!/usr/bin/env bash

eval "$(docker-machine env dex)"

vault write auth/cert/certs/concourse-ci \
    policies=concourse-read-only \
    certificate=@tls/ca-int-signed.pem \
    token_period='1h' \
    token_explicit_max_ttl='1h'

vault login \
    -method=cert \
    -ca-cert=tls/ca.pem \
    -client-cert=tls/auth.pem \
    -client-key=tls/auth-key.pem \
    name=concourse-ci

docker-compose -f docker-compose.yaml -f docker-compose.ci.yaml up -d --build

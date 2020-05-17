#!/usr/bin/env bash

MACHINE_IP="$(docker-machine ip dex)"

curl -s --cacert tls/ca.pem "https://${MACHINE_IP}:5556/dex/.well-known/openid-configuration" | jq -r '.'

curl -s --cacert tls/ca.pem "https://${MACHINE_IP}:5556/dex/keys" | jq -r '.'

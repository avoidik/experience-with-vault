#!/usr/bin/env bash

MACHINE_IP="$(docker-machine ip dex)"

cfssl gencert \
  -ca=tls/ca.pem \
  -ca-key=tls/ca-key.pem \
  -config=tls/ca-config.json \
  -profile=default \
  -hostname="${MACHINE_IP},$(jq -r '.hosts | join(",")' tls/test-csr.json)" \
  tls/test-csr.json | cfssljson -bare tls/test

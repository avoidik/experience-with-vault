#!/usr/bin/env bash

MACHINE_IP="$(docker-machine ip dex)"

#
# CA
#
if [ ! -f tls/ca-key.pem ]; then
cfssl gencert -initca tls/ca-csr.json | cfssljson -bare tls/ca
fi

#
# Subordinate CA
#
if [ ! -f tls/ca-int-key.pem ]; then
cfssl gencert -initca tls/ca-int-csr.json | cfssljson -bare tls/ca-int
fi

#
# Sign sub-CA
#
if [ ! -f tls/ca-int-signed.pem ]; then
cfssl sign \
  -ca=tls/ca.pem \
  -ca-key=tls/ca-key.pem \
  -config=tls/ca-config.json \
  -profile=intermediate \
  tls/ca-int.csr | cfssljson -bare tls/ca-int-signed
fi

#
# dex
#
if [ ! -f tls/dex-key.pem ]; then
cfssl gencert \
  -ca=tls/ca.pem \
  -ca-key=tls/ca-key.pem \
  -config=tls/ca-config.json \
  -profile=default \
  -hostname="${MACHINE_IP},$(jq -r '.hosts | join(",")' tls/dex-csr.json)" \
  tls/dex-csr.json | cfssljson -bare tls/dex
fi

#
# ldap
#
if [ ! -f tls/ldap-key.pem ]; then
cfssl gencert \
  -ca=tls/ca.pem \
  -ca-key=tls/ca-key.pem \
  -config=tls/ca-config.json \
  -profile=default \
  -hostname="${MACHINE_IP},$(jq -r '.hosts | join(",")' tls/ldap-csr.json)" \
  tls/ldap-csr.json | cfssljson -bare tls/ldap
fi

#
# ldapadmin
#
if [ ! -f tls/ldapadmin-key.pem ]; then
cfssl gencert \
  -ca=tls/ca.pem \
  -ca-key=tls/ca-key.pem \
  -config=tls/ca-config.json \
  -profile=default \
  -hostname="${MACHINE_IP},$(jq -r '.hosts | join(",")' tls/ldapadmin-csr.json)" \
  tls/ldapadmin-csr.json | cfssljson -bare tls/ldapadmin
fi

#
# consul
#
if [ ! -f tls/consul-key.pem ]; then
cfssl gencert \
  -ca=tls/ca.pem \
  -ca-key=tls/ca-key.pem \
  -config=tls/ca-config.json \
  -profile=default \
  -hostname="${MACHINE_IP},$(jq -r '.hosts | join(",")' tls/consul-csr.json)" \
  tls/consul-csr.json | cfssljson -bare tls/consul
fi

#
# consul client
#
if [ ! -f tls/consul-client-key.pem ]; then
cfssl gencert \
  -ca=tls/ca.pem \
  -ca-key=tls/ca-key.pem \
  -config=tls/ca-config.json \
  -profile=client \
  -hostname="${MACHINE_IP},$(jq -r '.hosts | join(",")' tls/consul-client-csr.json)" \
  tls/consul-client-csr.json | cfssljson -bare tls/consul-client
fi

#
# vault
#
if [ ! -f tls/vault-key.pem ]; then
cfssl gencert \
  -ca=tls/ca.pem \
  -ca-key=tls/ca-key.pem \
  -config=tls/ca-config.json \
  -profile=default \
  -hostname="${MACHINE_IP},$(jq -r '.hosts | join(",")' tls/vault-csr.json)" \
  tls/vault-csr.json | cfssljson -bare tls/vault
fi

#
# ci
#
if [ ! -f tls/ci-key.pem ]; then
cfssl gencert \
  -ca=tls/ca.pem \
  -ca-key=tls/ca-key.pem \
  -config=tls/ca-config.json \
  -profile=default \
  -hostname="${MACHINE_IP},$(jq -r '.hosts | join(",")' tls/ci-csr.json)" \
  tls/ci-csr.json | cfssljson -bare tls/ci
fi

#
# pki auth
#
if [ ! -f tls/auth-key.pem ]; then
cfssl gencert \
  -ca=tls/ca-int-signed.pem \
  -ca-key=tls/ca-int-key.pem \
  -config=tls/ca-config.json \
  -profile=client \
  tls/auth-csr.json | cfssljson -bare tls/auth
fi

#
# consul container
#
cp tls/consul.pem consul/tls/consul.pem
cp tls/consul-key.pem consul/tls/consul-key.pem
cp tls/ca.pem consul/tls/ca.pem

#
# vault consul container - consul client part
#
cp tls/ca.pem vault/tls-consul/ca.pem
cp tls/consul-client.pem vault/tls-consul/consul-client.pem
cp tls/consul-client-key.pem vault/tls-consul/consul-client-key.pem

#
# vault consul container - vault part
#
cat tls/vault.pem tls/ca.pem > tls/vault-combined.pem
cp tls/vault-combined.pem vault/tls-vault/vault-combined.pem
cp tls/vault-key.pem vault/tls-vault/vault-key.pem

#
# dex container
#
cat tls/dex.pem tls/ca.pem > tls/dex-combined.pem
cp tls/ca.pem dexidp/tls/ca.pem
cp tls/dex-combined.pem dexidp/tls/dex-combined.pem
cp tls/dex-key.pem dexidp/tls/dex-key.pem

#
# ldap container
#
cp tls/ldap.pem ldap/tls/ldap.pem
cp tls/ldap-key.pem ldap/tls/ldap-key.pem
cp tls/ca.pem ldap/tls/ca.pem

#
# ldapadmin container
#
cp tls/ldapadmin.pem ldapadmin/tls/ldapadmin.pem
cp tls/ldapadmin-key.pem ldapadmin/tls/ldapadmin-key.pem
cp tls/ca.pem ldapadmin/tls/ca.pem

#
# ldapssp container
#
cp tls/ca.pem ldapssp/tls/ca.pem

#
# ci
#
cat tls/ci.pem tls/ca.pem > tls/ci-combined.pem
cp tls/ci-key.pem ci/tls/ci-key.pem
cp tls/ci-combined.pem ci/tls/ci-combined.pem
cp tls/ca.pem ci/tls/ca.pem
cp tls/auth.pem ci/tls/auth.pem
cp tls/auth-key.pem ci/tls/auth-key.pem

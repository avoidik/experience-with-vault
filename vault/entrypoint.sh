#!/usr/bin/dumb-init /bin/sh

echo
echo "Starting Consul client"
echo
/usr/local/bin/consul-entrypoint.sh agent &

echo
echo "Starting Vault"
echo
/usr/local/bin/vault-entrypoint.sh server

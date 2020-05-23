#!/usr/bin/env bash

vault secrets disable secret
vault secrets enable -version=1 -path=secret kv

vault secrets disable concourse
vault secrets enable -version=1 -path=concourse kv

vault kv put secret/team username=carl password=baz
vault kv put secret/sensitive username=jane password=foo

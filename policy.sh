#!/usr/bin/env bash

vault policy write oidc-admin -<<'EOF'
path "*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
EOF

vault policy write oidc-reader -<<'EOF'
path "secret" {
  capabilities = ["list"]
}

path "secret/team" {
  capabilities = ["read", "list"]
}

path "secret/team/*" {
  capabilities = ["read", "list"]
}
EOF

vault policy write concourse-read-only -<<'EOF'
path "concourse/*" {
  capabilities = ["read"]
}
EOF

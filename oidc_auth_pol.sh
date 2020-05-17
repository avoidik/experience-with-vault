#!/usr/bin/env bash

MACHINE_IP="$(docker-machine ip dex)"

vault auth disable oidc
vault auth enable oidc

vault write auth/oidc/config \
    bound_issuer="https://${MACHINE_IP}:5556/dex" \
    oidc_discovery_url="https://${MACHINE_IP}:5556/dex" \
    oidc_discovery_ca_pem=@tls/ca.pem \
    oidc_client_id='vault' \
    oidc_client_secret='vault' \
    default_role='oidc-reader'

vault write auth/oidc/role/oidc-admin -<<EOF
{
    "role_type": "oidc",
    "bound_audiences": "vault",
    "user_claim": "name",
    "bound_claims": {
        "groups": ["admins"]
    },
    "groups_claim": "groups",
    "allowed_redirect_uris": [
        "https://${MACHINE_IP}:8200/ui/vault/auth/oidc/oidc/callback",
        "http://localhost:8250/oidc/callback"
    ],
    "claim_mappings": {
        "name": "name",
        "email": "email",
        "/groups/0": "group_0",
        "/groups/1": "group_1",
        "/groups/2": "group_2",
        "/groups/3": "group_3",
        "/groups/4": "group_4"
    },
    "oidc_scopes": ["email", "profile", "groups"],
    "token_ttl": "1h",
    "token_policies": ["oidc-admin"],
    "token_explicit_max_ttl": "0",
    "token_period": "168h",
    "token_type": "service"
}
EOF

vault write auth/oidc/role/oidc-reader -<<EOF
{
    "role_type": "oidc",
    "bound_audiences": "vault",
    "user_claim": "name",
    "bound_claims": {
        "groups": ["developers"]
    },
    "groups_claim": "groups",
    "allowed_redirect_uris": [
        "https://${MACHINE_IP}:8200/ui/vault/auth/oidc/oidc/callback",
        "http://localhost:8250/oidc/callback"
    ],
    "claim_mappings": {
        "name": "name",
        "email": "email",
        "/groups/0": "group_0",
        "/groups/1": "group_1",
        "/groups/2": "group_2",
        "/groups/3": "group_3",
        "/groups/4": "group_4"
    },
    "oidc_scopes": ["email", "profile", "groups"],
    "token_ttl": "1h",
    "token_policies": ["oidc-reader"],
    "token_explicit_max_ttl": "0",
    "token_period": "168h",
    "token_type": "service"
}
EOF
#!/usr/bin/env bash

vault secrets disable database
vault secrets enable database

cat << 'EOF' > ./readonly.sql
CREATE ROLE "{{name}}" WITH LOGIN ENCRYPTED PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO "{{name}}";
EOF

vault write database/config/postgresql \
    plugin_name=postgresql-database-plugin \
    allowed_roles='readonly,education' \
    connection_url='postgresql://{{username}}:{{password}}@postgres:5432/postgres?sslmode=disable' \
    username='power' \
    password='power'

vault write -f database/rotate-root/postgresql

vault write database/roles/readonly \
    db_name=postgresql \
    creation_statements=@readonly.sql \
    default_ttl=1h \
    max_ttl=24h

rm -f ./readonly.sql

vault read database/creds/readonly

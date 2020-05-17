#!/usr/bin/env bash

cat << 'EOF' > ./rotation.sql
ALTER USER "{{name}}" WITH ENCRYPTED PASSWORD '{{password}}';
EOF

vault write database/static-roles/education \
    db_name=postgresql \
    rotation_statements=@rotation.sql \
    username='vault-edu' \
    rotation_period='30m'

rm -f ./rotation.sql

vault write -f database/rotate-role/education

vault read database/static-creds/education

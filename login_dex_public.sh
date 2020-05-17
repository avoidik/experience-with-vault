#!/usr/bin/env bash

MACHINE_IP="$(docker-machine ip dex)"

# admins, developers
# janedoe@contoso.com
# foo
#
# admin
# johndoe@contoso.com
# bar
#
# developers
# carldoe@contoso.com
# baz

curl -s --cacert tls/ca.pem \
-H 'Cache-Control: no-cache' \
-H 'Content-Type: application/x-www-form-urlencoded' \
-d 'grant_type=password' \
-d 'username=janedoe%40contoso.com' \
-d 'password=foo' \
-d 'scope=email%20profile%20openid%20groups%20offline_access' \
-d 'client_id=vault' \
-X POST "https://${MACHINE_IP}:5556/dex/token" | \
jq -r '.id_token' | cut -d '.' -f 2 | base64 -di

#!/usr/bin/env bash

rm -f tls/*.pem
rm -f tls/*.csr

rm -f consul/tls/*.pem
rm -f vault/tls-vault/*.pem
rm -f vault/tls-consul/*.pem
rm -f dexidp/tls/*.pem
rm -f ldap/tls/*.pem
rm -f ldapadmin/tls/*.pem
rm -f ldapssp/tls/*.pem
rm -f ci/tls/*.pem
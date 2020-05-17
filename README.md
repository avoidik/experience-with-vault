# Experiments with Vault

## Prerequisites

* installed VirtualBox
* docker & docker-machine binaries
* cfssl & cfssljson binaries
* vault & consul binaries
* curl

## What is this

An ideal playground to play with HashiCorp Vault authenticaion methods, secrets backend, etc.

The following advanced topics covered in this repo:

* Docker-Machine & Docker-Containers - how to build and run them
* TLS - how to generate certificates with cfssl and Vault itself, configure TLS communication between components
* Vault Server, Consul Client, Consul Server, OpenLDAP (with phpLDAPadmin & self-service portal), DEX (with static-client & OpenLDAP) configuration
* OIDC (authenticaion) - using OpenLDAP as a central users directory, roundtrip authentication with OpenLDAP credentials over OIDC
* Identity (both Groups & Entities) - map LDAP groups to Vault identity backend
* LDAP (both authenticaion & secrets) - rotate OpenLDAP secrets and authenticate
* PKI (both authenticaion & secrets) - configure PKI and use it for authentication purposes
* DB (secrets) - rotate database secrets
* KV (secrets) - static secrets

## How to run

1. `docker-machine create dex` - create test vm
1. `./ca.sh` - generate all required TLS certificates
1. `./prep.sh` - prepare all required docker images (build)
1. `./run.sh` - run test stack on top of test vm
1. `source ./vault.env` - inject required environment variables (without token)
1. `./init.sh` - initialize vault
1. `./unseal.sh` - unseal vault
1. `source ./vault.env` - inject required environment variables (with token)
1. `./policy.sh` - write policies
1. `./oidc_auth.sh` - configure OIDC authenticaion
1. `./entity.sh` - configure identity groups
1. `./ldap_auth.sh` - configure LDAP authenticaion
1. `./ldap_secrets.sh` - configure LDAP secrets (take a look on dynamically generated carl credentials)
1. `./kv.sh` - configure KV secrets

## How to interact with DEX

1. `./dex.sh` - view DEX configuration
1. `./login_dex.sh` - retrieve JWT token from DEX
1. `./login_dex_public.sh` - retrive JWT token from DEX (if Public Client configured)

## How to test OIDC and LDAP

1. `source ./vault.env` - inject required environment variables
1. `vault login -method=oidc role=oidc-reader` - login with OIDC (and LDAP as identities directory)
1. `vault login -method=ldap username=carl` - login with LDAP (by using carl's dynamically generated credentials)

## How to test Postgres

1. `./postgres_secrets.sh` - configure database secrets (Postgres)
1. `./postgres_roles.sh` - configure database roles (Postgres)

## How to tesk PKI

1. `./pki_auth.sh` - configure PKI authenticaion & login with cfssl generate certificate
1. `./pki_secrets.sh` - configure PKI secrets, generate TLS authenticaion certificate, and login with it (login with Vault generated PKI certificate into Vault)

## How to elevate identity entity

1. `./carl.sh` - an example on how to elevate someone having access to identity
1. `./uncarl.sh` - take elevated privileges back

## How to read from Consul

1. `source ./consul.env` - inject required environment variables
1. `consul kv get -keys -recurse vault/core/` - list consul keys
1. `consul kv get vault/core/lock` - read consul key

## How to stop

1. `./stop.sh` - stop test stack
1. `./unca.sh` - remove all TLS certificates
1. `docker-machine rm -f dex` - destroy vm

## Credits

Found something interesting and want to reuse it in your own project? Please give proper credits to HashiCorp, Docker-Containers maintainers, OSS authors, and **Viacheslav** :-)

- [HashiCorp](https://www.hashicorp.com/) ([Consul](https://www.consul.io/) & [Vault](https://www.vaultproject.io/)), respective [Vault Docker Container](https://hub.docker.com/_/vault) and [Consul Docker Container](https://hub.docker.com/_/consul)
- [DEX](https://github.com/dexidp/dex) and respective [Docker Container](https://quay.io/repository/dexidp/dex)
- [LDAP Self-Service Portal](https://ltb-project.org/documentation/self-service-password) and respective [Docker Container](https://hub.docker.com/r/tiredofit/self-service-password)
- [phpLDAPadmin](http://phpldapadmin.sourceforge.net/wiki/index.php/Main_Page) and respective [Docker Container](https://hub.docker.com/r/osixia/phpmyadmin)
- [OpenLDAP](https://www.openldap.org/) and respective [Docker Container](https://hub.docker.com/r/osixia/openldap)
- [PostgreSQL](https://www.postgresql.org/) and respective [Docker Container](https://hub.docker.com/_/postgres)
- [CFSSL](https://github.com/cloudflare/cfssl)

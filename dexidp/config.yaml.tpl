issuer: https://___MACHINE_IP___:5556/dex

storage:
  type: postgres
  config:
    host: postgres
    port: 5432
    user: dex
    password: dex
    database: dex
    maxOpenConns: 5
    maxIdleConns: 3
    connMaxLifetime: 30
    connectionTimeout: 3
    ssl:
      mode: disable

web:
  https: 0.0.0.0:5556
  tlsCert: /etc/dex/tls/dex-combined.pem
  tlsKey: /etc/dex/tls/dex-key.pem

frontend:
  theme: "coreos"
  issuer: "Local DEX"

oauth2:
  responseTypes: ["code", "token", "id_token"]
  skipApprovalScreen: false
  alwaysShowLoginScreen: true
  passwordConnector: ldap

enablePasswordDB: true

staticPasswords:
- email: "power@contoso.com"
  hash: "$2b$12$asWZnUQO.Vvc2MzhNmde.OORMya52NfgnJBqTd2PFkmCamJfH6elS"
  username: "power"
  userID: "25bb357d-3035-4ac6-bbae-60638afa8a00"

staticClients:
- name: 'Vault OIDC Authentication'
  id: vault
  secret: vault
  #public: true
  redirectURIs:
  - 'https://___MACHINE_IP___:8200/ui/vault/auth/oidc/oidc/callback'
  - 'http://localhost:8250/oidc/callback'

expiry:
  signingKeys: "7h"
  idTokens: "25h"
  authRequests: "25h"

connectors:
- type: ldap
  name: OpenLDAP
  id: ldap
  config:
    host: openldap:636
    rootCA: /etc/dex/tls/ca.pem
    bindDN: cn=readonly,dc=contoso,dc=com
    bindPW: readonly
    usernamePrompt: Email Address
    userSearch:
      baseDN: ou=People,dc=contoso,dc=com
      filter: "(objectClass=person)"
      username: mail
      idAttr: DN
      emailAttr: mail
      nameAttr: cn
    groupSearch:
      baseDN: ou=Groups,dc=contoso,dc=com
      filter: "(objectClass=groupOfUniqueNames)"
      userMatchers:
      - userAttr: DN
        groupAttr: uniqueMember
      nameAttr: cn

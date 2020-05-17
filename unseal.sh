#!/usr/bin/env bash

vault operator unseal "$(jq -r '.unseal_keys_hex[0] // empty' init.json 2> /dev/null)"
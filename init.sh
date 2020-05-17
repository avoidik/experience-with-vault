#!/usr/bin/env bash

if [[ -f init.json ]]; then
  exit 1
fi

vault operator init -key-shares=1 -key-threshold=1 -format=json > init.json

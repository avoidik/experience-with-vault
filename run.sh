#!/usr/bin/env bash

eval "$(docker-machine env dex)"

docker-compose up -d
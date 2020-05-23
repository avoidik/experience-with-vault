#!/usr/bin/env bash

eval "$(docker-machine env dex)"

docker-compose -f docker-compose.yaml -f docker-compose.ci.yaml rm -fsv

rm -f ./init.json
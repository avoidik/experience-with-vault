#!/usr/bin/env bash

eval "$(docker-machine env dex)"

docker-compose rm -fsv

rm -f ./init.json
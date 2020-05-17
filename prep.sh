#!/usr/bin/env bash

eval "$(docker-machine env dex)"

MACHINE_IP="$(docker-machine ip dex)"

sed "s/___MACHINE_IP___/${MACHINE_IP}/g" dexidp/config.yaml.tpl > dexidp/config.yaml

docker-compose pull
docker-compose build --no-cache --parallel

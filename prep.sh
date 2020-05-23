#!/usr/bin/env bash

eval "$(docker-machine env dex)"

MACHINE_IP="$(docker-machine ip dex)"

echo "ENV_CONCOURSE_URL=https://${MACHINE_IP}:8081" | tee ./.env
echo "ENV_ISSUER_URL=https://${MACHINE_IP}:5556/dex" | tee -a ./.env
echo "ENV_MACHINE_IP=${MACHINE_IP}" | tee -a ./.env

docker-compose pull
docker-compose -f docker-compose.yaml -f docker-compose.ci.yaml build --no-cache

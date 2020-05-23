#!/usr/bin/env bash

# rbac & rest api documentation :)
# https://github.com/concourse/concourse/blob/master/atc/routes.go

CONCOURSE_URL="https://$(docker-machine ip dex):8081"

#
# prepare secrets
#
vault kv put concourse/demo-team/my-pipeline/credentials username=super password=sensitive

# login and create team
fly --target demo login --concourse-url "${CONCOURSE_URL}" --open-browser --ca-cert tls/ca.pem
fly --target demo userinfo
fly --target demo set-team --team-name demo-team --config team.yml --non-interactive
fly --target demo active-users
fly --target demo teams -d

# login to that team
fly --target demo login -n demo-team --open-browser

# upload pipeline and unpause it
fly validate-pipeline --config pipeline.yml
fly --target demo set-pipeline --pipeline my-pipeline --config pipeline.yml --non-interactive --check-creds
fly --target demo pipelines --print-table-headers
fly --target demo unpause-pipeline --pipeline my-pipeline

# start the job
fly --target demo jobs --pipeline my-pipeline --print-table-headers
fly --target demo unpause-job --job my-pipeline/first-step
fly --target demo trigger-job --job my-pipeline/first-step --watch

# step into the container
fly --target demo builds --print-table-headers
fly --target demo execute --config pipeline.task.yml -l pipeline.task.vars.yml
fly --target demo intercept --job my-pipeline/first-step sh

# clean up
fly --target demo destroy-pipeline --pipeline my-pipeline --non-interactive
fly --target demo destroy-team --team-name demo-team --non-interactive
fly --target demo logout
fly --target demo delete-target

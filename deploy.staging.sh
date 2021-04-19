#!/bin/sh

ssh -o StrictHostKeyChecking=no -i $PRIVATE_KEY $SERVER_USER@$SERVER_IP << 'ENDSSH'
  mkdir -p ~/msdata/staging/notification/front/mediafiles
  mkdir -p ~/msdata/staging/notification/front/staticfiles
  mkdir -p ~/msdata/staging/notification/rapi/mediafiles
  mkdir -p ~/msdata/staging/notification/rapi/staticfiles
  mkdir -p ~/notification/staging/
  cd ~/notification/staging/
  export $(cat gitlab.staging.env | xargs)
  # export $(grep -v '^#' staging.env | xargs -d '\n')
  docker login -u $CI_REGISTRY_USER -p $CI_JOB_TOKEN $CI_REGISTRY
  docker-compose -f docker-compose.staging.yml --env-file=staging.env pull
  docker-compose -f docker-compose.staging.yml --env-file=staging.env config
  docker-compose -f docker-compose.staging.yml --env-file=staging.env up -d --force-recreate
  docker ps
  docker images -f dangling=true
  docker image prune -f
  # docker images
ENDSSH

## Test ssh script
# ssh -o StrictHostKeyChecking=no -p 29 parth@86.21.69.140 << 'ENDSSH'
#   cd ~/docker/django/
#   ls -l
# ENDSSH

#!/bin/bash

docker context use default
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 135135176603.dkr.ecr.ap-south-1.amazonaws.com

docker-compose \
  -f infra/docker-compose.base.yml \
  -f infra/docker-compose.build.yml \
  -f infra/docker-compose.tags.yml \
  --project-name tokenization-platform \
  --project-directory ./ \
  build

docker push 135135176603.dkr.ecr.ap-south-1.amazonaws.com/tokenization-platform-frontend:latest
docker push 135135176603.dkr.ecr.ap-south-1.amazonaws.com/tokenization-platform-backend:latest
docker push 135135176603.dkr.ecr.ap-south-1.amazonaws.com/tokenization-platform-redis:latest

docker context use yodaplus

cp .env ./infra/.env

docker compose \
  -f infra/docker-compose.base.yml \
  -f infra/docker-compose.tags.yml \
  -f infra/docker-compose.ecs.yml \
  --project-name tokenization-platform \
  --project-directory ./ \
  up

rm ./infra/.env

docker context use default

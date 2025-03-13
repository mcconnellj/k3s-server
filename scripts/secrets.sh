#!/bin/bash

echo -n "<json_value>" > registry_key.json

k create secret docker-registry artifact-read \
    --docker-server=us-east1-docker.pkg.dev \
    --docker-username=_json_key \
    --docker-password="$(cat registry_key.json)" \
    --docker-email=valid-email@example.com

#deoloy
# deploy the app
k apply -f httpbin.yaml

# Ensure the app is running
k get po -w

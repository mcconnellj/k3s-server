#!/bin/bash

# OpenTofu setup
tofu init -get=true -upgrade
tofu workspace new dev
tofu workspace select dev

# Plan (to preview what will be changed)
tofu plan

# Apply (to create the infrastructure described in the IaC code)
tofu apply

#Build the app
FROM python:3.12-slim

# Install dependencies
RUN pip install --no-cache-dir gunicorn httpbin

# Expose the application port
EXPOSE 80

# Launch the application
CMD ["gunicorn", "-b", "0.0.0.0:80", "httpbin:app"]

#build and push to artifact registry
# Build
docker build -t httpbin .

# Push to the registry
gcloud auth configure-docker us-east1-docker.pkg.dev
docker tag httpbin us-east1-docker.pkg.dev/<my-project>/app-repo/httpbin:v1
docker push us-east1-docker.pkg.dev/<my-project>/app-repo/httpbin:v1
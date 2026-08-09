#!/bin/bash

set -e

IMAGE_NAME="devops-build-web"
TAG="${1:-dev}"
CONTAINER_NAME="devops-app"

echo "====================================="
echo "Deploying Application"
echo "Image: ${IMAGE_NAME}:${TAG}"
echo "Container: ${CONTAINER_NAME}"
echo "Port: 80"
echo "====================================="

echo "Stopping existing container..."

docker rm -f "${CONTAINER_NAME}" 2>/dev/null || true

echo "Starting new container..."

docker run -d \
  --name "${CONTAINER_NAME}" \
  --restart always \
  -p 80:80 \
  "${IMAGE_NAME}:${TAG}"

echo "====================================="
echo "Deployment successful!"
echo "====================================="

docker ps --filter "name=${CONTAINER_NAME}"

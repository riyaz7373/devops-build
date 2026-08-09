#!/bin/bash

set -e

IMAGE_NAME="devops-build-web"
TAG="${1:-dev}"

echo "====================================="
echo "Building Docker Image"
echo "Image: ${IMAGE_NAME}:${TAG}"
echo "====================================="

docker build -t "${IMAGE_NAME}:${TAG}" .

echo "====================================="
echo "Docker image built successfully!"
echo "Image: ${IMAGE_NAME}:${TAG}"
echo "====================================="

docker images "${IMAGE_NAME}"

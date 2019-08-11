#!/bin/bash
set -e

cd "$(dirname $0)"

DOCKER_CONTAINER="test_amd64-unknown-linux-gnu"

docker login --username "$DOCKER_USERNAME"
buildah push "$DOCKER_CONTAINER:latest" "docker://docker.io/$DOCKER_USERNAME/$DOCKER_CONTAINER:latest"

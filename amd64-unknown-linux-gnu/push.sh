#!/bin/bash
set -e

cd "$(dirname $0)"

source "../env.sh"

DOCKER_CONTAINER="${DOCKER_CONTAINER_PREFIX}_amd64-unknown-linux-gnu"

docker login --username "$DOCKER_USERNAME"
buildah push "$DOCKER_CONTAINER:latest" "docker://docker.io/$DOCKER_USERNAME/$DOCKER_CONTAINER:latest"

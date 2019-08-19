#!/bin/bash
set -e

cd "$(dirname $0)"

source "../env.sh"

DOCKER_IMAGE="${DOCKER_IMAGE_PREFIX}_aarch64-unknown-linux-gnu"

docker login --username "$DOCKER_USERNAME"

LOCAL_IMAGE="$DOCKER_IMAGE:latest"
REMOTE_IMAGE="docker://docker.io/$DOCKER_USERNAME/$DOCKER_IMAGE:latest"

buildah push "$LOCAL_IMAGE" "$REMOTE_IMAGE"

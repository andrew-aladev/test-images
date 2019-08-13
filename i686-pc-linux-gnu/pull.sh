#!/bin/bash
set -e

cd "$(dirname $0)"

source "../env.sh"

DOCKER_IMAGE="${DOCKER_IMAGE_PREFIX}_i686-pc-linux-gnu"

LOCAL_IMAGE="$DOCKER_IMAGE:latest"
REMOTE_IMAGE="docker://docker.io/$DOCKER_USERNAME/$DOCKER_IMAGE:latest"

buildah pull "$REMOTE_IMAGE"
buildah tag "$REMOTE_IMAGE" "$LOCAL_IMAGE"

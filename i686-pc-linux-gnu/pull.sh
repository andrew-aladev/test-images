#!/bin/bash
set -e

cd "$(dirname $0)"

source "../env.sh"

DOCKER_CONTAINER="${DOCKER_CONTAINER_PREFIX}_i686-pc-linux-gnu"

buildah pull "docker://docker.io/$DOCKER_USERNAME/$DOCKER_CONTAINER:latest"

#!/bin/bash
set -e

cd "$(dirname $0)"

source "../../env.sh"
source "../../utils.sh"

FROM_DOCKER_IMAGE="${DOCKER_IMAGE_PREFIX}_arm-unknown-linux-gnueabi_toolchain"
DOCKER_IMAGE="${DOCKER_IMAGE_PREFIX}_arm-unknown-linux-gnueabi_world"

CONTAINER=$(buildah from "$FROM_DOCKER_IMAGE:latest")
buildah config --label maintainer="$MAINTAINER" "$CONTAINER"

build emerge -ve @world

commit

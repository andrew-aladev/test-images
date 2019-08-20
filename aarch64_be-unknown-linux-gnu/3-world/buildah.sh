#!/bin/bash
set -e

cd "$(dirname $0)"

source "../../env.sh"
source "../../utils.sh"

FROM_DOCKER_IMAGE="${DOCKER_IMAGE_PREFIX}_aarch64_be-unknown-linux-gnu_toolchain"
DOCKER_IMAGE="${DOCKER_IMAGE_PREFIX}_aarch64_be-unknown-linux-gnu_world"

CONTAINER=$(buildah from "$FROM_DOCKER_IMAGE:latest")
buildah config --label maintainer="$MAINTAINER" "$CONTAINER"

build emerge -ve @world

commit

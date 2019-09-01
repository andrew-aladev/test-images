#!/bin/bash
set -e

cd "$(dirname $0)"

source "../../env.sh"
source "../../utils.sh"

FROM_DOCKER_IMAGE="${DOCKER_IMAGE_PREFIX}_arm-unknown-linux-gnueabi_world"
DOCKER_IMAGE="${DOCKER_IMAGE_PREFIX}_arm-unknown-linux-gnueabi"

CONTAINER=$(buildah from "$FROM_DOCKER_IMAGE:latest")
buildah config --label maintainer="$MAINTAINER" "$CONTAINER"

build emerge -v app-portage/gentoolkit
build emerge -v clang

build "update && upgrade && cleanup"

run rm -rf /etc/._cfg*
run eselect news read

commit

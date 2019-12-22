#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

source "../../../utils.sh"
source "./env.sh"

CONTAINER=$(buildah from "$FROM_DOCKER_IMAGE")
buildah config --label maintainer="$MAINTAINER" "$CONTAINER"

build emerge -v1 sys-devel/gcc
build emerge -v1 sys-devel/binutils
build emerge -v1 sys-libs/glibc

commit

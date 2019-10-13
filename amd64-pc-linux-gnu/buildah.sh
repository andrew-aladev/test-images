#!/bin/bash
set -e

cd "$(dirname $0)"

source "../env.sh"
source "../utils.sh"

DOCKER_IMAGE="${DOCKER_IMAGE_PREFIX}_amd64-pc-linux-gnu"

CONTAINER=$(buildah from "docker.io/gentoo/stage3-amd64-nomultilib:latest")
buildah config --label maintainer="$MAINTAINER" "$CONTAINER"

run rm -r /usr/share/{doc,man,info}
copy root/ /
run "env-update"

run emerge-webrsync

run eselect profile set default/linux/amd64/17.1/no-multilib
run "env-update && source /etc/profile"

build emerge -v1 sys-devel/gcc sys-devel/binutils sys-libs/glibc
build emerge -ve @world
build emerge -v app-portage/gentoolkit
build emerge -v clang

build "update && upgrade && cleanup"

run rm -rf /etc/._cfg*
run eselect news read

commit

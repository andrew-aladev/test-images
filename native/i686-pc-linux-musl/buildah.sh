#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

source "../../utils.sh"
source "./env.sh"

docker_pull "$FROM_IMAGE_NAME"

CONTAINER=$(buildah from "$FROM_IMAGE_NAME")
buildah config --label maintainer="$MAINTAINER" "$CONTAINER"

copy root/ /
run env-update

run emerge-webrsync

run ln -s /usr/portage/profiles/default/linux/x86/17.0/musl /etc/portage/make.profile
run eval "env-update && source /etc/profile"

build emerge -v1 sys-devel/gcc sys-devel/binutils sys-libs/musl sys-kernel/linux-headers
build emerge -ve @world \
  --exclude="sys-devel/gcc sys-devel/binutils sys-libs/musl sys-kernel/linux-headers"
build emerge -v app-portage/gentoolkit
build emerge -v clang

run update
build upgrade
run cleanup

run find /etc -maxdepth 1 -name ._cfg* -delete
run eselect news read

commit

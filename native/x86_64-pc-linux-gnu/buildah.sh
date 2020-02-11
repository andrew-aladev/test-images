#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

source "../../utils.sh"
source "./env.sh"

docker_pull "$FROM_IMAGE_NAME" "$FROM_DOCKER_USERNAME"
check_up_to_date

CONTAINER=$(buildah from "$FROM_IMAGE_NAME")
buildah config --label maintainer="$MAINTAINER" --arch="amd64" "$CONTAINER"

run eval "rm -r /usr/share/{doc,man,info}"

copy root/ /
run env-update

run emerge-webrsync

run eselect profile set default/linux/amd64/17.1/no-multilib
run eval "env-update && source /etc/profile"

build emerge -v1 sys-devel/gcc sys-devel/binutils sys-libs/glibc sys-kernel/linux-headers
build emerge -ve @world \
  --exclude="sys-devel/gcc sys-devel/binutils sys-libs/glibc sys-kernel/linux-headers"
build emerge -v app-portage/gentoolkit
build emerge -v clang

run update
build upgrade
run cleanup

run find /etc -maxdepth 1 -name ._cfg* -delete
run eselect news read

commit

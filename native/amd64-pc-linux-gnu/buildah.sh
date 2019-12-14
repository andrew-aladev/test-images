#!/bin/bash
set -e

cd "$(dirname $0)"

source "../../utils.sh"
source "./env.sh"

CONTAINER=$(buildah from "$FROM_IMAGE_NAME")
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

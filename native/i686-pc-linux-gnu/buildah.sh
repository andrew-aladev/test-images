#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

source "../../utils.sh"
source "./env.sh"

pull "$FROM_IMAGE_NAME" "$FROM_DOCKER_USERNAME"
check_up_to_date

CONTAINER=$(from "$FROM_IMAGE_NAME")
config --arch="x86"

run eval "rm -r /usr/share/{doc,man,info}"

copy root/ /
run env-update

run emerge-webrsync

run eselect profile set default/linux/x86/17.0
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

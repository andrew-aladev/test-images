#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

source "../../../utils.sh"
source "./env.sh"

docker_pull "$FROM_IMAGE_NAME"

CONTAINER=$(buildah from "$FROM_IMAGE_NAME")
buildah config --label maintainer="$MAINTAINER" "$CONTAINER"

build emerge -v sys-devel/crossdev
build crossdev -t "$TARGET" --stable

run rm "/usr/${TARGET}/etc/portage/make.profile"
run ln -s /usr/portage/profiles/default/linux/x86/17.0/musl "/usr/${TARGET}/etc/portage/make.profile"

build "${TARGET}-emerge" -v1 \
  sys-devel/gcc sys-devel/binutils sys-libs/musl sys-kernel/linux-headers

build "${TARGET}-emerge" -v1 \
  app-shells/bash app-arch/tar sys-devel/make sys-devel/patch \
  sys-apps/findutils sys-apps/grep sys-apps/gawk net-misc/wget

build "${TARGET}-emerge" -v1 sys-apps/portage

run rm "/usr/${TARGET}/etc/portage/make.profile"

commit

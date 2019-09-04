#!/bin/bash
set -e

cd "$(dirname $0)"

source "../../env.sh"
source "../../utils.sh"

FROM_DOCKER_IMAGE="${DOCKER_IMAGE_PREFIX}_amd64-pc-linux-gnu"
DOCKER_IMAGE="${DOCKER_IMAGE_PREFIX}_aarch64-unknown-linux-gnu_amd64-crossdev"

CONTAINER=$(buildah from "$FROM_DOCKER_IMAGE:latest")
buildah config --label maintainer="$MAINTAINER" "$CONTAINER"

copy root/ /

build emerge -v sys-devel/crossdev app-emulation/qemu
build crossdev -t aarch64-unknown-linux-gnu --stable

copy crossdev-root/ /usr/aarch64-unknown-linux-gnu/
run "cd /usr/aarch64-unknown-linux-gnu/usr/bin/ && \
  cp /usr/bin/qemu-aarch64 qemu-aarch64 && \
  ln -s qemu-aarch64 qemu-aarch64-static"

run rm /usr/aarch64-unknown-linux-gnu/etc/portage/make.profile
run ln -s /usr/portage/profiles/default/linux/arm64/17.0 /usr/aarch64-unknown-linux-gnu/etc/portage/make.profile

build aarch64-unknown-linux-gnu-emerge -v1 \
  sys-devel/gcc sys-devel/binutils sys-libs/glibc sys-kernel/linux-headers

build aarch64-unknown-linux-gnu-emerge -v1 \
  app-shells/bash app-arch/tar sys-devel/make sys-devel/patch \
  sys-apps/findutils sys-apps/grep sys-apps/gawk net-misc/wget

build aarch64-unknown-linux-gnu-emerge -v1 \
  sys-apps/portage

run rm /usr/aarch64-unknown-linux-gnu/etc/portage/make.profile
run rm -r /usr/aarch64-unknown-linux-gnu/etc/portage/patches

commit

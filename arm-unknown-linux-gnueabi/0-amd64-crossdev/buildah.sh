#!/bin/bash
set -e

cd "$(dirname $0)"

source "../../env.sh"
source "../../utils.sh"

FROM_DOCKER_IMAGE="${DOCKER_IMAGE_PREFIX}_amd64-pc-linux-gnu"
DOCKER_IMAGE="${DOCKER_IMAGE_PREFIX}_arm-unknown-linux-gnueabi_amd64-crossdev"

CONTAINER=$(buildah from "$FROM_DOCKER_IMAGE:latest")
buildah config --label maintainer="$MAINTAINER" "$CONTAINER"

copy root/ /

build emerge -v sys-devel/crossdev app-emulation/qemu
build crossdev -t arm-unknown-linux-gnueabi --stable

copy crossdev-root/ /usr/arm-unknown-linux-gnueabi/
run "cd /usr/arm-unknown-linux-gnueabi/usr/bin/ && \
  cp /usr/bin/qemu-arm qemu-arm && \
  ln -s qemu-arm qemu-arm-static"

run rm /usr/arm-unknown-linux-gnueabi/etc/portage/make.profile
run ln -s /usr/portage/profiles/default/linux/arm/17.0 /usr/arm-unknown-linux-gnueabi/etc/portage/make.profile

build arm-unknown-linux-gnueabi-emerge -v1 \
  sys-devel/gcc sys-devel/binutils sys-libs/glibc sys-kernel/linux-headers \
  sys-apps/portage app-shells/bash app-arch/tar sys-devel/make sys-devel/patch \
  sys-apps/findutils sys-apps/grep sys-apps/gawk net-misc/wget

run rm /usr/arm-unknown-linux-gnueabi/etc/portage/make.profile
run rm -r /usr/arm-unknown-linux-gnueabi/etc/portage/patches

commit

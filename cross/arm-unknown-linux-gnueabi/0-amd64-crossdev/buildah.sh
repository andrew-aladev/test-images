#!/bin/bash
set -e

cd "$(dirname $0)"

source "../../../utils.sh"
source "./env.sh"

CONTAINER=$(buildah from "$FROM_IMAGE_NAME")
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
  sys-devel/gcc sys-devel/binutils sys-libs/glibc sys-kernel/linux-headers

build arm-unknown-linux-gnueabi-emerge -v1 \
  app-shells/bash app-arch/tar sys-devel/make sys-devel/patch \
  sys-apps/findutils sys-apps/grep sys-apps/gawk net-misc/wget

build arm-unknown-linux-gnueabi-emerge -v1 \
  sys-apps/portage

run rm /usr/arm-unknown-linux-gnueabi/etc/portage/make.profile
run rm -r /usr/arm-unknown-linux-gnueabi/etc/portage/patches

commit

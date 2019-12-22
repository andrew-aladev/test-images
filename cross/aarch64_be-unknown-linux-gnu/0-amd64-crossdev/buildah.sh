#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

source "../../../utils.sh"
source "./env.sh"

CONTAINER=$(buildah from "$FROM_IMAGE_NAME")
buildah config --label maintainer="$MAINTAINER" "$CONTAINER"

copy root/ /

build emerge -v sys-devel/crossdev app-emulation/qemu
build crossdev -t aarch64_be-unknown-linux-gnu --stable

copy crossdev-root/ /usr/aarch64_be-unknown-linux-gnu/
run "cd /usr/aarch64_be-unknown-linux-gnu/usr/bin/ && \
  cp /usr/bin/qemu-aarch64_be qemu-aarch64_be && \
  ln -s qemu-aarch64_be qemu-aarch64_be-static"

run rm /usr/aarch64_be-unknown-linux-gnu/etc/portage/make.profile
run ln -s /usr/portage/profiles/default/linux/arm64/17.0/big-endian /usr/aarch64_be-unknown-linux-gnu/etc/portage/make.profile

build aarch64_be-unknown-linux-gnu-emerge -v1 \
  sys-devel/gcc sys-devel/binutils sys-libs/glibc sys-kernel/linux-headers

build aarch64_be-unknown-linux-gnu-emerge -v1 \
  app-shells/bash app-arch/tar sys-devel/make sys-devel/patch \
  sys-apps/findutils sys-apps/grep sys-apps/gawk net-misc/wget

build aarch64_be-unknown-linux-gnu-emerge -v1 \
  sys-apps/portage

run rm /usr/aarch64_be-unknown-linux-gnu/etc/portage/make.profile
run rm -r /usr/aarch64_be-unknown-linux-gnu/etc/portage/patches

commit

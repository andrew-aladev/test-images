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

copy crossdev-root/ "/usr/${TARGET}/"

run rm "/usr/${TARGET}/etc/portage/make.profile"
run ln -s /usr/portage/profiles/default/linux/amd64/17.0/musl "/usr/${TARGET}/etc/portage/make.profile"

# Allow user patches for gentoo functions.
run find "/usr/portage/sys-apps/gentoo-functions" -maxdepth 1 -name gentoo-functions-*.ebuild \
  -exec sed -i "s/src_prepare\s*(\s*)\s*{\s*/src_prepare() {\n epatch_user \n/g" "{}" \; \
  -exec ebuild "{}" manifest \;

# Fix musl arch.
run find "/usr/portage/sys-libs/musl" -maxdepth 1 -name musl-*.ebuild \
  -exec sed -i "s/local arch=.*$/local arch=\"x86_64\"/g" "{}" \; \
  -exec ebuild "{}" manifest \;

build "${TARGET}-emerge" -v1 \
  sys-devel/gcc sys-devel/binutils sys-libs/musl sys-kernel/linux-headers

build "${TARGET}-emerge" -v1 \
  app-shells/bash app-arch/tar sys-devel/make sys-devel/patch \
  sys-apps/findutils sys-apps/grep sys-apps/gawk net-misc/wget

build "${TARGET}-emerge" -v1 sys-apps/portage

run rm "/usr/${TARGET}/etc/portage/make.profile"

commit

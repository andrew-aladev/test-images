#!/bin/bash
set -e

cd "$(dirname $0)"

source "../../env.sh"
source "../../utils.sh"

CROSSDEV_DOCKER_IMAGE="${DOCKER_IMAGE_PREFIX}_aarch64-unknown-linux-gnu_amd64-crossdev"
DOCKER_IMAGE="${DOCKER_IMAGE_PREFIX}_aarch64-unknown-linux-gnu_base"

CONTAINER=$(buildah from "scratch")
buildah config --label maintainer="$MAINTAINER" "$CONTAINER"

CROSSDEV_CONTAINER=$(buildah from "$CROSSDEV_DOCKER_IMAGE")
CROSSDEV_ROOT=$(buildah mount "$CROSSDEV_CONTAINER")
copy "$CROSSDEV_ROOT/usr/aarch64-unknown-linux-gnu/" /
buildah unmount "$CROSSDEV_CONTAINER"

copy root/ /
run "env-update"

run chown -R portage:portage /usr/portage
run emerge-webrsync

run ln -s /usr/portage/profiles/default/linux/arm64/17.0 /etc/portage/make.profile
run "echo \"\" > /var/lib/portage/world"

build emerge -v1 sys-apps/portage

build USE=\"-nls\" emerge -v1 sys-apps/diffutils
build emerge -v1 sys-apps/baselayout
run "env-update && source /etc/profile"

build emerge -v1 app-arch/gzip
run locale-gen

build USE=\"-nls\" emerge -v1 sys-apps/gawk sys-apps/net-tools
build USE=\"-berkdb -nls\" emerge -v1 dev-lang/perl
build USE=\"-nls\" emerge -v1 dev-lang/perl
build emerge -v1 dev-util/pkgconfig
build USE=\"-filecaps\" emerge -v1 sys-libs/pam
build emerge -v1 sys-libs/pam sys-apps/shadow

commit

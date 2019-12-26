#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

source "../../../utils.sh"
source "./env.sh"

CONTAINER=$(buildah from "scratch")
buildah config --label maintainer="$MAINTAINER" "$CONTAINER"

CROSSDEV_CONTAINER=$(buildah from "$FROM_IMAGE_NAME")
CROSSDEV_ROOT=$(buildah mount "$CROSSDEV_CONTAINER")
copy "$CROSSDEV_ROOT/usr/${TARGET}/" /
buildah unmount "$CROSSDEV_CONTAINER"

copy root/ /
run env-update

run emerge-webrsync

run ln -s /usr/portage/profiles/default/linux/arm/17.0 /etc/portage/make.profile
run eval "echo '' > /var/lib/portage/world"

build USE="-nls" emerge -v1 sys-apps/diffutils
build emerge -v1 sys-apps/baselayout
run eval "env-update && source /etc/profile"

build emerge -v1 app-arch/gzip
run locale-gen

build USE="-nls" emerge -v1 sys-apps/gawk sys-apps/net-tools

build USE="internal-glib" emerge -v1 dev-util/pkgconfig
build USE="-nls" emerge -v1 dev-util/pkgconfig

build USE="-berkdb -nls" emerge -v1 dev-lang/perl
build emerge -v1 dev-lang/perl

build USE="-filecaps" emerge -v1 sys-libs/pam
build emerge -v1 sys-libs/pam sys-apps/shadow

build emerge -v sys-apps/portage
build emerge -v app-portage/gentoolkit

run update
build upgrade
run cleanup

commit

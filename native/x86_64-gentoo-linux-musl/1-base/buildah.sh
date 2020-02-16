#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

source "../../../utils.sh"
source "./env.sh"

check_up_to_date

CONTAINER=$(from "scratch")
config --arch="amd64"

CROSSDEV_CONTAINER=$(from "$FROM_IMAGE_NAME")
CROSSDEV_ROOT=$(mount "$CROSSDEV_CONTAINER")
copy "${CROSSDEV_ROOT}/usr/${TARGET}/" /
unmount "$CROSSDEV_CONTAINER"

copy root/ /
run env-update

run emerge-webrsync

run ln -s /usr/portage/profiles/default/linux/amd64/17.0/musl /etc/portage/make.profile
run eval "echo '' > /var/lib/portage/world"

build USE="-nls" emerge -v1 sys-apps/diffutils
build emerge -v1 sys-apps/baselayout
run eval "env-update && source /etc/profile"

build emerge -v1 app-arch/gzip

# TODO remove this workaround after https://github.com/gentoo/gentoo/pull/9822 will be merged
#  and https://bugs.gentoo.org/705970 will be fixed.
build PYTHON_TARGETS="python3_6" emerge -v1 dev-lang/python-exec sys-apps/portage
# TODO end of workaround

# Using standalone version of queue from glibc https://bugs.gentoo.org/604590.
build emerge -v sys-libs/queue-standalone

build USE="-nls" emerge -v1 sys-apps/gawk sys-apps/net-tools

build USE="internal-glib" emerge -v1 dev-util/pkgconfig
build USE="-berkdb -nls" emerge -v1 dev-lang/perl
build emerge -v1 dev-lang/perl
build USE="-nls" emerge -v1 dev-util/pkgconfig
build emerge -v1 dev-util/pkgconfig

build emerge -v1 sys-apps/diffutils app-arch/gzip
build emerge -v1 sys-apps/gawk sys-apps/net-tools

build USE="-filecaps" emerge -v1 sys-libs/pam
build emerge -v1 sys-libs/pam sys-apps/shadow

build emerge -v sys-apps/portage
build emerge -v app-portage/gentoolkit

commit

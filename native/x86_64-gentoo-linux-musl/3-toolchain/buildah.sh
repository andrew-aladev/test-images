#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

source "../../../utils.sh"
source "./env.sh"

check_up_to_date

CONTAINER=$(from "$FROM_IMAGE_NAME")
config --arch="amd64"

build emerge -v1 sys-devel/gcc
build emerge -v1 sys-devel/binutils
build emerge -v1 sys-libs/musl
build emerge -v1 sys-kernel/linux-headers

commit

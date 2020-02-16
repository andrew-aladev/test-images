#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

source "../../../utils.sh"
source "./env.sh"

check_up_to_date

CONTAINER=$(from "$FROM_IMAGE_NAME")
config --arch="amd64"

build emerge -ve @world \
  --exclude="sys-devel/gcc sys-devel/binutils sys-libs/musl sys-kernel/linux-headers"

commit

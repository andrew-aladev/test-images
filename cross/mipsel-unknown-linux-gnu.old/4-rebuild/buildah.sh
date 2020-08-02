#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

source "../../../utils.sh"
source "./env.sh"

check_up_to_date

CONTAINER=$(from "$FROM_IMAGE_NAME")
config --arch="mips"

build emerge -ve @world \
  --exclude="sys-devel/gcc sys-devel/binutils sys-libs/glibc sys-kernel/linux-headers"

commit
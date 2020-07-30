#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
source "${DIR}/../../../env.sh"

TARGET="x86_64-gentoo-linux-musl"

FROM_IMAGE="${IMAGE_PREFIX}_x86_64-pc-linux-gnu"
IMAGE_NAME="${IMAGE_PREFIX}_${TARGET}_crossdev"
IMAGE_PLATFORM="linux/amd64"

#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
source "${DIR}/../../../env.sh"

TARGET="x86_64-gentoo-linux-musl"

FROM_IMAGE="${IMAGE_PREFIX}_${TARGET}_crossdev"
IMAGE_NAME="${IMAGE_PREFIX}_${TARGET}_base"
IMAGE_PLATFORM="linux/amd64"

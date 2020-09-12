#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
source "${DIR}/../env.sh"

FROM_IMAGE="${IMAGE_PREFIX}_${TARGET}_toolchain"
IMAGE_NAME="${IMAGE_PREFIX}_${TARGET}_prefix"
IMAGE_PLATFORM="linux/amd64"

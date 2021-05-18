#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
source "${DIR}/../env.sh"

FROM_IMAGE="${IMAGE_PREFIX}_stage3-amd64-nomultilib"
IMAGE_NAME="${IMAGE_PREFIX}_${TARGET}_toolchain"
IMAGE_PLATFORM="linux/amd64"
IMAGE_LAYERS="false"

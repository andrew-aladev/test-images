#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
source "${DIR}/../env.sh"

FROM_IMAGE_PREFIX="${IMAGE_PREFIX}_${TARGET}_prefix"

IMAGE_BUILD_ARGS="FROM_IMAGE_PREFIX TARGET"
IMAGE_NAME="${IMAGE_PREFIX}_${TARGET}_base"
IMAGE_PLATFORM="linux/amd64"
IMAGE_LAYERS="false"

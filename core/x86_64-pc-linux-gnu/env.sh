#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
source "${DIR}/../env.sh"

TARGET="x86_64-pc-linux-gnu"
FROM_IMAGE="${DOCKER_HOST}/ubuntu"

IMAGE_BUILD_ARGS="FROM_IMAGE"
IMAGE_NAME="${IMAGE_PREFIX}_${TARGET}"
IMAGE_PLATFORM="linux/x86_64"

#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
source "${DIR}/../env.sh"

TARGET="i386-alpine-linux-musl"
FROM_IMAGE="${DOCKER_HOST}/i386/alpine"

IMAGE_BUILD_ARGS="FROM_IMAGE"
IMAGE_NAME="${IMAGE_PREFIX}_${TARGET}"
IMAGE_PLATFORM="linux/386"

#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
source "${DIR}/../env.sh"

FROM_IMAGE="${IMAGE_PREFIX}_${TARGET}_base"
IMAGE_NAME="${IMAGE_PREFIX}_${TARGET}"
IMAGE_PLATFORM="linux/amd64"

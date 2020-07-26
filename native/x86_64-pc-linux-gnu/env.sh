#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
source "${DIR}/../../env.sh"

FROM_USERNAME="gentoo"
FROM_IMAGE_NAME="stage3-amd64-nomultilib"
IMAGE_NAME="${IMAGE_PREFIX}_x86_64-pc-linux-gnu"
IMAGE_PLATFORM="linux/amd64"

#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
source "${DIR}/../../env.sh"

FROM_DOCKER_USERNAME="gentoo"
FROM_IMAGE_NAME="stage3-x86"
IMAGE_NAME="${IMAGE_PREFIX}_i686-pc-linux-gnu"

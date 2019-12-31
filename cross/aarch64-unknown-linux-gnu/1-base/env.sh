#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
source "${DIR}/../env.sh"

FROM_IMAGE_NAME="${IMAGE_PREFIX}_${TARGET}_amd64-crossdev"
IMAGE_NAME="${IMAGE_PREFIX}_${TARGET}_base"

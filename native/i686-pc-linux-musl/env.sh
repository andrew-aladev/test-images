#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
source "${DIR}/../../env.sh"

FROM_IMAGE_NAME="${IMAGE_PREFIX}_x86_64-pc-linux-musl"
IMAGE_NAME="${IMAGE_PREFIX}_i686-pc-linux-musl"

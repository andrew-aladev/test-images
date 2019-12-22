#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
source "${DIR}/../../../env.sh"

FROM_IMAGE_NAME="${IMAGE_PREFIX}_arm-unknown-linux-gnueabi_base"
IMAGE_NAME="${IMAGE_PREFIX}_arm-unknown-linux-gnueabi_toolchain"

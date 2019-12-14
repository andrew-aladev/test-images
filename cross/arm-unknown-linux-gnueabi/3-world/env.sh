#!/bin/bash
set -e

cd "$(dirname $0)"

source "../../../env.sh"

FROM_IMAGE_NAME="${IMAGE_PREFIX}_arm-unknown-linux-gnueabi_toolchain"
IMAGE_NAME="${IMAGE_PREFIX}_arm-unknown-linux-gnueabi_world"

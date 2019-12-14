#!/bin/bash
set -e

cd "$(dirname $0)"

source "../../../env.sh"

FROM_IMAGE_NAME="${IMAGE_PREFIX}_aarch64_be-unknown-linux-gnu_base"
IMAGE_NAME="${IMAGE_PREFIX}_aarch64_be-unknown-linux-gnu_toolchain"

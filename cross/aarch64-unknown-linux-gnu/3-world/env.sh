#!/bin/bash
set -e

cd "$(dirname $0)"

source "../../../env.sh"

FROM_IMAGE_NAME="${IMAGE_PREFIX}_aarch64-unknown-linux-gnu_toolchain"
IMAGE_NAME="${IMAGE_PREFIX}_aarch64-unknown-linux-gnu_world"

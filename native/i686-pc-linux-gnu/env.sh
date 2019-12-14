#!/bin/bash
set -e

cd "$(dirname $0)"

source "../../env.sh"

FROM_IMAGE_NAME="docker.io/gentoo/stage3-x86"
IMAGE_NAME="${IMAGE_PREFIX}_i686-pc-linux-gnu"

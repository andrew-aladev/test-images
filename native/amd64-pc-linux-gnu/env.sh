#!/bin/bash
set -e

cd "$(dirname $0)"

source "../../env.sh"

FROM_IMAGE_NAME="docker.io/gentoo/stage3-amd64-nomultilib"
IMAGE_NAME="${IMAGE_PREFIX}_amd64-pc-linux-gnu"

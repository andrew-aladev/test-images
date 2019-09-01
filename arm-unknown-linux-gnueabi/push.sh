#!/bin/bash
set -e

cd "$(dirname $0)"

source "../env.sh"
source "../utils.sh"

docker_push "${DOCKER_IMAGE_PREFIX}_arm-unknown-linux-gnueabi"

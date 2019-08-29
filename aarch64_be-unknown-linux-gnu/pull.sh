#!/bin/bash
set -e

cd "$(dirname $0)"

source "../env.sh"
source "../utils.sh"

docker_pull "${DOCKER_IMAGE_PREFIX}_aarch64_be-unknown-linux-gnu"

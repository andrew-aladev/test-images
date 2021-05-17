#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
source "${DIR}/../env.sh"

FROM_IMAGE_PROCESSOR="docker.io/alpine"
IMAGE_NAME="${IMAGE_PREFIX}_stage3-amd64-nomultilib"
IMAGE_PLATFORM="linux/amd64"
AUTOBUILDS_URL="https://mirror.yandex.ru/gentoo-distfiles/releases/amd64/autobuilds"
SIGN_KEY="0xBB572E0E2D182910"

#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
source "${DIR}/../env.sh"

FROM_IMAGE_PROCESSOR="docker.io/alpine"
FROM_IMAGE="docker.io/busybox"
PORTAGE_URL="https://mirror.yandex.ru/gentoo-distfiles/snapshots/gentoo-latest.tar.xz"
SIGN_KEY="0xEC590EEAC9189250"
IMAGE_NAME="${IMAGE_PREFIX}_portage"
IMAGE_PLATFORM="linux/amd64"
IMAGE_LAYERS="false"

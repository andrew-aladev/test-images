#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
source "${DIR}/../env.sh"

FROM_IMAGE="docker.io/alpine"
IMAGE_NAME="${IMAGE_PREFIX}_portage"
IMAGE_PLATFORM="linux/amd64"
PORTAGE_URL="https://mirror.yandex.ru/gentoo-distfiles/snapshots/gentoo-latest.tar.xz"
PORTAGE_KEY="0xEC590EEAC9189250"

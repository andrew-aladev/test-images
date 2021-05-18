#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

source "../../utils.sh"
source "./env.sh"

portage=$(attach "${IMAGE_PREFIX}_portage" "/" "attached-portage")
build --volume "$(pwd)/attached-portage/var/db/repos/gentoo:/var/db/repos/gentoo" \
  || error=$?
detach "$portage" "attached-portage" || true

if [ ! -z "$error" ]; then
  exit "$error"
fi

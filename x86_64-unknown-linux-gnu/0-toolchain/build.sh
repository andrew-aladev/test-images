#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

source "../../utils.sh"
source "./env.sh"

portage=$(attach "${IMAGE_PREFIX}_portage")
build --volume "$(pwd)/attached-root/var/db/repos/gentoo:/var/db/repos/gentoo" \
  || error=$?
detach "$portage" || :

if [ ! -z "$error" ]; then
  exit "$error"
fi

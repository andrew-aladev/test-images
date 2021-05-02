#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

source "../../../utils.sh"
source "./env.sh"

container=$(attach "/usr/${TARGET}")
build "PORTAGE_SNAPSHOT" || error=$?
detach "$container" || true

if [ ! -z "$error" ]; then
  exit "$error"
fi

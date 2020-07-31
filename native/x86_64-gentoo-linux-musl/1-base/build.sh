#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

source "../../../utils.sh"
source "./env.sh"

container=$(attach "/usr/${TARGET}")
BUILD_ARGS="" build || error=$?
detach "$container" || true

if [ ! -z "$error" ]; then
  exit "$error"
fi

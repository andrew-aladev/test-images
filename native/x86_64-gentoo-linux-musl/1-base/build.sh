#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

source "../../../utils.sh"
source "./env.sh"

(
  attach "/usr/${TARGET}"
  build
) || error=$?

detach || true

if [ ! -z "$error" ]; then
  exit "$error"
fi

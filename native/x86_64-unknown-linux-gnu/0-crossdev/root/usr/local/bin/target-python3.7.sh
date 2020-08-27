#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
source "${DIR}/target-env.sh"

TARGET_PREFIX="/usr/${TARGET}"
LOADER_PATH="lib64/ld-linux*"
LIBRARY_PATHES=("lib64" "usr/lib64" "usr/lib/gcc/${TARGET}/*")

LD_PATH=$(ls -d ${TARGET_PREFIX}/${LOADER_PATH})

function join {
  local IFS="$1"
  shift
  echo "$*"
}

LD_LIBRARY_PATHES=("${LD_LIBRARY_PATH%:}")

for LIBRARY_PATH in "${LIBRARY_PATHES[@]}"; do
  LD_LIBRARY_PATHES+=($(ls -d ${TARGET_PREFIX}/${LIBRARY_PATH}))
done

LD_LIBRARY_PATH=$(join ":" "${LD_LIBRARY_PATHES[@]}")

"$LD_PATH" --library-path "$LD_LIBRARY_PATH" \
  "${TARGET_PREFIX}/usr/bin/python3.7" "$@"
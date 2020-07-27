#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
source "${DIR}/target.sh"

TARGET_PREFIX="/usr/${TARGET}"
LIBRARY_PATHES=("lib" "usr/lib" "usr/lib/gcc/${TARGET}/*")

LD_LIBRARY_PATHES=("${LD_LIBRARY_PATH%:}"
)
for LIBRARY_PATH in "${LIBRARY_PATHES[@]}"; do
  LD_LIBRARY_PATHES+=($(eval ls -d "${TARGET_PREFIX}/${LIBRARY_PATH}"))
done

function join {
  local IFS="$1"
  shift
  echo "$*"
}

LD_LIBRARY_PATH=$(join ":" "${LD_LIBRARY_PATHES[@]}")

quoted_args=""

for arg in "$@"; do
  quoted_args+=$(printf " %q" "$arg")
done

LD_LIBRARY_PATH="$LD_LIBRARY_PATH" \
  eval "${TARGET_PREFIX}/usr/bin/python3.7" "$quoted_args"

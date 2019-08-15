#!/bin/bash

CPU_COUNT=$(grep -c "^processor" "/proc/cpuinfo")
MAKEOPTS="-j$CPU_COUNT"

copy () {
  buildah copy "$CONTAINER" $@
}

run () {
  command="$@"
  buildah run "$CONTAINER" -- sh -c "$command"
}

build () {
  command="MAKEOPTS=\"$MAKEOPTS\" $@"
  buildah run --cap-add=CAP_SYS_PTRACE "$CONTAINER" -- sh -c "$command"
}

commit () {
  buildah commit --format docker "$CONTAINER" "$DOCKER_IMAGE"
}

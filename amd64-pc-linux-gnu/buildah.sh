#!/bin/bash
set -e

cd "$(dirname $0)"

source "../env.sh"

DOCKER_CONTAINER="${DOCKER_CONTAINER_PREFIX}_amd64-pc-linux-gnu"

CPU_COUNT=$(grep -c "^processor" "/proc/cpuinfo")
MAKEOPTS="-j$CPU_COUNT"

container=$(buildah from "docker.io/gentoo/stage3-amd64-nomultilib:latest")
buildah config --label maintainer="$MAINTAINER" "$container"

copy () {
  buildah copy "$container" $@
}
run () {
  command="$@"
  buildah run "$container" -- sh -c "$command"
}
build () {
  command="MAKEOPTS=\"$MAKEOPTS\" $@"
  buildah run --cap-add=CAP_SYS_PTRACE "$container" -- sh -c "$command"
}
commit () {
  buildah commit --format docker "$container" "$DOCKER_CONTAINER"
}

run rm -r /usr/share/{doc,man,info}
copy root/ /

run chown -R portage:portage /usr/portage
run emerge-webrsync

run eselect profile set default/linux/amd64/17.1/no-multilib
run "source /etc/profile && env-update"

build emerge -v1 sys-devel/gcc sys-devel/binutils sys-libs/glibc
build emerge -ve @world
build emerge -v app-portage/gentoolkit
build emerge -v clang

build "update && upgrade && cleanup"

run rm -rf /etc/._cfg*
run eselect news read

commit

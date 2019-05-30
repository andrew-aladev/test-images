#!/bin/bash
set -e

cd "$(dirname $0)"

container=$(buildah from "scratch")
buildah config --label maintainer="$MAINTAINER" "$container"

copy () {
  buildah copy "$container" $@
}
run () {
  command="$@"
  buildah run "$container" -- sh -c "$command"
}
build () {
  command="$@"
  buildah run --cap-add=CAP_SYS_PTRACE "$container" -- sh -c "$command"
}
commit () {
  buildah commit --format docker "$container" "$1"
  buildah push "$1" "docker.io/$1:latest"
}

crossdev_container=$(buildah from "$DOCKER_USERNAME/aarch64-unknown-linux-gnu-gentoo-stable-amd64-crossdev:latest")
crossdev=$(buildah mount "$crossdev_container")
copy "$crossdev/usr/aarch64-unknown-linux-gnu/" /
buildah unmount "$crossdev_container"

copy root/ /

# Master system qemu can increase performance (built with optimizations for current hardware).
for qemu_name in "qemu-aarch64-static" "qemu-aarch64"; do
  qemu_path=$(which "$qemu_name" || continue)
  if [[ $(file "$qemu_path") != *statically\ linked* ]]; then
    continue
  fi
  run mv /usr/bin/qemu-aarch64 /usr/bin/qemu-aarch64.bak
  copy $qemu_path /usr/bin/qemu-aarch64
  break
done

run chown -R portage:portage /usr/portage
run emerge-webrsync

run ln -s /usr/portage/profiles/default/linux/arm64/17.0 /etc/portage/make.profile
echo '' > /var/lib/portage/world

build emerge -v1 sys-apps/diffutils
build emerge -v1 sys-apps/baselayout
run source /etc/profile && env-update

build emerge -v1 app-arch/gzip
run locale-gen

build emerge -v1 sys-apps/gawk sys-apps/net-tools
build USE="-berkdb -nls" emerge -v1 perl

#docker login --username "$DOCKER_USERNAME"
#commit "$DOCKER_USERNAME/aarch64-unknown-linux-gnu-gentoo-stable"

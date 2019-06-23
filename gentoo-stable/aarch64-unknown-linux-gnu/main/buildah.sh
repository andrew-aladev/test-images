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

run chown -R portage:portage /usr/portage
run emerge-webrsync

run ln -s /usr/portage/profiles/default/linux/arm64/17.0 /etc/portage/make.profile
run echo "" > /var/lib/portage/world

build USE=\"-nls\" emerge -v1 sys-apps/diffutils
build emerge -v1 sys-apps/baselayout
run "source /etc/profile && env-update"

build emerge -v1 app-arch/gzip
run locale-gen

build USE=\"-nls\" emerge -v1 sys-apps/gawk sys-apps/net-tools
build USE=\"-berkdb -nls\" emerge -v1 dev-lang/perl
build USE=\"-nls\" emerge -v1 dev-lang/perl
build emerge -v1 dev-util/pkgconfig
build USE=\"-filecaps\" emerge -v1 sys-libs/pam
build emerge -v1 sys-libs/pam sys-apps/shadow

build emerge -v1 sys-devel/gcc
build emerge -v1 sys-devel/binutils
build emerge -v1 sys-libs/glibc
build emerge -ve @world
build emerge -v app-portage/gentoolkit

build "update && upgrade && cleanup"

run rm -rf /etc/._cfg*
run eselect news read

docker login --username "$DOCKER_USERNAME"
commit "$DOCKER_USERNAME/aarch64-unknown-linux-gnu-gentoo-stable"

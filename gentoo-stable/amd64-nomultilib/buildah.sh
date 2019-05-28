#!/bin/sh
set -e

cd "$(dirname $0)"

container=$(buildah from "docker.io/gentoo/stage3-amd64-nomultilib:latest")
buildah config --label maintainer="$MAINTAINER" $container

copy () {
  buildah copy $container $@
}
run () {
  command="$@"
  buildah run $container -- sh -c "$command"
}
build () {
  command="$@"
  buildah run --cap-add=CAP_SYS_PTRACE $container -- sh -c "$command"
}
commit () {
  buildah commit --format docker $container $1
  buildah push $1 "docker.io/$1"
}

run rm -r /usr/share/{doc,man,info}
copy root /

run chown -R portage:portage /usr/portage
run emerge-webrsync

run eselect profile set default/linux/amd64/17.0/no-multilib
run source /etc/profile && env-update

build emerge -v1 sys-devel/gcc sys-devel/binutils sys-libs/binutils-libs sys-libs/glibc
build emerge -ve @world
build emerge -v app-portage/gentoolkit app-portage/smart-live-rebuild

build update && upgrade && cleanup

run rm -rf /etc/._cfg*
run eselect news read

docker login --username "$DOCKER_USERNAME"
commit "$DOCKER_USERNAME/amd64-gentoo-stable-nomultilib:latest"

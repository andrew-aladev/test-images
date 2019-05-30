#!/bin/bash
set -e

cd "$(dirname $0)"

container=$(buildah from "$DOCKER_USERNAME/amd64-gentoo-stable-nomultilib:latest")
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
}

copy root/ /

build emerge -v sys-devel/crossdev app-emulation/qemu
build crossdev -t aarch64-unknown-linux-gnu --stable

copy crossdev-root/ /usr/aarch64-unknown-linux-gnu/

run rm /usr/aarch64-unknown-linux-gnu/etc/portage/make.profile
run ln -s /usr/portage/profiles/default/linux/arm64/17.0 /usr/aarch64-unknown-linux-gnu/etc/portage/make.profile

build aarch64-unknown-linux-gnu-emerge -v1 \
  sys-devel/gcc sys-devel/binutils sys-libs/binutils-libs sys-libs/glibc sys-kernel/linux-headers \
  sys-apps/portage app-shells/bash app-arch/tar sys-devel/make sys-devel/patch \
  sys-apps/findutils sys-apps/grep sys-apps/gawk net-misc/wget

run cp /usr/bin/qemu-aarch64 /usr/aarch64-unknown-linux-gnu/usr/bin/

run rm /usr/aarch64-unknown-linux-gnu/etc/portage/make.profile
run rm -r /usr/aarch64-unknown-linux-gnu/etc/portage/patches

commit "$DOCKER_USERNAME/aarch64-unknown-linux-gnu-gentoo-stable-amd64-crossdev"

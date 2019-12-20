#!/bin/bash
set -e

cd "$(dirname $0)"

source "../../../utils.sh"
source "./env.sh"

CONTAINER=$(buildah from "$FROM_IMAGE_NAME")
buildah config --label maintainer="$MAINTAINER" "$CONTAINER"

copy root/ /

build emerge -v sys-devel/crossdev app-emulation/qemu
build crossdev -t arm-unknown-linux-gnueabi --stable

copy crossdev-root/ /usr/arm-unknown-linux-gnueabi/
run cd /usr/arm-unknown-linux-gnueabi/usr/bin/ "&&" \
  cp /usr/bin/qemu-arm qemu-arm "&&" \
  ln -s qemu-arm qemu-arm-static

run rm /usr/arm-unknown-linux-gnueabi/etc/portage/make.profile
run ln -s /usr/portage/profiles/default/linux/arm/17.0 /usr/arm-unknown-linux-gnueabi/etc/portage/make.profile

build arm-unknown-linux-gnueabi-emerge -v1 \
  sys-devel/gcc sys-devel/binutils sys-libs/glibc sys-kernel/linux-headers

build arm-unknown-linux-gnueabi-emerge -v1 \
  app-shells/bash app-arch/tar sys-devel/make sys-devel/patch \
  sys-apps/findutils sys-apps/grep sys-apps/gawk net-misc/wget

# TODO remove this workaround after https://github.com/gentoo/gentoo/pull/9822 will be merged.
build arm-unknown-linux-gnueabi-emerge -v1 dev-lang/python

run cp /usr/arm-unknown-linux-gnueabi/lib/ld-linux.so* /lib/
run sed -i "s/export PYTHON=\${EPREFIX}\/usr\/bin\/\${impl}/export PYTHON=arm-unknown-linux-gnueabi-\${impl}/g" \
  /usr/portage/eclass/python-utils-r1.eclass
run sed -i "s/\"\${EPYTHON:-python}\"/\"arm-unknown-linux-gnueabi-\${EPYTHON:-python}\"/g" \
  /usr/portage/eclass/distutils-r1.eclass
run sed -i "s/esetup.py install \(.*\)/esetup.py install \1 --home=\"\/usr\"/g" \
  /usr/portage/eclass/distutils-r1.eclass

copy arm-unknown-linux-gnueabi-python3.6 /usr/bin/
run cd /usr/bin "&&" \
  ln -s arm-unknown-linux-gnueabi-python3.6 arm-unknown-linux-gnueabi-python3 "&&" \
  ln -s arm-unknown-linux-gnueabi-python3.6 arm-unknown-linux-gnueabi-python
# TODO end of workaround

build arm-unknown-linux-gnueabi-emerge -v1 sys-apps/portage

run rm /usr/arm-unknown-linux-gnueabi/etc/portage/make.profile
run rm -r /usr/arm-unknown-linux-gnueabi/etc/portage/patches

commit

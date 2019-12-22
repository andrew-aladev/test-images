#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

source "../../../utils.sh"
source "./env.sh"

CONTAINER=$(buildah from "$FROM_IMAGE_NAME")
buildah config --label maintainer="$MAINTAINER" "$CONTAINER"

copy root/ /

build emerge -v sys-devel/crossdev app-emulation/qemu
build crossdev -t "$TARGET" --stable

copy crossdev-root/ "/usr/${TARGET}/"
run cp /usr/bin/qemu-arm "/usr/${TARGET}/usr/bin/"
run ln -s "/usr/${TARGET}/usr/bin/qemu-arm" "/usr/${TARGET}/usr/bin/qemu-arm-static"

run rm "/usr/${TARGET}/etc/portage/make.profile"
run ln -s /usr/portage/profiles/default/linux/arm/17.0 "/usr/${TARGET}/etc/portage/make.profile"

build "${TARGET}-emerge" -v1 \
  sys-devel/gcc sys-devel/binutils sys-libs/glibc sys-kernel/linux-headers

build "${TARGET}-emerge" -v1 \
  app-shells/bash app-arch/tar sys-devel/make sys-devel/patch \
  sys-apps/findutils sys-apps/grep sys-apps/gawk net-misc/wget

# TODO remove this workaround after https://github.com/gentoo/gentoo/pull/9822 will be merged.
build "${TARGET}-emerge" -v1 dev-lang/python

run find "/usr/${TARGET}/lib" -maxdepth 1 -name ld* \
  -exec cp "{}" /lib/ \;
run sed -i "s/export PYTHON=\${EPREFIX}\/usr\/bin\/\${impl}/export PYTHON=${TARGET}-\${impl}/g" \
  /usr/portage/eclass/python-utils-r1.eclass
run sed -i "s/\${EPYTHON:-python}/${TARGET}-\${EPYTHON:-python}/g" \
  /usr/portage/eclass/distutils-r1.eclass
run sed -i "s/esetup.py install \(.*\)/esetup.py install \1 --prefix=\"\/usr\"/g" \
  /usr/portage/eclass/distutils-r1.eclass
run find /usr/portage/sys-apps/portage -maxdepth 1 -name portage-*.ebuild \
  -exec sed -i "s/\${D%\/}\${PYTHON_SITEDIR}/\${D%\/}\${PYTHON_SITEDIR#\${EROOT%\/}}/g" "{}" \; \
  -exec ebuild "{}" manifest \;

copy target-python3.6 "/usr/bin/${TARGET}-python3.6"
run ln -s "/usr/bin/${TARGET}-python3.6" "/usr/bin/${TARGET}-python3"
run ln -s "/usr/bin/${TARGET}-python3.6" "/usr/bin/${TARGET}-python"
# TODO end of workaround

build "${TARGET}-emerge" -v1 sys-apps/portage

run rm "/usr/${TARGET}/etc/portage/make.profile"
run rm -r "/usr/${TARGET}/etc/portage/patches"

commit

#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

source "../../../utils.sh"
source "./env.sh"

docker_pull "$FROM_IMAGE_NAME"
check_up_to_date

CONTAINER=$(buildah from "$FROM_IMAGE_NAME")
buildah config --label maintainer="$MAINTAINER" --arch="amd64" "$CONTAINER"

copy root/ /

run mkdir "/usr/${TARGET}"
copy crossdev-root/ "/usr/${TARGET}/"

build emerge -v sys-devel/crossdev

# Disable stack protector https://bugs.gentoo.org/706210.
build USE="-ssp" crossdev -t "$TARGET" --stable

# Rebuilding glibc to apply elf_mismatch_is_not_fatal patch for https://sourceware.org/bugzilla/show_bug.cgi?id=25341.
build emerge -v1 sys-libs/glibc

run rm -f "/usr/${TARGET}/etc/portage/make.profile"
run ln -s /usr/portage/profiles/default/linux/x86/17.0/musl "/usr/${TARGET}/etc/portage/make.profile"

# Fix musl arch for crossdev only.
run find "/usr/portage/sys-libs/musl" -maxdepth 1 -name musl-*.ebuild \
  -exec sed -i "s/local arch=.*$/local arch=\"i386\"/g" "{}" \; \
  -exec ebuild "{}" manifest \;

# Fix curl pkgconfig dependency for crossdev only.
run find "/usr/portage/net-misc/curl" -maxdepth 1 -name curl-*.ebuild \
  -exec sed -i "s/virtual\/pkgconfig\-0\-r1.*$/virtual\/pkgconfig\-0\-r1/g" "{}" \; \
  -exec ebuild "{}" manifest \;

build "${TARGET}-emerge" -v1 \
  sys-devel/gcc sys-devel/binutils sys-libs/musl sys-kernel/linux-headers

build "${TARGET}-emerge" -v1 \
  app-shells/bash app-arch/tar sys-devel/make sys-devel/patch \
  sys-apps/findutils sys-apps/grep sys-apps/gawk net-misc/wget

# TODO remove this workaround after https://github.com/gentoo/gentoo/pull/9822 will be merged
#  and https://bugs.gentoo.org/705970 will be fixed.
build "${TARGET}-emerge" -v1 dev-lang/python:3.6

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

copy target-python3.6.sh "/usr/bin/${TARGET}-python3.6"
run eval " \
  cd /usr/bin && \
  ln -s \"${TARGET}-python3.6\" \"${TARGET}-python3\" && \
  ln -s \"${TARGET}-python3.6\" \"${TARGET}-python\""

# Different libc requires double python recompilation https://bugs.gentoo.org/705970.
build EPYTHON_FOR_BUILD="${TARGET}-python3.6" "${TARGET}-emerge" -v1 dev-lang/python:3.6
# TODO end of workaround

# It is not possible to use cross compiled sandbox with another libc https://bugs.gentoo.org/706020.
build "${TARGET}-emerge" -v1 sys-apps/sandbox
run mv "/usr/${TARGET}/usr/lib/libsandbox.so" /tmp/libsandbox.so.bak

build "${TARGET}-emerge" -v1 sys-apps/portage

# It is not possible to use cross compiled sandbox with another libc https://bugs.gentoo.org/706020.
run mv /tmp/libsandbox.so.bak "/usr/${TARGET}/usr/lib/libsandbox.so"

# TODO remove this workaround after https://github.com/gentoo/gentoo/pull/9822 will be merged
#  and https://bugs.gentoo.org/705970 will be fixed.
run find "/usr/${TARGET}/usr/lib" \( -path "*/python-exec/python3.6/*" -o -path "*/portage/python3.6/*" \) -type f \
  -exec sed -i "s/#\!\/usr\/${TARGET}\/usr\/bin\/python/#\!\/usr\/bin\/python/g" "{}" \;
# TODO end of workaround

run eval " \
  cd \"/usr/${TARGET}/etc/portage\" && \
  rm make.profile && \
  rm -r package.accept_keywords && \
  rm -r patches"

commit

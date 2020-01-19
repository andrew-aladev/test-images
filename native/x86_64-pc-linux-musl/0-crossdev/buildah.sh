#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

source "../../../utils.sh"
source "./env.sh"

docker_pull "$FROM_IMAGE_NAME"

CONTAINER=$(buildah from "$FROM_IMAGE_NAME")
buildah config --label maintainer="$MAINTAINER" "$CONTAINER"

copy root/ /

# Rebuilding glibc to apply elf_mismatch_is_not_fatal patch for https://sourceware.org/bugzilla/show_bug.cgi?id=25341.
build emerge -v1 sys-libs/glibc

build emerge -v sys-devel/crossdev
build crossdev -t "$TARGET" --stable

copy crossdev-root/ "/usr/${TARGET}/"

run rm "/usr/${TARGET}/etc/portage/make.profile"
run ln -s /usr/portage/profiles/default/linux/amd64/17.0/musl "/usr/${TARGET}/etc/portage/make.profile"

# Allow user patches for gentoo functions.
run find "/usr/portage/sys-apps/gentoo-functions" -maxdepth 1 -name gentoo-functions-*.ebuild \
  -exec sed -i "s/src_prepare\s*(\s*)\s*{\s*/src_prepare() {\n epatch_user \n/g" "{}" \; \
  -exec ebuild "{}" manifest \;

# Fix musl arch.
run find "/usr/portage/sys-libs/musl" -maxdepth 1 -name musl-*.ebuild \
  -exec sed -i "s/local arch=.*$/local arch=\"x86_64\"/g" "{}" \; \
  -exec ebuild "{}" manifest \;

build "${TARGET}-emerge" -v1 \
  sys-devel/gcc sys-devel/binutils sys-libs/musl sys-kernel/linux-headers

build "${TARGET}-emerge" -v1 \
  app-shells/bash app-arch/tar sys-devel/make sys-devel/patch \
  sys-apps/findutils sys-apps/grep sys-apps/gawk net-misc/wget

# TODO remove this workaround after https://github.com/gentoo/gentoo/pull/9822 will be merged.
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
# TODO end of workaround

build "${TARGET}-emerge" -v1 sys-apps/portage

# TODO remove this workaround after https://github.com/gentoo/gentoo/pull/9822 will be merged.
run find "/usr/${TARGET}/usr/lib" \( -path "*/python-exec/python3.6/*" -o -path "*/portage/python3.6/*" \) -type f \
  -exec sed -i "s/#\!\/usr\/${TARGET}\/usr\/bin\/python/#\!\/usr\/bin\/python/g" "{}" \;
# TODO end of workaround

run eval " \
  cd \"/usr/${TARGET}/etc/portage\" && \
  rm make.profile && \
  rm -r package.keywords && \
  rm -r patches"

commit

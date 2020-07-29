ARG FROM_IMAGE=x86_64-pc-linux-gnu
FROM $FROM_IMAGE

ARG TARGET=x86_64-gentoo-linux-musl
ENV TARGET=$TARGET

COPY root/ /
RUN cd /usr/local/bin && \
  ln -s target-python3.7.sh target-python3.7 && \
  ln -s target-python3.7.sh target-python3 && \
  ln -s target-python3.7.sh target-python

RUN mkdir "/usr/${TARGET}"
COPY crossdev-root/ "/usr/${TARGET}/"

RUN build.sh -v sys-devel/crossdev
RUN crossdev.sh -t "$TARGET" --stable

# Rebuilding glibc for applying patches.
RUN build.sh -v1 sys-libs/glibc

RUN rm -f "/usr/${TARGET}/etc/portage/make.profile" && \
  ln -s /usr/portage/profiles/default/linux/amd64/17.0/musl "/usr/${TARGET}/etc/portage/make.profile"

RUN target-build.sh -v1 \
  sys-devel/gcc sys-devel/binutils sys-libs/musl sys-kernel/linux-headers

RUN target-build.sh -v1 \
  app-shells/bash app-arch/tar sys-devel/make sys-devel/patch \
  sys-apps/findutils sys-apps/grep sys-apps/gawk net-misc/wget

# TODO remove this workaround after https://github.com/gentoo/gentoo/pull/9822 will be merged
#  and https://bugs.gentoo.org/705970 will be fixed.
RUN target-build.sh -v1 dev-lang/python:3.7

RUN find "/usr/${TARGET}/lib" -maxdepth 1 -name ld* \
    -exec cp "{}" /lib/ \; && \
  sed -i "s/export PYTHON=\${EPREFIX}.*\${impl}/export PYTHON=${TARGET}-\${impl}/g" \
    /usr/portage/eclass/python-utils-r1.eclass && \
  sed -i "s/\${EPYTHON:-python}/${TARGET}-\${EPYTHON:-python}/g" \
    /usr/portage/eclass/distutils-r1.eclass && \
  sed -i "s/esetup.py install \(.*\)/esetup.py install \1 --prefix=\"\/usr\"/g" \
    /usr/portage/eclass/distutils-r1.eclass

# Different libc requires double python recompilation https://bugs.gentoo.org/705970.
RUN EPYTHON_FOR_BUILD="target-python3.7" target-build.sh -v1 dev-lang/python:3.7
# TODO end of workaround

# It is not possible to use cross compiled sandbox with another libc https://bugs.gentoo.org/706020.
RUN target-build.sh -v1 sys-apps/sandbox && \
  mv "/usr/${TARGET}/usr/lib/libsandbox.so" /tmp/libsandbox.so.bak

RUN target-build.sh -v1 sys-apps/portage && \
  mv /tmp/libsandbox.so.bak "/usr/${TARGET}/usr/lib/libsandbox.so"

# TODO remove this workaround after https://github.com/gentoo/gentoo/pull/9822 will be merged
#  and https://bugs.gentoo.org/705970 will be fixed.
RUN find "/usr/${TARGET}/usr/lib" \( -path "*/python-exec/python3.7/*" -o -path "*/portage/python3.7/*" \) -type f \
  -exec sed -i "s/#\!\/usr\/${TARGET}\/usr\/bin\/python/#\!\/usr\/bin\/python/g" "{}" \;
# TODO end of workaround

RUN cd "/usr/${TARGET}/etc/portage" && \
  rm make.profile && \
  rm -r package.accept_keywords && \
  rm -r patches

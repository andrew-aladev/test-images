ARG FROM_IMAGE=x86_64-pc-linux-gnu
FROM $FROM_IMAGE

ENV TARGET=x86_64-gentoo-linux-musl

COPY root/ /

RUN mkdir "/usr/${TARGET}"
COPY crossdev-root/ "/usr/${TARGET}/"

RUN build -v sys-devel/crossdev
RUN crossdev -t "$TARGET" --stable

# Rebuilding glibc to apply elf_mismatch_is_not_fatal patch for https://sourceware.org/bugzilla/show_bug.cgi?id=25341.
RUN build -v1 sys-libs/glibc

RUN rm -f "/usr/${TARGET}/etc/portage/make.profile"
RUN ln -s /usr/portage/profiles/default/linux/amd64/17.0/musl "/usr/${TARGET}/etc/portage/make.profile"

# Fix musl arch for crossdev only.
RUN find "/usr/portage/sys-libs/musl" -maxdepth 1 -name musl-*.ebuild \
  -exec sed -i "s/local arch=.*$/local arch=\"x86_64\"/g" "{}" \; \
  -exec ebuild "{}" manifest \;

RUN "${TARGET}-build" -v1 \
  sys-devel/gcc sys-devel/binutils sys-libs/musl sys-kernel/linux-headers

RUN "${TARGET}-build" -v1 \
  app-shells/bash app-arch/tar sys-devel/make sys-devel/patch \
  sys-apps/findutils sys-apps/grep sys-apps/gawk net-misc/wget

# TODO remove this workaround after https://github.com/gentoo/gentoo/pull/9822 will be merged
#  and https://bugs.gentoo.org/705970 will be fixed.
RUN "${TARGET}-build" -v1 dev-lang/python:3.8

RUN find "/usr/${TARGET}/lib" -maxdepth 1 -name ld* \
  -exec cp "{}" /lib/ \;
RUN sed -i "s/export PYTHON=\${EPREFIX}\/usr\/bin\/\${impl}/export PYTHON=${TARGET}-\${impl}/g" \
  /usr/portage/eclass/python-utils-r1.eclass
RUN sed -i "s/\${EPYTHON:-python}/${TARGET}-\${EPYTHON:-python}/g" \
  /usr/portage/eclass/distutils-r1.eclass
RUN sed -i "s/esetup.py install \(.*\)/esetup.py install \1 --prefix=\"\/usr\"/g" \
  /usr/portage/eclass/distutils-r1.eclass
RUN find /usr/portage/sys-apps/portage -maxdepth 1 -name portage-*.ebuild \
  -exec sed -i "s/\${D%\/}\${PYTHON_SITEDIR}/\${D%\/}\${PYTHON_SITEDIR#\${EROOT%\/}}/g" "{}" \; \
  -exec ebuild "{}" manifest \;

COPY target-python3.8.sh "/usr/bin/${TARGET}-python3.8"
RUN cd /usr/bin && \
  ln -s "${TARGET}-python3.8" "${TARGET}-python3" && \
  ln -s "${TARGET}-python3.8" "${TARGET}-python"

# Different libc requires double python recompilation https://bugs.gentoo.org/705970.
RUN EPYTHON_FOR_BUILD="${TARGET}-python3.8" "${TARGET}-build" -v1 dev-lang/python:3.8
# TODO end of workaround

# It is not possible to use cross compiled sandbox with another libc https://bugs.gentoo.org/706020.
RUN "${TARGET}-build" -v1 sys-apps/sandbox
RUN mv "/usr/${TARGET}/usr/lib/libsandbox.so" /tmp/libsandbox.so.bak

RUN "${TARGET}-build" -v1 sys-apps/portage

# It is not possible to use cross compiled sandbox with another libc https://bugs.gentoo.org/706020.
RUN mv /tmp/libsandbox.so.bak "/usr/${TARGET}/usr/lib/libsandbox.so"

# TODO remove this workaround after https://github.com/gentoo/gentoo/pull/9822 will be merged
#  and https://bugs.gentoo.org/705970 will be fixed.
RUN find "/usr/${TARGET}/usr/lib" \( -path "*/python-exec/python3.8/*" -o -path "*/portage/python3.8/*" \) -type f \
  -exec sed -i "s/#\!\/usr\/${TARGET}\/usr\/bin\/python/#\!\/usr\/bin\/python/g" "{}" \;
# TODO end of workaround

RUN cd "/usr/${TARGET}/etc/portage" && \
  rm make.profile && \
  rm -r package.accept_keywords && \
  rm -r patches

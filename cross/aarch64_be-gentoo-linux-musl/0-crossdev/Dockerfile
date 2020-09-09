ARG FROM_IMAGE=x86_64-unknown-linux-gnu
FROM $FROM_IMAGE

ARG TARGET=aarch64_be-gentoo-linux-musl
ENV TARGET=$TARGET

COPY root/ /

# Rebuilding glibc for applying patches.
RUN build.sh -v1 sys-libs/glibc app-emulation/qemu

RUN mkdir "/usr/${TARGET}"
COPY crossdev-root/ "/usr/${TARGET}/"

RUN build.sh -v sys-devel/crossdev && \
  crossdev.sh -t "$TARGET" --stable && \
  rm -f "/usr/${TARGET}/etc/portage/make.profile" && \
  ln -s /usr/portage/profiles/default/linux/arm64/17.0/musl "/usr/${TARGET}/etc/portage/make.profile" && \
  cd "/usr/${TARGET}/usr/bin" && \
    cp /usr/bin/qemu-aarch64_be . && \
    ln -s qemu-aarch64_be qemu-aarch64_be-static

RUN USE="-python" target-build.sh -v1 \
  sys-devel/gcc sys-devel/binutils sys-libs/musl sys-kernel/linux-headers
RUN target-build.sh -v1 \
  app-arch/tar app-shells/bash net-misc/wget sys-apps/findutils \
  sys-apps/gawk sys-apps/grep sys-apps/net-tools sys-apps/shadow \
  sys-devel/make sys-devel/patch dev-lang/python:3.7

# TODO remove this workaround after https://github.com/gentoo/gentoo/pull/9822 will be merged
#   and https://bugs.gentoo.org/705970 will be fixed.
# Different libc (or libc with another version) requires double python recompilation.
RUN cd /usr/local/bin && \
  ln -s target-python3.7.sh python3.7 && \
  ln -s target-python3.7.sh python && \
  \
  cd "/usr/${TARGET}/usr/bin" && \
  mv python3.7 python3.7.original && \
  mv python python.original && \
  ln -s ../local/bin/target-python3.7.sh python3.7 && \
  ln -s ../local/bin/target-python3.7.sh python && \
  \
  target-build.sh -v1 dev-lang/python:3.7 && \
  \
  rm python3.7.original python.original && \
  mv python3.7 python3.7.original && \
  mv python python.original && \
  ln -s ../local/bin/target-python3.7.sh python3.7 && \
  ln -s ../local/bin/target-python3.7.sh python && \
  \
  sed -i "s/esetup.py install \(.*\)/esetup.py install \1 --prefix=\"\/usr\"/g" \
    /usr/portage/eclass/distutils-r1.eclass && \
  find /usr/portage/sys-apps/portage -maxdepth 1 -name "portage-*.ebuild" \
    -exec sed -i "s/\${sitedir}/\${sitedir#\${EROOT%\/}}/g" "{}" \; \
    -exec ebuild "{}" manifest \;
# TODO end of workaround

# It is not possible to use cross compiled sandbox with another libc
#   (or libc with another version) https://bugs.gentoo.org/706020.
RUN target-build.sh -v1 sys-apps/sandbox && \
  mv "/usr/${TARGET}/usr/lib/libsandbox.so" /tmp/libsandbox.so.bak && \
  target-build.sh -v1 sys-apps/portage && \
  mv /tmp/libsandbox.so.bak "/usr/${TARGET}/usr/lib/libsandbox.so"

# TODO remove this workaround after https://github.com/gentoo/gentoo/pull/9822 will be merged
#  and https://bugs.gentoo.org/705970 will be fixed.
RUN cd "/usr/${TARGET}/usr/bin" && \
  rm python3.7 python && \
  mv python3.7.original python3.7 && \
  mv python.original python && \
  rm ../local/bin/target-* && \
  find "/usr/${TARGET}/usr/lib" -type f \
    -exec sed -i "s/^#\!\/usr\/${TARGET}\/usr\/bin\/python/#\!\/usr\/bin\/python/g" "{}" \;
# TODO end of workaround

# Removing all important portage configs.
RUN cd "/usr/${TARGET}/etc/portage" && \
  rm -f make.{conf,profile} && \
  rm -rf {env,patches,repos.conf} && \
  rm -rf package.{accept_keywords,env,license,mask,unmask,use}

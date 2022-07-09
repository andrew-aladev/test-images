ARG FROM_IMAGE
FROM $FROM_IMAGE

ARG TARGET
ENV TARGET=$TARGET

COPY root /
COPY prefix-root "/usr/${TARGET}"
RUN build.sh -v1 sys-libs/glibc

# TODO remove this workaround after https://github.com/gentoo/gentoo/pull/9822 will be merged
#   and https://bugs.gentoo.org/705970 will be fixed.
# Different libc (or libc with another version) requires double python recompilation.
RUN target-build.sh -v1 dev-lang/python:3.10 && \
  \
  cd /usr/local/bin && \
  ln -s target-python.mod.sh python3.10 && \
  \
  cd "/usr/${TARGET}/usr/bin" && \
  mv python3.10 python3.10.orig && \
  ln -s ../local/bin/target-python.mod.sh python3.10 && \
  \
  target-build.sh -v1 dev-lang/python:3.10 && \
  \
  rm python3.10.orig && \
  mv python3.10 python3.10.orig && \
  ln -s ../local/bin/target-python.mod.sh python3.10 && \
  \
  find /var/db/repos/gentoo/sys-apps/portage -maxdepth 1 -name "portage-*.ebuild" \
    -exec sed -i "s/distutils-r1_python_install\([^[:space:]]*\)/distutils-r1_python_install\1 --prefix=\"\/usr\"/g" "{}" \; \
    -exec ebuild "{}" manifest \;
# TODO end of workaround

# It is not possible to use cross compiled sandbox with another libc
#   (or libc with another version).
RUN target-build.sh -v1 sys-apps/sandbox && \
  mv "/usr/${TARGET}/usr/lib/libsandbox.so" /tmp/libsandbox.so.bak && \
  USE="-rsync-verify" target-build.sh -v1 sys-apps/portage && \
  mv /tmp/libsandbox.so.bak "/usr/${TARGET}/usr/lib/libsandbox.so"

# TODO remove this workaround after https://github.com/gentoo/gentoo/pull/9822 will be merged
#  and https://bugs.gentoo.org/705970 will be fixed.
RUN cd "/usr/${TARGET}/usr/bin" && \
  rm python3.10 && \
  mv python3.10.orig python3.10 && \
  rm ../local/bin/target-* && \
  find "/usr/${TARGET}/usr/lib" -type f \
    -exec sed -i "s/^#\!\/usr\/${TARGET}\/usr\/bin\/python/#\!\/usr\/bin\/python/g" "{}" \;
# TODO end of workaround

# Removing all important portage configs.
RUN cd "/usr/${TARGET}/etc/portage" && \
  rm -f make.{conf,profile} && \
  rm -rf {env,patches,repos.conf} && \
  rm -rf package.{accept_keywords,env,license,mask,unmask,use} && \
  target-cleanup.sh && cleanup.sh

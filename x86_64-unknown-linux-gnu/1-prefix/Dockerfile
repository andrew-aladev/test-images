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
RUN target-build.sh -v1 dev-lang/python:3.9 && \
  \
  cd /usr/local/bin && \
  ln -s target-python3.9.sh python3.9 && \
  ln -s target-python3.9.sh python && \
  \
  cd "/usr/${TARGET}/usr/bin" && \
  mv python3.9 python3.9.original && \
  mv python python.original && \
  ln -s ../local/bin/target-python3.9.sh python3.9 && \
  ln -s ../local/bin/target-python3.9.sh python && \
  \
  target-build.sh -v1 dev-lang/python:3.9 && \
  \
  rm python3.9.original python.original && \
  mv python3.9 python3.9.original && \
  mv python python.original && \
  ln -s ../local/bin/target-python3.9.sh python3.9 && \
  ln -s ../local/bin/target-python3.9.sh python && \
  \
  sed -i "s/esetup.py install \(.*\)/esetup.py install \1 --prefix=\"\/usr\"/g" \
    /var/db/repos/gentoo/eclass/distutils-r1.eclass && \
  find /var/db/repos/gentoo/sys-apps/portage -maxdepth 1 -name "portage-*.ebuild" \
    -exec sed -i "s/\${sitedir}/\${sitedir#\${EROOT%\/}}/g" "{}" \; \
    -exec ebuild "{}" manifest \;
# TODO end of workaround

# It is not possible to use cross compiled sandbox with another libc
#   (or libc with another version) https://bugs.gentoo.org/706020.
RUN target-build.sh -v1 sys-apps/sandbox && \
  mv "/usr/${TARGET}/usr/lib64/libsandbox.so" /tmp/libsandbox.so.bak && \
  USE="-rsync-verify" target-build.sh -v1 sys-apps/portage && \
  mv /tmp/libsandbox.so.bak "/usr/${TARGET}/usr/lib64/libsandbox.so"

# TODO remove this workaround after https://github.com/gentoo/gentoo/pull/9822 will be merged
#  and https://bugs.gentoo.org/705970 will be fixed.
RUN cd "/usr/${TARGET}/usr/bin" && \
  rm python3.9 python && \
  mv python3.9.original python3.9 && \
  mv python.original python && \
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

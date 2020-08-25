ARG FROM_IMAGE=stage3-amd64-nomultilib
FROM $FROM_IMAGE

ARG TARGET=x86_64-pc-linux-gnu
ENV TARGET=$TARGET

COPY root/ /
RUN env-update && emerge-webrsync && \
  eselect profile set default/linux/amd64/17.1/no-multilib && \
  env-update && source /etc/profile

# Rebuilding glibc for applying patches.
RUN build.sh -v1 sys-libs/glibc

RUN mkdir "/usr/${TARGET}"
COPY crossdev-root/ "/usr/${TARGET}/"

RUN build.sh -v sys-devel/crossdev && \
  crossdev.sh -t "$TARGET" --stable && \
  rm -f "/usr/${TARGET}/etc/portage/make.profile" && \
  ln -s /usr/portage/profiles/default/linux/amd64/17.1/no-multilib "/usr/${TARGET}/etc/portage/make.profile" && \
  cd /usr/local/bin && \
    ln -s target-python3.7.sh target-python3.7 && \
    ln -s target-python3.7.sh target-python3 && \
    ln -s target-python3.7.sh target-python

RUN target-build.sh -v1 sys-devel/gcc sys-devel/binutils sys-libs/glibc sys-kernel/linux-headers
RUN target-build.sh -v1 \
  app-shells/bash app-arch/tar sys-devel/make sys-devel/patch \
  sys-apps/findutils sys-apps/grep sys-apps/gawk net-misc/wget

# TODO remove this workaround after https://github.com/gentoo/gentoo/pull/9822 will be merged
#   and https://bugs.gentoo.org/705970 will be fixed.
# Different libc (or libc with another version) requires double python recompilation.
RUN target-build.sh -v1 dev-lang/python:3.7 && \
  find "/usr/${TARGET}/lib64" -maxdepth 1 -name ld* \
    -exec cp "{}" /lib/ \; && \
  sed -i "s/export PYTHON=.*\${impl}/export PYTHON=target-\${impl}/g" \
    /usr/portage/eclass/python-utils-r1.eclass && \
  sed -i "s/\${EPYTHON:-python}/target-\${EPYTHON:-python}/g" \
    /usr/portage/eclass/distutils-r1.eclass && \
  sed -i "s/esetup.py install \(.*\)/esetup.py install \1 --prefix=\"\/usr\"/g" \
    /usr/portage/eclass/distutils-r1.eclass && \
  find /usr/portage/sys-apps/portage -maxdepth 1 -name portage-*.ebuild \
    -exec sed -i "s/\${sitedir}/\${sitedir#\${EROOT%\/}}/g" "{}" \; \
    -exec ebuild "{}" manifest \; && \
  EPYTHON_FOR_BUILD="target-python3.7" target-build.sh -v1 dev-lang/python:3.7
# TODO end of workaround

# It is not possible to use cross compiled sandbox with another libc
#   (or libc with another version) https://bugs.gentoo.org/706020.
RUN target-build.sh -v1 sys-apps/sandbox && \
  mv "/usr/${TARGET}/usr/lib/libsandbox.so" /tmp/libsandbox.so.bak && \
  target-build.sh -v1 sys-apps/portage && \
  mv /tmp/libsandbox.so.bak "/usr/${TARGET}/usr/lib/libsandbox.so"

# TODO remove this workaround after https://github.com/gentoo/gentoo/pull/9822 will be merged
#  and https://bugs.gentoo.org/705970 will be fixed.
RUN find "/usr/${TARGET}/usr/lib" \
  \( -path "*/python-exec/python3.7/*" -o -path "*/portage/python3.7/*" \) -type f \
  -exec sed -i "s/#\!\/usr\/${TARGET}\/usr\/bin\/python/#\!\/usr\/bin\/python/g" "{}" \;
# TODO end of workaround

# Removing all important portage configs.
RUN cd "/usr/${TARGET}/etc/portage" && \
  rm -f make.{conf,profile} && \
  rm -rf {env,patches,repos.conf} && \
  rm -rf package.{accept_keywords,env,license,mask,unmask,use}

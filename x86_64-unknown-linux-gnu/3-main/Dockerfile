ARG FROM_IMAGE
FROM $FROM_IMAGE

COPY root /

# Python recompilation is recommended, cross compiled version is not reliable.
RUN USE="internal-glib -berkdb -filecaps -nls" build.sh -v1 \
  dev-lang/python dev-util/pkgconf sys-libs/pam && \
  USE="-nls" build.sh -v1 dev-util/pkgconf && \
  \
  upgrade.sh \
    --exclude="sys-devel/gcc sys-devel/binutils sys-libs/glibc sys-kernel/linux-headers" && \
  build.sh -v1 sys-devel/gcc sys-devel/binutils sys-libs/glibc sys-kernel/linux-headers && \
  build.sh -ve @world \
    --exclude="sys-devel/gcc sys-devel/binutils sys-libs/glibc sys-kernel/linux-headers" && \
  \
  build.sh -v app-portage/gentoolkit sys-devel/clang && \
  upgrade.sh && cleanup.sh && \
  find /etc -maxdepth 1 -name "._cfg*" -delete && \
  eselect news read new

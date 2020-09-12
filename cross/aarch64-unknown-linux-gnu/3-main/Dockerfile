ARG FROM_IMAGE=aarch64-unknown-linux-gnu_base
FROM $FROM_IMAGE

COPY root /

# Python recompilation is recommended, cross compiled version is not reliable.
RUN USE="internal-glib -berkdb -filecaps -nls" build.sh -v1 \
  dev-lang/python:3.7 dev-util/pkgconfig sys-libs/pam && \
  USE="-nls" build.sh -v1 dev-util/pkgconfig

RUN upgrade.sh \
  --exclude="sys-devel/gcc sys-devel/binutils sys-libs/glibc sys-kernel/linux-headers"

RUN build.sh -v1 sys-devel/gcc sys-devel/binutils sys-libs/glibc sys-kernel/linux-headers
RUN build.sh -ve @world \
  --exclude="sys-devel/gcc sys-devel/binutils sys-libs/glibc sys-kernel/linux-headers"

RUN build.sh -v app-portage/gentoolkit sys-devel/clang

RUN upgrade.sh && cleanup.sh && \
  find /etc -maxdepth 1 -name "._cfg*" -delete && \
  eselect news read

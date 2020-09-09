ARG FROM_IMAGE=aarch64-gentoo-linux-musl_base
FROM $FROM_IMAGE

COPY root/ /

# Python recompilation is recommended, cross compiled version is not reliable.
RUN USE="-berkdb -nls" build.sh -v1 dev-lang/python:3.7 && \
  USE="-nls" build.sh -v1 dev-libs/elfutils && \
  USE="internal-glib -nls" build.sh -v1 dev-util/pkgconfig && \
  USE="-filecaps -nls" build.sh -v1 dev-util/pkgconfig sys-libs/pam

RUN upgrade.sh \
  --exclude="sys-devel/gcc sys-devel/binutils sys-libs/musl sys-kernel/linux-headers"

RUN build.sh -v1 sys-devel/gcc sys-devel/binutils sys-libs/musl sys-kernel/linux-headers
RUN build.sh -ve @world \
  --exclude="sys-devel/gcc sys-devel/binutils sys-libs/musl sys-kernel/linux-headers"

RUN build.sh -v app-portage/gentoolkit sys-devel/clang

RUN update.sh && upgrade.sh && cleanup.sh && \
  find /etc -maxdepth 1 -name "._cfg*" -delete && \
  eselect news read

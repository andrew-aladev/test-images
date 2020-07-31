ARG FROM_IMAGE=x86_64-gentoo-linux-musl_base
FROM $FROM_IMAGE

COPY root/ /

RUN upgrade.sh \
  --exclude="sys-devel/gcc sys-devel/binutils sys-libs/musl sys-kernel/linux-headers"

RUN build.sh -v1 sys-devel/gcc
RUN build.sh -v1 sys-devel/binutils
RUN build.sh -v1 sys-libs/musl
RUN build.sh -v1 sys-kernel/linux-headers

RUN build.sh -ve @world \
  --exclude="sys-devel/gcc sys-devel/binutils sys-libs/musl sys-kernel/linux-headers"

RUN build.sh -v clang

RUN update.sh
RUN upgrade.sh
RUN cleanup.sh

RUN find /etc -maxdepth 1 -name ._cfg* -delete
RUN eselect news read

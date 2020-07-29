ARG FROM_IMAGE=stage3-amd64-nomultilib
FROM $FROM_IMAGE

RUN rm -r /usr/share/{doc,man,info}

COPY root/ /
RUN env-update

RUN emerge-webrsync

RUN eselect profile set default/linux/amd64/17.1/no-multilib
RUN env-update && source /etc/profile

RUN build.sh -v1 sys-devel/gcc sys-devel/binutils sys-libs/glibc sys-kernel/linux-headers
RUN build.sh -ve @world \
  --exclude="sys-devel/gcc sys-devel/binutils sys-libs/glibc sys-kernel/linux-headers"
RUN build.sh -v app-portage/gentoolkit
RUN build.sh -v clang

RUN update.sh
RUN upgrade.sh
RUN cleanup.sh

RUN find /etc -maxdepth 1 -name ._cfg* -delete
RUN eselect news read

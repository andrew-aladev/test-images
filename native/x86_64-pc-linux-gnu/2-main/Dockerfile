ARG FROM_IMAGE=x86_64-pc-linux-gnu_base
FROM $FROM_IMAGE

COPY root/ /

# Several packages may depend on gawk, net-tools, shadow, texinfo and pam silently.
RUN USE="-berkdb -nls -filecaps" build.sh -v1 \
  sys-apps/gawk sys-apps/net-tools sys-apps/shadow sys-apps/texinfo sys-libs/pam && \
  USE="internal-glib" build.sh -v1 dev-util/pkgconfig && \
  USE="-nls" build.sh -v1 dev-util/pkgconfig

RUN upgrade.sh \
  --exclude="sys-devel/gcc sys-devel/binutils sys-libs/glibc sys-kernel/linux-headers"

RUN build.sh -v1 sys-devel/gcc sys-devel/binutils sys-libs/glibc sys-kernel/linux-headers
RUN build.sh -ve @world \
  --exclude="sys-devel/gcc sys-devel/binutils sys-libs/glibc sys-kernel/linux-headers"

RUN build.sh -v app-portage/gentoolkit sys-devel/clang

RUN update.sh && upgrade.sh && cleanup.sh && \
  find /etc -maxdepth 1 -name ._cfg* -delete && \
  eselect news read

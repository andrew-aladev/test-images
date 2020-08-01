ARG FROM_IMAGE=x86_64-gentoo-linux-musl_base
FROM $FROM_IMAGE

COPY root/ /

RUN USE="-nls" build.sh -v1 sys-apps/gawk sys-apps/net-tools

RUN USE="internal-glib" build.sh -v1 dev-util/pkgconfig
RUN USE="-berkdb -nls" build.sh -v1 dev-lang/perl
RUN build.sh -v1 dev-lang/perl
RUN USE="-nls" build.sh -v1 dev-util/pkgconfig
RUN build.sh -v1 dev-util/pkgconfig

RUN build.sh -v1 sys-apps/diffutils app-arch/gzip && \
  build.sh -v1 sys-apps/gawk sys-apps/net-tools && \
  USE="-filecaps" build.sh -v1 sys-libs/pam && \
  build.sh -v1 sys-libs/pam sys-apps/shadow && \
  build.sh -v sys-apps/portage

RUN upgrade.sh \
  --exclude="sys-devel/gcc sys-devel/binutils sys-libs/musl sys-kernel/linux-headers"

RUN build.sh -v1 sys-devel/gcc && \
  build.sh -v1 sys-devel/binutils && \
  build.sh -v1 sys-libs/musl && \
  build.sh -v1 sys-kernel/linux-headers

RUN build.sh -ve @world \
  --exclude="sys-devel/gcc sys-devel/binutils sys-libs/musl sys-kernel/linux-headers"

RUN build.sh -v app-portage/gentoolkit sys-devel/clang

RUN update.sh && upgrade.sh && cleanup.sh && \
  find /etc -maxdepth 1 -name ._cfg* -delete && \
  eselect news read

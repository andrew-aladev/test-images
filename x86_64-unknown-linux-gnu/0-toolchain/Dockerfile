ARG FROM_IMAGE
FROM $FROM_IMAGE

ARG TARGET
ENV TARGET=$TARGET

COPY root /
COPY prefix-root "/usr/${TARGET}"

RUN eselect profile set default/linux/amd64/17.1/no-multilib && \
  env-update && source /etc/profile && \
  build.sh -v sys-devel/crossdev && \
  crossdev.sh -t "$TARGET" && \
  rm -f "/usr/${TARGET}/etc/portage/make.profile" && \
  ln -s /var/db/repos/gentoo/profiles/default/linux/amd64/17.1/no-multilib \
    "/usr/${TARGET}/etc/portage/make.profile" && \
  USE="-python" target-build.sh -v1 \
    sys-devel/gcc sys-devel/binutils sys-libs/glibc sys-kernel/linux-headers && \
  target-build.sh -v1 \
    app-arch/tar app-shells/bash net-misc/wget sys-apps/findutils \
    sys-apps/gawk sys-apps/grep sys-apps/net-tools sys-apps/shadow \
    sys-devel/make sys-devel/patch && \
  target-cleanup.sh && cleanup.sh

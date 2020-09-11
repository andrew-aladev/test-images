ARG FROM_IMAGE=stage3-amd64-nomultilib
FROM $FROM_IMAGE

ARG PORTAGE_SNAPSHOT=latest
ARG TARGETS=x86_64-unknown-linux-gnu
ENV PORTAGE_SNAPSHOT=$PORTAGE_SNAPSHOT
ENV TARGETS=$TARGETS

COPY root/ /
RUN env-update && emerge-webrsync --revert="${PORTAGE_SNAPSHOT}" && \
  eselect profile set default/linux/amd64/17.1/no-multilib && \
  env-update && source /etc/profile

RUN build.sh -v sys-devel/crossdev
COPY crossdev-roots /usr

RUN for TARGET in $TARGETS; do \
  crossdev.sh -t "$TARGET" --stable && \
  rm -f "/usr/${TARGET}/etc/portage/make.profile"; \
done

RUN ln -s /usr/portage/profiles/default/linux/amd64/17.1/no-multilib /usr/x86_64-unknown-linux-gnu/etc/portage/make.profile && \
  ln -s /usr/portage/profiles/default/linux/x86/17.0 /usr/i686-unknown-linux-gnu/etc/portage/make.profile && \
  ln -s /usr/portage/profiles/default/linux/amd64/17.0/musl /usr/x86_64-gentoo-linux-musl/etc/portage/make.profile && \
  ln -s /usr/portage/profiles/default/linux/x86/17.0/musl /usr/i686-gentoo-linux-musl/etc/portage/make.profile && \
  ln -s /usr/portage/profiles/default/linux/arm64/17.0 /usr/aarch64-unknown-linux-gnu/etc/portage/make.profile && \
  ln -s /usr/portage/profiles/default/linux/arm64/17.0/big-endian /usr/aarch64_be-unknown-linux-gnu/etc/portage/make.profile && \
  ln -s /usr/portage/profiles/default/linux/arm64/17.0/musl /usr/aarch64-gentoo-linux-musl/etc/portage/make.profile && \
  ln -s /usr/portage/profiles/default/linux/arm64/17.0/musl /usr/aarch64_be-gentoo-linux-musl/etc/portage/make.profile

RUN for TARGET in $TARGETS; do \
  MAIN_PACKAGES=("sys-devel/gcc" "sys-devel/binutils" "sys-kernel/linux-headers"); \
  \
  if [[ "$TARGET" =~ gnu$ ]]; then \
    MAIN_PACKAGES+=("sys-libs/glibc"); \
  else \
    MAIN_PACKAGES+=("sys-libs/musl"); \
  fi; \
  \
  USE="-python" TARGET="$TARGET" target-build.sh -v1 "${MAIN_PACKAGES[@]}"; \
done

RUN for TARGET in $TARGETS; do \
  TARGET="$TARGET" target-build.sh -v1 \
    app-arch/tar app-shells/bash net-misc/wget sys-apps/findutils \
    sys-apps/gawk sys-apps/grep sys-apps/net-tools sys-apps/shadow \
    sys-devel/make sys-devel/patch dev-lang/python:3.7; \
done

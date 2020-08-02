FROM scratch

COPY attached_root/ /
COPY root/ /

RUN env-update && emerge-webrsync && \
  ln -s /usr/portage/profiles/default/linux/arm64/17.0 /etc/portage/make.profile && \
  echo "" > /var/lib/portage/world

RUN build.sh -v1 sys-apps/baselayout && \
  env-update && source /etc/profile

# All packages may depend on gzip and diffutils silently.
RUN USE="-nls" build.sh -v1 app-arch/gzip sys-apps/diffutils

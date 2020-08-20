FROM scratch

COPY attached_root/ /
COPY root/ /

RUN env-update && emerge-webrsync && \
  ln -s /usr/portage/profiles/default/linux/arm64/17.0/big-endian /etc/portage/make.profile && \
  echo "" > /var/lib/portage/world

RUN build.sh -v1 sys-apps/baselayout && \
  env-update && source /etc/profile

# All packages may depend on gzip and diffutils silently.
RUN USE="-nls" build.sh -v1 app-arch/gzip sys-apps/diffutils && \
  locale-gen

# TODO remove this workaround after https://github.com/gentoo/gentoo/pull/9822 will be merged.
RUN PYTHON_TARGETS="python3_7" USE="-nls" build.sh -v1 dev-lang/python-exec sys-apps/portage
# TODO end of workaround

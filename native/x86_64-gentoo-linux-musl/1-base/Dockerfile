FROM scratch

COPY attached_root/ /
COPY root/ /

RUN env-update && emerge-webrsync && \
  ln -s /usr/portage/profiles/default/linux/amd64/17.0/musl /etc/portage/make.profile && \
  echo "" > /var/lib/portage/world

RUN build.sh -v1 sys-apps/baselayout && \
  env-update && source /etc/profile

# All packages may depend on gzip and diffutils silently.
# Several packages may depend on gawk, net-tools, shadow, texinfo and pam silently.
RUN USE="-nls" build.sh -v1 app-arch/gzip sys-apps/diffutils && \
  USE="-nls" build.sh -v1 sys-apps/gawk sys-apps/net-tools sys-apps/shadow sys-apps/texinfo sys-libs/pam

# TODO remove this workaround after https://github.com/gentoo/gentoo/pull/9822 will be merged
#  and https://bugs.gentoo.org/705970 will be fixed.
RUN PYTHON_TARGETS="python3_7" build.sh -v1 dev-lang/python-exec sys-apps/portage
# TODO end of workaround

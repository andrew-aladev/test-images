FROM scratch

COPY attached_directory/ /
COPY root/ /
RUN env-update

RUN emerge-webrsync

RUN ln -s /usr/portage/profiles/default/linux/amd64/17.0/musl /etc/portage/make.profile && \
  echo "" > /var/lib/portage/world

RUN USE="-nls" build.sh -v1 sys-apps/diffutils
RUN build.sh -v1 sys-apps/baselayout
RUN env-update && source /etc/profile

RUN build.sh -v1 app-arch/gzip

# TODO remove this workaround after https://github.com/gentoo/gentoo/pull/9822 will be merged
#  and https://bugs.gentoo.org/705970 will be fixed.
RUN PYTHON_TARGETS="python3_7" build.sh -v1 dev-lang/python-exec sys-apps/portage
# TODO end of workaround

RUN USE="-nls" build.sh -v1 sys-apps/gawk sys-apps/net-tools

RUN USE="internal-glib" build.sh -v1 dev-util/pkgconfig
RUN USE="-berkdb -nls" build.sh -v1 dev-lang/perl
RUN build.sh -v1 dev-lang/perl
RUN USE="-nls" build.sh -v1 dev-util/pkgconfig
RUN build.sh -v1 dev-util/pkgconfig

RUN build.sh -v1 sys-apps/diffutils app-arch/gzip
RUN build.sh -v1 sys-apps/gawk sys-apps/net-tools

RUN USE="-filecaps" build.sh -v1 sys-libs/pam
RUN build.sh -v1 sys-libs/pam sys-apps/shadow

RUN build.sh -v sys-apps/portage app-portage/gentoolkit

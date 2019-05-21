FROM gentoo/stage3-amd64-nomultilib:latest
MAINTAINER Andrew Aladjev <andrew.aladev@hiqo-solutions.com>

RUN rm -r /usr/share/{doc,man,info}

COPY root /

RUN chown -R portage:portage /usr/portage && emerge-webrsync

RUN eselect profile set default/linux/amd64/17.0/no-multilib && \
  source /etc/profile && env-update

RUN emerge -v1 sys-devel/gcc
RUN emerge -v1 sys-devel/binutils sys-libs/binutils-libs
RUN emerge -v1 sys-libs/glibc && \
  source /etc/profile && env-update

RUN emerge -ve @world

RUN emerge -v app-admin/sudo app-portage/gentoolkit app-portage/smart-live-rebuild

RUN update && upgrade && cleanup

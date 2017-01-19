FROM gentoo/stage3-amd64-hardened:latest
MAINTAINER Andrew Aladjev <andrew.aladev@hiqo-solutions.com>

RUN rm -r /usr/share/{doc,man,info}

COPY root /

RUN chown -R portage:portage /usr/portage \
  && emerge-webrsync

RUN eselect profile set hardened/linux/amd64/no-multilib \
  && env-update && source /etc/profile

RUN emerge -v1 sys-devel/gcc
RUN emerge -v1 sys-devel/binutils
RUN emerge -v1 sys-libs/glibc \
  && env-update && source /etc/profile

RUN emerge -ve @world

RUN emerge -v sudo app-portage/gentoolkit smart-live-rebuild

RUN update && upgrade && cleanup

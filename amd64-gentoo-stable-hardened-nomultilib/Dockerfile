FROM gentoo/stage3-amd64-hardened:latest
MAINTAINER Andrew Aladjev <andrew.aladev@hiqo-solutions.com>

RUN rm -r /usr/share/{doc,man,info}

COPY etc /etc
COPY usr /usr

RUN chown -R portage:portage /usr/portage
RUN emerge-webrsync

RUN eselect profile set hardened/linux/amd64/no-multilib
RUN env-update && source /etc/profile

RUN emerge -v1 sys-devel/gcc
RUN emerge -v1 sys-devel/binutils
RUN emerge -v1 sys-libs/glibc
RUN env-update && source /etc/profile

RUN emerge -ve @world

RUN emerge -v sudo app-portage/gentoolkit smart-live-rebuild
RUN cleanup

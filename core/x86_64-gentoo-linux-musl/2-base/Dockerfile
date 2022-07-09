ARG FROM_IMAGE_PREFIX
FROM $FROM_IMAGE_PREFIX AS prefix

ARG TARGET
ENV TARGET=$TARGET

# TODO use target env when copy will support variables expansion.
FROM scratch
COPY --from=prefix /usr/x86_64-gentoo-linux-musl/ /
COPY root /

RUN env-update && \
  python3 -c "import lib2to3.pygram" && \
  eselect profile set default/linux/amd64/17.0/musl && \
  echo "" > /var/lib/portage/world && \
  build.sh -v1 sys-apps/baselayout app-arch/gzip && \
  env-update && source /etc/profile

# TODO diffutils (without docs) requires makeinfo with no reason.
# We can stub makeinfo temporaly.
RUN cd /bin && \
  ln -s true makeinfo && \
  USE="-nls" build.sh -v1 sys-apps/diffutils

# TODO remove this workaround after https://github.com/gentoo/gentoo/pull/9822 will be merged
#  and https://bugs.gentoo.org/705970 will be fixed.
RUN PYTHON_TARGETS="python3_10" USE="-nls -rsync-verify" build.sh -v1 \
  dev-lang/python-exec sys-apps/portage
# TODO end of workaround

# TODO unstub makeinfo
RUN rm /bin/makeinfo

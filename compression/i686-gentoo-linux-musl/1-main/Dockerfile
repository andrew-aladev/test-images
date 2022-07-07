ARG FROM_IMAGE
FROM $FROM_IMAGE

COPY root /

# TODO https://bugs.gentoo.org/835038
RUN sed -i 's/use elibc_musl/[false]/' /var/db/repos/gentoo/dev-lang/ruby/ruby-3.1.*.ebuild && \
  find /var/db/repos/gentoo/dev-lang/ruby/ruby-3.1.*.ebuild -exec ebuild {} manifest \;

RUN build.sh -v \
  app-portage/eix \
  dev-vcs/git \
  dev-util/cmake \
  dev-libs/gmp dev-libs/libtommath \
  app-arch/brotli app-arch/bzip2 app-arch/ncompress app-arch/zstd \
  dev-lang/ruby:2.6 dev-lang/ruby:2.7 dev-lang/ruby:3.0 dev-lang/ruby:3.1 virtual/rubygems && \
  cleanup.sh

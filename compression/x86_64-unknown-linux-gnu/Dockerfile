ARG FROM_IMAGE
FROM $FROM_IMAGE

COPY root /

RUN build.sh -v \
  dev-vcs/git \
  dev-util/cmake \
  dev-libs/gmp dev-libs/libtommath app-arch/ncompress \
  app-arch/brotli \
  app-arch/zstd \
  dev-lang/ruby:2.6 dev-lang/ruby:2.7 dev-lang/ruby:3.0 dev-lang/ruby:3.1 virtual/rubygems && \
  app-portage/eix && \
  cleanup.sh

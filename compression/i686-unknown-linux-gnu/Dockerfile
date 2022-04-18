ARG FROM_IMAGE
FROM $FROM_IMAGE

COPY root /
RUN build.sh -v \
  app-portage/eix dev-vcs/git dev-util/cmake \
  app-arch/brotli app-arch/ncompress app-arch/zstd dev-libs/gmp dev-libs/libtommath \
  dev-lang/ruby:2.6 dev-lang/ruby:2.7 dev-lang/ruby:3.0 dev-lang/ruby:3.1 \
  virtual/rubygems && \
  cleanup.sh

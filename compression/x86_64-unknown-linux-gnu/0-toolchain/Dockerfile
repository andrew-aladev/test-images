ARG FROM_IMAGE
FROM $FROM_IMAGE

ARG TARGET
ENV TARGET=$TARGET

COPY prefix-root "/usr/${TARGET}"
COPY root /

RUN build.sh -v \
  app-portage/eix \
  dev-vcs/git \
  dev-util/cmake \
  dev-lang/ruby:2.6 dev-lang/ruby:2.7 dev-lang/ruby:3.0 dev-lang/ruby:3.1 virtual/rubygems && \
  \
  target-build.sh -v \
  dev-libs/gmp dev-libs/libtommath \
  app-arch/brotli app-arch/ncompress app-arch/zstd && \
  \
  target-cleanup.sh && cleanup.sh

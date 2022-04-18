ARG FROM_IMAGE
FROM $FROM_IMAGE

ARG TARGET
ENV TARGET=$TARGET

COPY prefix-root "/usr/${TARGET}"

RUN build.sh -v dev-vcs/git dev-util/cmake && \
  \
  target-build.sh -v \
    dev-libs/gmp dev-libs/libtommath \
    app-arch/brotli app-arch/ncompress app-arch/zstd && \
  \
  target-cleanup.sh && cleanup.sh

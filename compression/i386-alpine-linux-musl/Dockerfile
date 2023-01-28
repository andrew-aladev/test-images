ARG FROM_IMAGE
FROM $FROM_IMAGE

RUN apk add --no-cache \
  brotli-dev bzip2-dev cmake git gmp-dev libtommath-dev ruby rubygems zstd-dev && \
  git clone https://github.com/vapier/ncompress.git && cd ncompress && make install

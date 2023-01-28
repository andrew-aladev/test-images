ARG FROM_IMAGE
FROM $FROM_IMAGE

RUN apk add --no-cache \
  brotli-dev bzip2-dev cmake git gmp-dev ruby rubygems zstd-dev && \
  apk add --no-cache libtommath-dev --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/ && \
  git clone https://github.com/vapier/ncompress.git && cd ncompress && make install

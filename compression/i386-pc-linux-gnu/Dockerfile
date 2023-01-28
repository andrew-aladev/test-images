ARG FROM_IMAGE
FROM $FROM_IMAGE

RUN apt-get -y install \
  cmake git libbrotli-dev libbz2-dev libgmp-dev libtommath-dev libzstd-dev ruby rubygems && \
  git clone https://github.com/vapier/ncompress.git && cd ncompress && make install

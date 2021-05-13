ARG FROM_IMAGE
FROM $FROM_IMAGE as portage

ARG PORTAGE_URL
ARG PORTAGE_KEY
ENV PORTAGE_URL=$PORTAGE_URL
ENV PORTAGE_KEY=$PORTAGE_KEY

WORKDIR /data

RUN apk add --no-cache ca-certificates coreutils gnupg tar wget xz && \
  wget -q "$PORTAGE_URL" "${PORTAGE_URL}.gpgsig" "${PORTAGE_URL}.md5sum" && \
  gpg --keyserver "hkps://keys.gentoo.org" --recv-keys "$PORTAGE_KEY" && \
  PORTAGE_SNAPSHOT=$(basename "$PORTAGE_URL") && \
  gpg --verify "${PORTAGE_SNAPSHOT}.gpgsig" "$PORTAGE_SNAPSHOT" && \
  md5sum -c "${PORTAGE_SNAPSHOT}.md5sum" && \
  mkdir -p "var/db/repos/gentoo" && \
  tar xpf "$PORTAGE_SNAPSHOT" -C "var/db/repos/gentoo" --strip-components 1 && \
  rm "$PORTAGE_SNAPSHOT" "${PORTAGE_SNAPSHOT}.gpgsig" "${PORTAGE_SNAPSHOT}.md5sum"

FROM scratch

WORKDIR /
COPY --from=portage /data/ /
VOLUME /var/db/repos/gentoo

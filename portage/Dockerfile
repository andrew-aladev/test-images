ARG FROM_IMAGE_PROCESSOR
ARG FROM_IMAGE
FROM $FROM_IMAGE_PROCESSOR as processor

ARG PORTAGE_URL
ARG SIGN_KEY
ENV PORTAGE_URL=$PORTAGE_URL
ENV SIGN_KEY=$SIGN_KEY

WORKDIR /data

RUN apk add --no-cache ca-certificates coreutils gnupg tar wget xz && \
  wget -q "$PORTAGE_URL" "${PORTAGE_URL}.gpgsig" "${PORTAGE_URL}.md5sum" && \
  gpg --keyserver "hkps://keys.gentoo.org" --recv-keys "$SIGN_KEY" && \
  PORTAGE_SNAPSHOT=$(basename "$PORTAGE_URL") && \
  gpg --verify "${PORTAGE_SNAPSHOT}.gpgsig" "$PORTAGE_SNAPSHOT" && \
  md5sum -c "${PORTAGE_SNAPSHOT}.md5sum" && \
  mkdir -p "var/cache/binpkgs" "var/cache/distfiles" "var/db/repos/gentoo" && \
  tar xpf "$PORTAGE_SNAPSHOT" --xattrs-include="*.*" --numeric-owner \
    --strip-components 1 -C "var/db/repos/gentoo" && \
  rm "$PORTAGE_SNAPSHOT" "${PORTAGE_SNAPSHOT}.gpgsig" "${PORTAGE_SNAPSHOT}.md5sum"

FROM $FROM_IMAGE

WORKDIR /

COPY --from=processor /data/ /
CMD ["/bin/true"]

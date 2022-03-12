ARG FROM_IMAGE_PROCESSOR
ARG FROM_IMAGE
FROM $FROM_IMAGE_PROCESSOR AS processor

ARG PORTAGE_URL
ARG SIGN_KEY
ENV PORTAGE_URL=$PORTAGE_URL
ENV SIGN_KEY=$SIGN_KEY

WORKDIR /data
RUN apk add --no-cache ca-certificates coreutils gnupg tar wget xz && \
  mkdir -p ~/.gnupg && \
  echo "no-use-tor" | tee ~/.gnupg/dirmngr.conf > /dev/null && \
  chmod -R 0600 ~/.gnupg && \
  wget -q "$PORTAGE_URL" "${PORTAGE_URL}.gpgsig" "${PORTAGE_URL}.md5sum" && \
  gpg --keyserver "hkps://keys.gentoo.org" --recv-keys "$SIGN_KEY" && \
  PORTAGE_SNAPSHOT=$(basename "$PORTAGE_URL") && \
  gpg --verify "${PORTAGE_SNAPSHOT}.gpgsig" "$PORTAGE_SNAPSHOT" && \
  md5sum -c "${PORTAGE_SNAPSHOT}.md5sum" && \
  mkdir -p "./var/db/repos/gentoo" && \
  tar xpf "$PORTAGE_SNAPSHOT" --xattrs-include="*.*" --numeric-owner \
    --strip-components 1 -C "./var/db/repos/gentoo" && \
  chown -R 250:250 "./var/db/repos/gentoo" && \
  rm "$PORTAGE_SNAPSHOT" "${PORTAGE_SNAPSHOT}.gpgsig" "${PORTAGE_SNAPSHOT}.md5sum"

FROM $FROM_IMAGE
COPY --from=processor /data/ /

CMD ["/bin/true"]

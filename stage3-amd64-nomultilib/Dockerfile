ARG FROM_IMAGE_PROCESSOR
FROM $FROM_IMAGE_PROCESSOR AS processor

ARG AUTOBUILDS_URL
ARG SIGN_KEY
ENV AUTOBUILDS_URL=$AUTOBUILDS_URL
ENV SIGN_KEY=$SIGN_KEY

WORKDIR /data
RUN apk add --no-cache ca-certificates coreutils gnupg tar wget xz && \
  STAGE3_PATH=$(wget -O- "${AUTOBUILDS_URL}/latest-stage3-amd64-nomultilib.txt" \
    | tail -n 1 | cut -f 1 -d " ") && \
  STAGE3_NAME=$(basename "$STAGE3_PATH") && \
  wget -q "${AUTOBUILDS_URL}/${STAGE3_PATH}" \
    "${AUTOBUILDS_URL}/${STAGE3_PATH}.CONTENTS.gz" \
    "${AUTOBUILDS_URL}/${STAGE3_PATH}.DIGESTS.asc" && \
  gpg --keyserver "hkps://keys.gentoo.org" --recv-keys "$SIGN_KEY" && \
  gpg --verify "${STAGE3_NAME}.DIGESTS.asc" && \
  awk "/# SHA512 HASH/{getline; print}" "${STAGE3_NAME}.DIGESTS.asc" | sha512sum -c && \
  tar xpf "$STAGE3_NAME" --xattrs-include="*.*" --numeric-owner \
    --exclude="./boot/*" --exclude="./dev/*" \
    --exclude="./media/*" --exclude="./mnt/*" \
    --exclude="./proc/*" --exclude="./run/*" \
    --exclude="./sys/*" --exclude="./tmp/*" && \
  (sed -i -e 's/#rc_sys=""/rc_sys="docker"/g' "./etc/rc.conf" 2>/dev/null || :) && \
  echo "UTC" > "./etc/timezone" && \
  rm -rf "./var/db/repos/gentoo" && \
  rm "${STAGE3_NAME}" "${STAGE3_NAME}.CONTENTS.gz" "${STAGE3_NAME}.DIGESTS.asc"

FROM scratch
COPY --from=processor /data/ /

CMD ["/bin/bash"]

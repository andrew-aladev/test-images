#!/bin/bash
set -e

XDG_RUNTIME_DIR="/tmp/buildah-runtime"
mkdir -p "$XDG_RUNTIME_DIR"

tool () {
  XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" buildah "$@"
}

# -----

from () {
  tool from "$1"
}

mount () {
  tool unshare -- sh -c "buildah mount $1"
}

unmount () {
  tool unshare -- sh -c "buildah unmount $1"
}

copy () {
  tool copy "$1" "$2" "$3"
}

remove () {
  tool rm "$1"
}

attach () {
  container=$(from "$FROM_IMAGE")

  (
    container_root=$(mount "$container")
    mkdir "attached_root"
    bindfs -r "${container_root}$1" "attached_root"
  ) || error=$?

  if [ ! -z "$error" ]; then
    detach "$container"
    exit "$error"
  fi

  echo "$container"
}

detach () {
  fusermount -zu "attached_root" || true
  rmdir "attached_root" || true

  unmount "$1" || true
  remove "$1" || true
}

build () {
  ARGS=${BUILD_ARGS:-"FROM_IMAGE"}

  args=()

  for arg in $ARGS; do
    args+=(--build-arg ${arg}="${!arg}")
  done

  tool bud \
    "${args[@]}" \
    --tag "$IMAGE_NAME" \
    --platform="$IMAGE_PLATFORM" \
    --label maintainer="$MAINTAINER" \
    --cap-add=CAP_SYS_PTRACE \
    --cap-add=CAP_SETFCAP \
    --isolation="rootless" \
    --layers \
    "."
}

push () {
  docker_image_name="docker://docker.io/${DOCKER_USERNAME}/${IMAGE_NAME}"

  logged_docker_username=$(tool login --get-login "docker.io" || :)
  if [ "$logged_docker_username" != "$DOCKER_USERNAME" ]; then
    tool login --username "$DOCKER_USERNAME" "docker.io"
  fi

  tool push "$IMAGE_NAME" "$docker_image_name"
}

pull () {
  docker_image_name="docker://docker.io/${DOCKER_USERNAME}/${IMAGE_NAME}"

  tool pull "$docker_image_name"
  tool tag "$docker_image_name" "$IMAGE_NAME"
}

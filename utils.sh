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
  tool mount "$1"
}

unmount () {
  tool unmount "$1"
}

copy () {
  tool copy "$1" "$2" "$3"
}

remove () {
  tool rm "$1"
}

attach () {
  container=$(from "$FROM_IMAGE_NAME")

  (
    container_root=$(mount "$container")
    mkdir "attached_directory"
    copy "$container" "${container_root}$1/" "attached_directory/"
  ) || error=$?

  unmount "$container" || true
  remove "$container" || true

  if [ ! -z "$error" ]; then
    exit "$error"
  fi
}

detach () {
  rm -r "attached_directory" || true
}

build () {
  build_args=(--build-arg FROM_IMAGE="${FROM_IMAGE}")

  for build_arg in $BUILD_ARGS; do
    build_args+=(--build-arg ${build_arg}="${!build_arg}")
  done

  tool bud \
    "${build_args[@]}" \
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

#!/bin/bash

XDG_RUNTIME_DIR="/tmp/buildah-user"
mkdir -p "$XDG_RUNTIME_DIR"

quote_args () {
  for arg in "$@"; do
    printf " %q" "$arg"
  done
}

tool () {
  command=$(quote_args "$@")
  XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" eval buildah "$command"
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
  source="$1"
  destination="$2"

  tool copy "$CONTAINER" "$source" "$destination"
}

build () {
  build_args="--build-arg FROM_IMAGE=$FROM_IMAGE"

  for more_arg in $MORE_ARGS; do
    build_args+=" --build-arg ${more_arg}=${!more_arg}"
  done

  tool bud \
    $build_args \
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

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
  container="${3:-${CONTAINER}}"

  tool copy "$container" "$source" "$destination"
}

build () {
  from_image="${1:-${FROM_IMAGE}}"
  image_name="${2:-${IMAGE_NAME}}"
  image_platform="${3:-${IMAGE_PLATFORM}}"
  maintainer="${4:-${MAINTAINER}}"

  tool bud \
    --build-arg FROM_IMAGE="$from_image" \
    --tag "$image_name" \
    --platform="$image_platform" \
    --label maintainer="$maintainer" \
    --cap-add=CAP_SYS_PTRACE \
    --cap-add=CAP_SETFCAP \
    --isolation="rootless" \
    --layers \
    "."
}

push () {
  image_name="${1:-${IMAGE_NAME}}"
  docker_username="${2:-${DOCKER_USERNAME}}"
  docker_image_name="docker://docker.io/${docker_username}/${image_name}"

  logged_docker_username=$(tool login --get-login "docker.io" || :)
  if [ "$logged_docker_username" != "$docker_username" ]; then
    tool login --username "$docker_username" "docker.io"
  fi

  tool push "$image_name" "$docker_image_name"
}

pull () {
  image_name="${1:-${IMAGE_NAME}}"
  docker_username="${2:-${DOCKER_USERNAME}}"
  docker_image_name="docker://docker.io/${docker_username}/${image_name}"

  tool pull "$docker_image_name"
  tool tag "$docker_image_name" "$image_name"
}

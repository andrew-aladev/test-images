#!/usr/bin/env bash
set -e

XDG_RUNTIME_DIR="/tmp/buildah-runtime"
mkdir -p "$XDG_RUNTIME_DIR"

tool () {
  XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" buildah "$@"
}

# -- wrappers --

bud () {
  tool bud \
    --cap-add=CAP_SETFCAP \
    --cap-add=CAP_SYS_PTRACE \
    --security-opt="seccomp=unconfined" \
    --isolation="rootless" \
    "$@"
}

from () {
  tool from \
    --cap-add=CAP_SETFCAP \
    --cap-add=CAP_SYS_PTRACE \
    --security-opt="seccomp=unconfined" \
    --isolation="rootless" \
    "$1"
}

mount () {
  tool unshare -- sh -c "buildah mount $1"
}

unmount () {
  tool unshare -- sh -c "buildah unmount $1"
}

remove () {
  tool rm "$1"
}

# -- utils --

build () {
  args=()

  for arg_name in $1; do
    args+=(--build-arg ${arg_name}="${!arg_name}")
  done

  shift 1

  # Layers are enabled by default.
  layers=${IMAGE_LAYERS:-"true"}

  bud \
    "${args[@]}" \
    --tag "$IMAGE_NAME" \
    --platform="$IMAGE_PLATFORM" \
    --label maintainer="$MAINTAINER" \
    --layers="$layers" \
    "$@" \
    "."
}

push () {
  docker_image_name="docker://${DOCKER_HOST}/${DOCKER_USERNAME}/${IMAGE_NAME}"

  logged_docker_username=$(tool login --get-login "$DOCKER_HOST" || :)
  if [ "$logged_docker_username" != "$DOCKER_USERNAME" ]; then
    tool login --username "$DOCKER_USERNAME" "$DOCKER_HOST"
  fi

  tool push "$IMAGE_NAME" "$docker_image_name"
}

pull () {
  docker_image_name="docker://${DOCKER_HOST}/${DOCKER_USERNAME}/${IMAGE_NAME}"

  tool pull "$docker_image_name"
  tool tag "$docker_image_name" "$IMAGE_NAME"
}

attach () {
  image_name="$1"
  container_path="$2"
  target_directory=${3:-"attached-root"}

  container=$(from "$image_name")

  (
    container_root=$(mount "$container")
    fusermount -zu "$target_directory" || true
    bindfs "${container_root}${container_path}" "$target_directory"
  ) || error=$?

  if [ ! -z "$error" ]; then
    detach "$container" "$target_directory"
    exit "$error"
  fi

  echo "$container"
}

detach () {
  container="$1"
  target_directory=${2:-"attached-root"}

  fusermount -zu "$target_directory" || true

  unmount "$container" || true
  remove "$container" || true
}

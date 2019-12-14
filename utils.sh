#!/bin/bash

CPU_COUNT=$(grep -c "^processor" "/proc/cpuinfo")
MAKEOPTS="-j$CPU_COUNT"

copy () {
  buildah copy "$CONTAINER" $@
}

run () {
  command="$@"
  buildah run "$CONTAINER" -- sh -c "$command"
}

build () {
  command="MAKEOPTS=\"$MAKEOPTS\" $@"
  buildah run --cap-add=CAP_SYS_PTRACE "$CONTAINER" -- sh -c "$command"
}

commit () {
  buildah commit --format docker "$CONTAINER" "$IMAGE_NAME"

  DOCKER_IMAGE_NAME="docker://docker.io/$DOCKER_USERNAME/$IMAGE_NAME"
  buildah tag "$IMAGE_NAME" "$DOCKER_IMAGE_NAME"
}

docker_push () {
  docker login --username "$DOCKER_USERNAME"

  DOCKER_IMAGE_NAME="docker://docker.io/$DOCKER_USERNAME/$IMAGE_NAME"
  buildah push "$IMAGE_NAME" "$DOCKER_IMAGE_NAME"
}

docker_pull () {
  DOCKER_IMAGE_NAME="docker://docker.io/$DOCKER_USERNAME/$IMAGE_NAME"
  buildah pull "$DOCKER_IMAGE_NAME"
  buildah tag "$DOCKER_IMAGE_NAME" "$IMAGE_NAME"
}

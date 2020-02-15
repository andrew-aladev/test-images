#!/bin/bash

MAINTAINER="Andrew Aladjev <andrew.aladev@hiqo-solutions.com>"
IMAGE_PREFIX="test"
DOCKER_USERNAME="puchuu"

# https://github.com/containers/buildah/issues/2165
XDG_RUNTIME_DIR="/tmp/buildah-user"
mkdir -p "$XDG_RUNTIME_DIR"

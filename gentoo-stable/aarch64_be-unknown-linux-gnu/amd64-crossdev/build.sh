#!/bin/bash
set -e

cd "$(dirname $0)"

DOCKER_USERNAME="puchuu" \
MAINTAINER="Andrew Aladjev <andrew.aladev@hiqo-solutions.com>" \
  sudo -E ./buildah.sh

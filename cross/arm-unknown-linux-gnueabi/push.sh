#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

source "../../utils.sh"
source "./2-rebuild/env.sh"

docker_push

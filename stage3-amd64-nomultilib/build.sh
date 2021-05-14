#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

source "../utils.sh"
source "./env.sh"

build "FROM_IMAGE_PROCESSOR AUTOBUILDS_URL SIGN_KEY"

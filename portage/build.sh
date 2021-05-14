#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

source "../utils.sh"
source "./env.sh"

build "FROM_IMAGE_PROCESSOR FROM_IMAGE PORTAGE_URL SIGN_KEY"
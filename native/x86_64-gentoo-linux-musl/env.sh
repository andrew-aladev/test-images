#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
source "${DIR}/../../env.sh"

TARGET="x86_64-gentoo-linux-musl"

REBUILD_DATE=$(< "${DIR}/.rebuild_date") || :

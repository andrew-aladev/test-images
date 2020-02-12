#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
source "${DIR}/../../env.sh"

TARGET="armeb-unknown-linux-gnueabi"

REBUILD_DATE=$(< "${DIR}/.rebuild_date") || :

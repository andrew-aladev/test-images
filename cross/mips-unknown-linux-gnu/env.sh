#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
source "${DIR}/../../env.sh"

TARGET="mips-unknown-linux-gnu"

REBUILD_DATE=$(< "${DIR}/.rebuild_date") || :

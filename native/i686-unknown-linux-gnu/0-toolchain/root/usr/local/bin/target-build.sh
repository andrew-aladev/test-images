#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
source "${DIR}/target-env.sh"
source "/etc/profile.d/makeopts.sh"

"${TARGET}-emerge" "$@"

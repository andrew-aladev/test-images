#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
source "${DIR}/target-env.sh"

"${TARGET}-emerge" --depclean
rm -rf "/usr/${TARGET}/var/tmp/portage/"{*,.*} || :
rm -rf "/usr/${TARGET}/tmp/portage/"{*,.*} || :

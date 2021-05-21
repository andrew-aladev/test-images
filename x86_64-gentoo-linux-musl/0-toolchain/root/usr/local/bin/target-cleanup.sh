#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
source "${DIR}/target-env.sh"

rm -rf "/usr/${TARGET}/var/cache/distfiles/"{*,.*} || :
rm -rf "/usr/${TARGET}/var/tmp/portage/"{*,.*} || :
rm -rf "/usr/${TARGET}/tmp/portage/"{*,.*} || :
truncate --size 0 "/usr/${TARGET}/var/log/emerge.log" || :

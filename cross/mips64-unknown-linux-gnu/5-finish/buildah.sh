#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

source "../../../utils.sh"
source "./env.sh"

check_up_to_date

CONTAINER=$(from "$FROM_IMAGE_NAME")
config --arch="mips64"

copy root/ /

build emerge -v clang

run update
build upgrade
run cleanup

run find /etc -maxdepth 1 -name ._cfg* -delete
run eselect news read

commit

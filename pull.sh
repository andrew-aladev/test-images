#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

./portage/pull.sh
./stage3-amd64-nomultilib/pull.sh

./x86_64-unknown-linux-gnu/pull.sh
./i686-unknown-linux-gnu/pull.sh

# ./x86_64-gentoo-linux-musl/pull.sh
# ./i686-gentoo-linux-musl/pull.sh

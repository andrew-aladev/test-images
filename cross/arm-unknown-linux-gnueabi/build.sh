#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

./0-amd64-crossdev/build.sh
./1-base/build.sh
./2-upgrade/build.sh
./3-toolchain/build.sh
./4-rebuild/build.sh
./5-finish/build.sh

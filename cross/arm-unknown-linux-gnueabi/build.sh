#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

./0-amd64-crossdev/build.sh
./1-base/build.sh
./2-toolchain/build.sh
./3-rebuild/build.sh
./4-finish/build.sh

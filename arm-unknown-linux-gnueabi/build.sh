#!/bin/bash
set -e

cd "$(dirname $0)"

./0-i686-crossdev/build.sh
./1-base/build.sh
./2-toolchain/build.sh
./3-world/build.sh
./4-finish/build.sh

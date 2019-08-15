#!/bin/bash
set -e

cd "$(dirname $0)"

./amd64-crossdev/build.sh
./base/build.sh
./toolchain/build.sh
./world/build.sh

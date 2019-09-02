#!/bin/bash
set -e

cd "$(dirname $0)"

./amd64-pc-linux-gnu/build.sh
./i686-pc-linux-gnu/build.sh
./aarch64-unknown-linux-gnu/build.sh
./aarch64_be-unknown-linux-gnu/build.sh
./arm-unknown-linux-gnueabi/build.sh

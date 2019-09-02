#!/bin/bash
set -e

cd "$(dirname $0)"

./amd64-pc-linux-gnu/pull.sh
./i686-pc-linux-gnu/pull.sh
./aarch64-unknown-linux-gnu/pull.sh
./aarch64_be-unknown-linux-gnu/pull.sh
./arm-unknown-linux-gnueabi/pull.sh

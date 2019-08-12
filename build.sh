#!/bin/bash
set -e

cd "$(dirname $0)"

./amd64-pc-linux-gnu/build_and_push.sh
./i686-pc-linux-gnu/build_and_push.sh
./aarch64-unknown-linux-gnu/build_and_push.sh

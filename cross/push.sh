#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

./aarch64-unknown-linux-gnu/push.sh
./aarch64_be-unknown-linux-gnu/push.sh

./arm-unknown-linux-gnu/push.sh
./armeb-unknown-linux-gnu/push.sh

./mips64-unknown-linux-gnu/push.sh
./mips64el-unknown-linux-gnu/push.sh

./mips-unknown-linux-gnu/push.sh
./mipsel-unknown-linux-gnu/push.sh

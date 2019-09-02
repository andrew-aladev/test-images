#!/bin/bash
set -e

cd "$(dirname $0)"

./amd64-pc-linux-gnu/push.sh
./i686-pc-linux-gnu/push.sh
./aarch64-unknown-linux-gnu/push.sh
./aarch64_be-unknown-linux-gnu/push.sh
./arm-unknown-linux-gnueabi/push.sh

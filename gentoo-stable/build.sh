#!/bin/bash
set -e

cd "$(dirname $0)"

./amd64-nomultilib/build.sh
./aarch64-unknown-linux-gnu/build.sh
./aarch64_be-unknown-linux-gnu/build.sh

#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

./1-crossdev/build.sh
./2-base/build.sh
./3-main/build.sh

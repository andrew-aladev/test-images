#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

./0-toolchain/pull.sh
./3-main/pull.sh

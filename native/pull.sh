#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

./x86_64-pc-linux-gnu/pull.sh
./i686-pc-linux-gnu/pull.sh

./x86_64-pc-linux-musl/pull.sh
./i686-pc-linux-musl/pull.sh

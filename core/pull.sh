#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

./x86_64-pc-linux-gnu/pull.sh
./i386-pc-linux-gnu/pull.sh

./x86_64-alpine-linux-musl/pull.sh
./i386-alpine-linux-musl/pull.sh

#!/bin/bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

./amd64-pc-linux-gnu/pull.sh
./i686-pc-linux-gnu/pull.sh

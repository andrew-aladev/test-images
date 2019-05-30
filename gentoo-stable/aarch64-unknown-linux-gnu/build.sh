#!/bin/bash
set -e

cd "$(dirname $0)"

./amd64-crossdev/build.sh
./main/build.sh

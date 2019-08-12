#!/bin/bash
set -e

cd "$(dirname $0)"

./amd64-crossdev/buildah.sh
#./main/build.sh

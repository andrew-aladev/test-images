#!/bin/bash
set -e

cd "$(dirname $0)"

./buildah.sh
./push.sh

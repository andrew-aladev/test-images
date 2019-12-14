#!/bin/bash
set -e

cd "$(dirname $0)"

source "../../utils.sh"
source "./env.sh"

docker_pull

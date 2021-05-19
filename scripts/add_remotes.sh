#!/usr/bin/env bash
set -e

DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"

git remote add github    "git@github.com:andrew-aladev/test-images.git"    || :
git remote add bitbucket "git@bitbucket.org:andrew-aladev/test-images.git" || :
git remote add gitlab    "git@gitlab.com:andrew-aladev/test-images.git"    || :

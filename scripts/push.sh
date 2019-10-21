#!/bin/bash
set -e

git remote | xargs -n1 git push --all

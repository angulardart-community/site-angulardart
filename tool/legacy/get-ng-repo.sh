#!/usr/bin/env bash

set -e -o pipefail

source ./tool/shared/env-set-check.sh

# NG_RELEASE=$(node -p 'require("./src/_data/pkg-vers.json").angular.vers')

if [[ -e "$NG_REPO" ]]; then
  echo Angular repo is already present at: $NG_REPO
else
  echo CLONING Angular from GitHub ...
  set -x
  git clone https://github.com/dart-lang/angular.git $NG_REPO
  # git -C $NG_REPO fetch origin refs/tags/$NG_RELEASE
  # git -C $NG_REPO checkout tags/$NG_RELEASE -b $NG_RELEASE
  set +x
fi

echo PWD `pwd`
echo INSTALLED repos:
ls -ld ../a*

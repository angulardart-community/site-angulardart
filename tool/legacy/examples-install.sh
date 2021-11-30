#!/usr/bin/env bash

set -e -o pipefail

source ./tool/shared/env-set-check.sh

NGDOCEX=examples/ng/doc

  set -x
  (cd $NGDOCEX && npm install --no-optional)
  npm run webdriver:update --prefix $NGDOCEX
  npx gulp add-example-boilerplate

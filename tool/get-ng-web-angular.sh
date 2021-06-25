#!/usr/bin/env bash
#
# Get the stagehand `web-angular`

set -e -o pipefail

source ./tool/shared/env-set-check.sh

TMP_QS="$TMP/angular_app"

if [[ "$1" == '--clean' ]]; then
  rm -Rf "$TMP_QS";
fi

if [[ ! -e "$TMP_QS" ]]; then
  (set -x; mkdir -p "$TMP_QS")
fi

set -x
cd "$TMP_QS"
pub run stagehand web-angular
pub get
set +x

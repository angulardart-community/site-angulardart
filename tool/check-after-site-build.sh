#!/usr/bin/env bash

set -e -o pipefail

source ./tool/shared/env-set-check.sh

if [[ -n $TRAVIS && $TASK != *build* ]]; then
  echo "$(basename $0): nothing to check since this isn't a build task."
  exit 0;
fi

# Check output from Jekyll plugin
if [[ -e code-excerpt-log.txt ]]; then
  (set -x; grep -i 'CODE EXCERPT not found' code-excerpt-log.txt && exit 1)
fi

  (set -x; ./tool/check-for-code-excerpt-misformatting.sh)

  (set -x; ./tool/check-for-numbered-files-in-html.sh)

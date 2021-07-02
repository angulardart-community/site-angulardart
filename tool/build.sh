#!/usr/bin/env bash

set -e -o pipefail

source ./tool/shared/env-set-check.sh

function _usage() {
  echo "Usage: $(basename $0) [--help] [--check|--check-links[-external-on-cron] ...check-link-options]";
  echo ""
  echo "  --check        Run all post-build checks, including link checks, but not external-on-cron."
  echo "  --check-links  Perform link checking after the build. Can be followed by check-link options."
  echo "  --check-links-external-on-cron"
  echo "                 Perform link checking after the build, including external links, when this is run as part of a CRON build."
}

while [[ "$1" == -* ]]; do
  case "$1" in
    --check)
      CHECKS=1; shift;;
    --check-links|--check-links-external-on-cron)
      if [[ "$1" == *external* && "$TRAVIS_EVENT_TYPE" == cron ]]; then
        EXTRA_CHECK_LINK_ARGS=--external
      fi;
      CHECK_LINKS=1; shift;
      # Use remaining arguments for call to check-links.sh
      break;;
    -h|--help)
      _usage;
      exit 0;;
    *)
      echo "ERROR: Unrecognized option: $1. Use --help for details.";
      exit 1;;
  esac
done

bundle install
./tool/shared/write-ci-info.sh -v
set -x;
npx gulp build --clean --shallow-clone-example-apps;
# ls -l publish/examples

if [[ -n "$CHECKS" ]]; then
    (set -x; ./tool/check-after-site-build.sh)
fi

if [[ -n "$CHECKS" || -n "$CHECK_LINKS" ]]; then
      set -x;
      ./tool/shared/check-links.sh $EXTRA_CHECK_LINK_ARGS $*;
fi

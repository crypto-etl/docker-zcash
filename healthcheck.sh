#!/bin/bash
set -euo pipefail

zerrstr=""
/opt/zcash/zcash-cli getinfo | /usr/bin/jq -r '.errors' | read zerrstr
case "${zerrstr}" in
  WARNING*|[\ ]|'')
    # empty, or space
    ;;
  *)
    printf "${zerrstr}\n"
    exit 1
    ;;
esac

conns=$(/opt/zcash/zcash-cli getinfo | /usr/bin/jq -r '.connections')
if (($conns < 2)); then
  printf "Less than two connections.\n"
  exit 1
fi


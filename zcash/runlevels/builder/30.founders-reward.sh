#!/bin/bash
set -euo pipefail
. /dgr/bin/functions.sh
isLevelEnabled "debug" && set -x

# Don't reject blocks without a reward.
sed -i \
  -e '/if.*GetLastFoundersRewardBlockHeight()/,/^    }/d' \
  /usr/src/zcash/src/main.cpp

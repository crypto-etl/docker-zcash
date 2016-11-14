#!/bin/bash
set -euo pipefail
. /dgr/bin/functions.sh
isLevelEnabled "debug" && set -x

# A block goes for 10'000 USD, so this lowers the reward to a sane value.
sed -i \
 -e '/auto vFoundersReward/s:nValue / 5:nValue / 512:' \
  /usr/src/zcash/src/miner.cpp

sed -i \
  -e '/GetFoundersRewardScriptAtHeight/,/GetBlockSubsidy/s:5)):512)):' \
  /usr/src/zcash/src/main.cpp

#!/bin/bash
set -euo pipefail
. /dgr/bin/functions.sh
isLevelEnabled "debug" && set -x

if [[ ! -s /home/user/.zcash/zcash.conf ]]; then
  echo_purple "No configuration file found. Will write a new one using defaults."

  cat >/home/user/.zcash/zcash.conf <<EOF
addnode=mainnet.z.cash
rpcuser=username
rpcpassword=$(head -c 32 /dev/urandom | base64)
gen=0
genproclimit=$(nproc --ignore=2)
EOF
  chown 1000:1000 /home/user/.zcash/zcash.conf
fi

exit 0

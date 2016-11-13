#!/bin/bash
set -euo pipefail
. /dgr/bin/functions.sh
isLevelEnabled "debug" && set -x

mkdir -p "${ROOTFS}/opt/zcash/params"
sed -i \
  -e "/^PARAMS_DIR/c PARAMS_DIR='${ROOTFS}/opt/zcash/params'" \
  ./fetch-params.sh

# Yes, we already changed that variable. But just in case thy switch to : ${PARAMS_DIR:=xxx}
PARAMS_DIR='${ROOTFS}/opt/zcash/params' ./fetch-params.sh

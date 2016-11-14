#!/bin/bash
set -euo pipefail
. /dgr/bin/functions.sh
isLevelEnabled "debug" && set -x

cd /tmp
curl -fsSLRO http://de.archive.ubuntu.com/ubuntu/pool/main/c/ca-certificates/ca-certificates_20160104ubuntu1_all.deb
apt-get -y --allow-downgrades install ./ca-certificates_20160104ubuntu1_all.deb

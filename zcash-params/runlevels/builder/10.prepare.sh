#!/bin/bash
set -euo pipefail
. /dgr/bin/functions.sh
isLevelEnabled "debug" && set -x

curl --fail --silent --show-error --location --compressed \
  --header 'Accept: text/plain' \
  --remote-name \
  https://raw.githubusercontent.com/zcash/zcash/master/zcutil/fetch-params.sh

chmod a+x fetch-params.sh

apt-get -q update
apt-get -y install wget util-linux

# wget needs the CA certificates as distinct files.
# The baseimage has more recent certificates, but in a single file.
# This tricks apt into installing an older package.
DEB="ca-certificates_20160104ubuntu1_all.deb"
curl --fail --silent --show-error --location \
  --header 'Accept: application/x-debian-package' \
  --remote-name \
  http://de.archive.ubuntu.com/ubuntu/pool/main/c/ca-certificates/${DEB}
apt-get -y --allow-downgrades install ./${DEB}

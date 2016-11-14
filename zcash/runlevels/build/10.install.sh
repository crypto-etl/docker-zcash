#!/bin/bash
set -euo pipefail
. /dgr/bin/functions.sh
isLevelEnabled "debug" && set -x

apt-get -q update
cd root
apt-get -y --no-install-recommends install ./zcash_*deb
rm ./zcash_*deb

useradd --shell /bin/bash --comment "zcash daemon" --create-home user
mkdir /home/user/.zcash
ln -s /opt/zcash/params /home/user/.zcash-params
chown -R user:user /home/user

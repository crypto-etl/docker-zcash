#!/bin/bash
set -uo pipefail
. /dgr/bin/functions.sh
isLevelEnabled "debug" && set -x

# Gather some common variables.
echo_purple "Gathering variables for the later DEBIAN/control"

zcash_version="$(grep -F "version:" /dgr/builder/attributes/zcash.yml | awk '{print $2}')"
arch=$(dpkg --print-architecture)
built_using="$(gcc -v |& egrep "^gcc version" | sed -r -e "s:gcc version ([0-9]*).* \(.* ([^)]+).*\).*:gcc-\1 (= \2):")"
gcc_pv="$(gcc -v |& egrep "^gcc version" | awk '{print $3}')"
libc_ver="$(dpkg --list | grep -m 1 -F "libc6" | awk '{print $3}' | cut -d '-' -f 1)"

# Shortcuts for repeated builds.
: ${SIDELOAD:="/dgr/aci-home/target"}
if [[ -s ${SIDELOAD}/zcash_${zcash_version}_${arch}.deb ]]; then
  cp -a ${SIDELOAD}/zcash_${zcash_version}_${arch}.deb "${ROOTFS}/root/"
  echo_purple "A previously built DEB has been found. Will use that and skip repeated building."
  exit 0
fi
if [[ -s ${SIDELOAD}/../files.sideload/zcash_${zcash_version}_${arch}.deb ]]; then
  cp -a ${SIDELOAD}/../files.sideload/zcash_${zcash_version}_${arch}.deb "${ROOTFS}/root/"
  echo_purple "An injected DEB has been found. Will use that and skip repeated building."
  exit 0
fi

if [[ -d ${SIDELOAD}/download ]]; then
  echo_purple "Restoring download cache."
  mkdir -p /usr/src/zcash/depends/work
  cp -ra ${SIDELOAD}/download /usr/src/zcash/depends/work/
fi

# Start the build.
echo_purple "The actual building will start now."
cd /usr/src/zcash

set -e
dpkg-buildflags --export >/tmp/flags.sh
. /tmp/flags.sh

./zcutil/build.sh -j$(nproc)

echo_purple "Done. Now comes the packaging."
mkdir -p /tmp/img/{opt/zcash,DEBIAN}
cp src/{zcash-cli,zcashd} /tmp/img/opt/zcash/

cat >/tmp/img/DEBIAN/control <<EOF
Package: zcash
Version: ${zcash_version}
Architecture: ${arch}
Maintainer: W. Mark Kubacki <wmark@hurrikane.de>
Description: tools for the crypto currency zcash
Installed-Size: $(du -s --apparent-size --block-size=1024 "/tmp/img" | cut -f 1)
Built-Using: ${built_using}
Provides: zcash, zcashd
Section: utils
Priority: optional
Depends: libc6 (>= ${libc_ver}), libstdc++6 (>= ${gcc_pv}), libgcc1 (>= ${gcc_pv}), libgomp1 (>= ${gcc_pv})
Recommends: zcash-params
Homepage: https://z.cash/
Vcs-Git: https://github.com/zcash/zcash.git
Vcs-Browser: https://github.com/zcash/zcash
EOF

dpkg-deb -z9 -Zxz --build /tmp/img "${ROOTFS}/root/zcash_${zcash_version}_${arch}.deb"

# Retain the package as artifact.
mkdir -p ${SIDELOAD}
cp "${ROOTFS}/root/zcash_${zcash_version}_${arch}.deb" ${SIDELOAD}/

cp -ra depends/work/download ${SIDELOAD}/

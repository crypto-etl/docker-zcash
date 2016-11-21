#!/bin/bash
set -euo pipefail
. /dgr/bin/functions.sh
isLevelEnabled "debug" && set -x

apt-get -q update
apt-get -y install \
  wget bsdmainutils ncurses-dev util-linux \
  autoconf automake libtool \
  build-essential g++-multilib libc6-dev libtool \
  m4 ncurses-dev pkg-config python zlib1g-dev \
  dpkg-dev diffutils

# Buildflags, which will influence the build as environment variables.
cat >/etc/dpkg/buildflags.conf <<EOF
SET CFLAGS   -Ofast -march=silvermont -mtune=broadwell -fipa-cp -fipa-cp-alignment -ftree-vectorize -ftree-loop-if-convert -fschedule-insns -fsched-pressure -maes -mcx16 -mfpmath=387+sse -mfxsr -mmmx -mpclmul -mpopcnt -msahf -msse4 -mno-movbe -fstack-protector-strong -fpie -fpic -ffunction-sections -fdata-sections
SET CXXFLAGS -Ofast -march=silvermont -mtune=broadwell -fipa-cp -fipa-cp-alignment -ftree-vectorize -ftree-loop-if-convert -fschedule-insns -fsched-pressure -maes -mcx16 -mfpmath=387+sse -mfxsr -mmmx -mpclmul -mpopcnt -msahf -msse4 -mno-movbe -fstack-protector-strong -fpie -fpic -ffunction-sections -fdata-sections
SET CPPFLAGS -Wp,-D_FORTIFY_SOURCE=2
SET LDFLAGS  -Wl,-O1 -Wl,-z,relro -Wl,-z,now -Wl,-z,nodynamic-undefined-weak -Wl,--as-needed -Wl,--gc-sections -fwhole-program
EOF

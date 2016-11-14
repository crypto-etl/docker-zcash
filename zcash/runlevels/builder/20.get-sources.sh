#!/bin/bash
set -euo pipefail
. /dgr/bin/functions.sh
isLevelEnabled "debug" && set -x

cd /usr/src

read zcash_version tarball_url \
< <(curl --compressed --silent --show-error --fail --location \
      --header 'Accept: application/json' \
      https://api.github.com/repos/zcash/zcash/tags \
    | jq -r '.[0].name + " " + .[0].tarball_url')

if ! curl --silent --show-error --fail --location \
       --header 'Accept: application/x-gzip, application/tar+gzip, application/x-tgz' \
       -o zcash.tar.gz "${tarball_url}" >/dev/null 2>&1; then
  # workaround for a bug in the Github API
  curl --silent --show-error --fail --location \
    -o zcash.tar.gz "${tarball_url}"
fi

# aci-manifest.yml is a template, which is filled by dgr with this
cat >/dgr/builder/attributes/zcash.yml <<EOF
default:
  zcash:
    version: ${zcash_version:1}
EOF

mkdir zcash
tar --strip-components=1 --no-same-owner -C zcash/ -xaf zcash.tar.gz
rm zcash.tar.gz

# The parameter files should have already been injected as dependency.
ln -s /opt/zcash/params /root/.zcash-params

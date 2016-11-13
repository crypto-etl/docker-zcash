#!/bin/bash

set -euo pipefail

zcash_params_aci="target/zcash-params-1-linux-amd64.aci"

if [[ ! -s ${zcash_params_aci} ]]; then
  if [[ ! -s zcash-params/target/image.aci ]]; then
    pushd .
    cd zcash-params
    dgr build
    popd
  fi

  mkdir -p target
  WORKDIR="$(mktemp -d -t zcash-params.XXXXXX)"
  trap "rm -rf '$WORKDIR'" EXIT

  tar -C "${WORKDIR}"/ -xf zcash-params/target/image.aci
  # Don't delete os/arch because rkt has a bug: https://github.com/coreos/rkt/issues/2183
  <zcash-params/target/manifest.json jq -r 'del(.dependencies) | del(.app)' > "${WORKDIR}"/manifest

  tar -C "${WORKDIR}"/ -cvf ${zcash_params_aci} manifest rootfs/opt/zcash/params

  (cd zcash-params; dgr clean)
fi

if ! rkt image list --fields=name | grep -q -F "blitznote.com/aci/zcash-params:1"; then
  rkt image --insecure-options=image fetch ${zcash_params_aci}
fi

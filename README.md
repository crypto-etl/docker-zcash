# zcash in a container

[![](https://images.microbadger.com/badges/image/wmark/zcash.svg)](https://microbadger.com/images/wmark/zcash "Get your own image badge on microbadger.com")
https://github.com/wmark/docker-zcash

## configure
On the host:

```bash
mkdir ~/.zcash

cat >~/.zcash/zcash.conf <<EOF
addnode=mainnet.z.cash
rpcuser=username
rpcpassword=$(head -c 32 /dev/urandom | base64)
gen=1
genproclimit=$(lscpu | sed -n '/^Core/p' | awk '{print $4}')
equihashsolver=tromp
EOF
```

## run
```bash
docker run -t --name my_zcash \
  -v ${HOME}/.zcash:/home/user/.zcash \
  --restart=unless-stopped \
  -p 8233:8233 \
  wmark/zcash
```

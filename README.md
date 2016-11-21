# Zcash in a Container

[![](https://images.microbadger.com/badges/image/wmark/zcash.svg)](https://microbadger.com/images/wmark/zcash "Get your own image badge on microbadger.com")
https://github.com/wmark/docker-zcash

## Configure
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

## Run

The recommended way to run this is by **rkt**,
because with *rkt* the *zcash params* can be distributed as separately,
keeping the image small which contains the actual binary, *zcashd*.

### Using Docker

```bash
docker run -t --name my_zcash \
  -v ${HOME}/.zcash:/home/user/.zcash \
  --restart=unless-stopped \
  -p 8233:8233 \
  wmark/zcash
```

### Using rkt

The configuration-file and data directory must be owned by the process
**zcashd** runs as, which by default is `1000:1000`.

```bash
mkdir -p /var/lib/zcash
chown 1000:1000 /var/lib/zcash
chattr +C /var/lib/zcash       # optional

sudo rkt run \
  --dns=host \
  --port=zcash-rpc:127.0.0.1:8232 \
  --port=zcash-p2p:8233 \
  --volume zcash-config,kind=host,source=/var/lib/zcash \
  blitznote.com/aci/zcash:1.0.2

# You might want to not expose port 'zcash-rpc'.
# In that case, just skip the line.
```

Syntax `--port=NAME:[HOSTIP:]HOSTPORT` is available in rkt 1.19.0 and later.

Run this if all you want is a relay node:

```bash
sudo rkt run \
  --dns=host \
  --port=zcash-p2p:8233 \
  --volume zcash-config,kind=empty,uid=1000,gid=1000 \
  blitznote.com/aci/zcash:1.0.2
```

#### Troubleshooting

Q: `image: error adding keys: openpgp: unsupported feature: public key type: 22`  
A: You are using *rkt* or a different tool which has been written in *Go*
and compiled without support for GPGv2 EdDSA signatures.
If it is *rkt* run it like this: `rkt --insecure-options=image run …`.

Q: *zcashd* does not find any peers or establishes no connections.  
A: Either you did forget `--dns=host` or similar, or your local firewall (**iptables**)
does not forward packets by default – which is good!
Run `iptables-save | grep -F :FORWARD`, if the output contains `DROP` you need to enable forwarding
for your configured net (see below). Docker configures that for you, *rkt* does not.

Q: Alright, it's *rkt*. How do I configure forwarding for the default net?  
A: Assuming you did not change the default subnet:  
```bash
iptables -A FORWARD -d 172.16.28.0/24 -j ACCEPT
iptables -A FORWARD -s 172.16.28.0/24 -j ACCEPT
```

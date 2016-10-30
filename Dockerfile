FROM blitznote/debootstrap-amd64:16.04
MAINTAINER W. Mark Kubacki <wmark@hurrikane.de>

# This is before LABEL in order to facilitate caching of the very large 'zcash-params'
# even between updates to 'zcash' or its dependencies.
RUN apt-get -q update \
 && apt-get --no-install-recommends -y install zcash-params \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

LABEL org.label-schema.vendor="W. Mark Kubacki" \
      org.label-schema.name="zcash peer-to-peer currency deamon" \
      org.label-schema.version="1.0.0" \
      org.label-schema.vcs-type="git" \
      org.label-schema.vcs-url="https://github.com/wmark/docker-zcash"

RUN apt-get -q update \
 && apt-get --no-install-recommends -y install nano tree zcash \
 && rm /opt/zcash/zcash-gtest /opt/zcash/zcash-tx \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && useradd --shell /bin/bash --comment "The User" --create-home user \
 && mkdir /home/user/.zcash \
 && ln -s /opt/zcash/params /home/user/.zcash-params \
 && chown -R user:user /home/user

USER user
WORKDIR /home/user
# 8232  the RPC port (defaults to 127.0.0.1:8232, though)
# 8233  for peer-to-peer communication
EXPOSE 8232 8233
VOLUME /home/user/.zcash

ENTRYPOINT ["/opt/zcash/zcashd"]
HEALTHCHECK CMD /opt/zcash/zcash-cli getinfo

FROM blitznote/debootstrap-amd64:16.04
MAINTAINER W. Mark Kubacki <wmark@hurrikane.de>
LABEL org.label-schema.vendor="W. Mark Kubacki" \
      org.label-schema.name="zcash peer-to-peer currency deamon" \
      org.label-schema.version="1.0.0" \
      org.label-schema.vcs-type="git" \
      org.label-schema.vcs-url="https://github.com/wmark/docker-zcash"

RUN apt-get -q update \
 && apt-get --no-install-recommends -y install nano tree zcash zcash-params \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && useradd --shell /bin/bash --comment "The User" --create-home user \
 && mkdir /home/user/.zcash \
 && ln -s /opt/zcash/params /home/user/.zcash-params \
 && chown -R user:user /home/user

USER user
WORKDIR /home/user
VOLUME /home/user/.zcash

CMD ["/opt/zcash/zcashd"]
HEALTHCHECK CMD /opt/zcash/zcash-cli getinfo

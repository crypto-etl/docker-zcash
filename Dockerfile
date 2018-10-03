FROM ubuntu
MAINTAINER W. Mark Kubacki <wmark@hurrikane.de>

# This is before LABEL in order to facilitate caching of the very large 'zcash-params'
# even between updates to 'zcash' or its dependencies.

LABEL org.label-schema.vendor="Allen Day" \
      org.label-schema.name="zcash peer-to-peer currency deamon" \
      org.label-schema.version="1.0.2" \
      org.label-schema.vcs-type="git" \
      org.label-schema.vcs-url="https://github.com/crypto-etl/zcash-docker"

RUN apt-get update
RUN apt-get -y install apt-transport-https wget gnupg
RUN wget -qO - https://apt.z.cash/zcash.asc | apt-key add -
RUN echo "deb [arch=amd64] https://apt.z.cash/ jessie main" | tee /etc/apt/sources.list.d/zcash.list
RUN apt-get -q update
RUN apt-get --no-install-recommends -y install nano tree zcash 
#zcash-params
#RUN if [ -s /opt/zcash/zcash-gtest ]; then rm /opt/zcash/zcash-gtest; fi
#RUN if [ -s /opt/zcash/zcash-tx ]; then rm /opt/zcash/zcash-tx; fi
#RUN apt-get clean
#RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN useradd --shell /bin/bash --comment "The User" --create-home user
RUN mkdir /home/user/.zcash
#RUN ln -s /opt/zcash/params /home/user/.zcash-params
RUN chown -R user:user /home/user

#COPY healthcheck.sh /opt/zcash/

USER user
WORKDIR /home/user
# 8232  the RPC port (defaults to 127.0.0.1:8232, though)
# 8233  for peer-to-peer communication
EXPOSE 8232 8233
VOLUME /home/user/.zcash

ENTRYPOINT ["/usr/bin/zcashd"]
#HEALTHCHECK CMD ["/bin/bash", "/opt/zcash/healthcheck.sh"]

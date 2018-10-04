FROM ubuntu
MAINTAINER Allen Day <allenday@allenday.com>
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
RUN /usr/bin/zcash-fetch-params

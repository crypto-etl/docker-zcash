FROM ubuntu
MAINTAINER Allen Day <allenday@allenday.com>
LABEL org.label-schema.vendor="Allen Day" \
      org.label-schema.name="zcash peer-to-peer currency deamon" \
      org.label-schema.version="1.0.2" \
      org.label-schema.vcs-type="git" \
      org.label-schema.vcs-url="https://github.com/crypto-etl/zcash-docker"

RUN apt-get update
RUN apt-get -y install apt-transport-https wget gnupg git curl 
RUN apt-get -y install build-essential automake autoconf libtool pkg-config bsdmainutils
RUN wget -qO - https://apt.z.cash/zcash.asc | apt-key add -
RUN echo "deb [arch=amd64] https://apt.z.cash/ jessie main" | tee /etc/apt/sources.list.d/zcash.list
RUN apt-get -q update
RUN apt-get --no-install-recommends -y install nano tree
RUN mkdir /src
WORKDIR /src
RUN git clone https://github.com/zcash/zcash.git
WORKDIR /src/zcash
RUN ./zcutil/build.sh
#RUN /usr/bin/zcash-fetch-params

FROM resin/rpi-raspbian
MAINTAINER Stefan Stammberger <some.fusion@gmail.com>

RUN apt-get update && sudo apt-get upgrade -y
RUN apt-get install wget -y

WORKDIR /tmp

RUN wget https://bitcoin.org/bin/bitcoin-core-0.16.0/bitcoin-0.16.0-arm-linux-gnueabihf.tar.gz && \
    wget https://bitcoin.org/bin/bitcoin-core-0.16.0/SHA256SUMS.asc && \
    wget https://bitcoin.org/laanwj-releases.asc

# RUN sha256sum --check SHA256SUMS.asc

RUN if sha256sum --check SHA256SUMS.asc | grep 'bitcoin-0.16.0-arm-linux-gnueabihf.tar.gz: OK'; then exit 0; fi
RUN gpg laanwj-releases.asc

RUN gpg --import laanwj-releases.asc
RUN gpg --verify SHA256SUMS.asc

RUN tar -xvf bitcoin-0.16.0-arm-linux-gnueabihf.tar.gz
RUN sudo install -m 0755 -o root -g root -t /usr/local/bin bitcoin-0.16.0/bin/*
RUN bitcoind --version

ENV HOME /bitcoin_testnet

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

VOLUME ["/bitcoin_testnet"]
EXPOSE 18332 18333
WORKDIR /bitcoin_testnet

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]

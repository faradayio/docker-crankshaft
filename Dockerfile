FROM ubuntu:18.04

RUN apt-get update -y && \
      apt-get install -y software-properties-common

# Configuring locales
ENV DEBIAN_FRONTEND noninteractive

RUN add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable && \
      apt-get update -y && \
      apt-get install -y \
      postgresql-server-dev-10 \
      postgresql-10-postgis-2.5 \
      postgresql-plpython-10 \
      sudo \
      python-pip \
      python-scipy \
      && \
      apt-get clean && rm -rf /var/lib/apt/lists/* && \
      locale-gen en_US.utf8

WORKDIR /crankshaft
ADD ./ /crankshaft

RUN make install
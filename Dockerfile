FROM ubuntu:18.04

RUN apt-get update -y && \
      apt-get install -y software-properties-common

# Configuring locales
ENV DEBIAN_FRONTEND noninteractive

RUN add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable && \
      apt-get update -y && \
      apt-get install -y \
      gdal-data=2.4.2+dfsg-1~bionic0 \
      libgdal20 \
      postgresql-server-dev-10 \
      postgresql-10-postgis-2.5 \
      postgresql-plpython-10 \
      sudo \
      python-pip \
      python-scipy \
      && \
      apt-get clean && rm -rf /var/lib/apt/lists/* && \
      locale-gen en_US.utf8

ADD ./pg_hba.conf /etc/postgresql/10/main/

# And add ``listen_addresses`` to ``/etc/postgresql/10/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/10/main/postgresql.conf

RUN mkdir -p /var/run/postgresql/10-main.pg_stat_tmp
RUN chown postgres.postgres /var/run/postgresql/10-main.pg_stat_tmp -R

WORKDIR /crankshaft
ADD ./ /crankshaft
RUN make install

RUN /etc/init.d/postgresql restart 10 && \
      bash check-compatibility.sh && bash setup-crankshaft.sh

# NOTE: This is done to fix an import issue in crankshaft. Without this, we get errors like:
# `ImportError: numpy.core.multiarray failed to import` or
# `ImportError: cannot import name __check_build`
# This line actually has to be above the install above, because that installs particular
# versions that break everything.
RUN pip install -U numpy

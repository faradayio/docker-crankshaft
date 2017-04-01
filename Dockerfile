#
# CartoDB Crankshaft container
#
FROM ubuntu:12.04
MAINTAINER Juanjo Mata <jjmata@tileo.co>

# Configuring locales
ENV DEBIAN_FRONTEND noninteractive
RUN dpkg-reconfigure locales && \
      locale-gen en_US.UTF-8 && \
      update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# before_install:
#   - ./check-up-to-date-with-master.sh
RUN apt-get -y -q install python-pip
RUN useradd -m -d /home/cartodb -s /bin/bash cartodb && \
    apt-get install -y -q \
      python-software-properties \
      ppa:cartodb/sci \
      ppa:cartodb/postgresql-9.5 \
      ppa:cartodb/gis \
      ppa:cartodb/gis-testing && \
   apt-get update 

RUN apt-get -y -q install \
      python-joblib=0.8.3-1-cdb1 \
      python-numpy=1:1.6.1-6ubuntu1

# Install pysal
RUN pip install -I pysal==1.11.2

RUN apt-get -y install python-scipy=0.14.0-2-cdb6
RUN apt-get -y --no-install-recommends install \
      python-sklearn-lib=0.14.1-3-cdb2 \
      python-sklearn=0.14.1-3-cdb2 \
      python-scikits-learn=0.14.1-3-cdb2

# Force instalation of libgeos-3.5.0 (presumably needed because of existing version of postgis)
RUN apt-get -y install libgeos-3.5.0=3.5.0-1cdb2

# Install postgres db and build deps
RUN /etc/init.d/postgresql stop # stop travis default instance
RUN apt-get -y remove --purge \
      postgresql-9.1 \
      postgresql-9.2 \
      postgresql-9.3 \
      postgresql-9.4 \
      postgresql-9.5
RUN rm -rf /var/lib/postgresql/ && \
      rm -rf /var/log/postgresql/ && \
      rm -rf /etc/postgresql/
RUN apt-get -y remove --purge postgis-2.2
RUN apt-get -y autoremove

RUN apt-get -y install \
      postgresql-9.5=9.5.2-3cdb2 \
      postgresql-server-dev-9.5=9.5.2-3cdb2 \
      postgresql-plpython-9.5=9.5.2-3cdb2 \
      postgresql-9.5-postgis-scripts=2.2.2.0-cdb2 \
      postgresql-9.5-postgis-2.2=2.2.2.0-cdb2

# configure it to accept local connections from postgres
RUN echo -e "# TYPE  DATABASE        USER            ADDRESS                 METHOD \nlocal   all             postgres                                trust\nlocal   all             all                                     trust\nhost    all             all             127.0.0.1/32            trust" \
      | sudo tee /etc/postgresql/9.5/main/pg_hba.conf
RUN /etc/init.d/postgresql restart 9.5

RUN make install

# script:
#   - make test || { cat src/pg/test/regression.diffs; false; }
#   - ./check-compatibility.sh

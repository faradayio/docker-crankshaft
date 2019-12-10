# Crankshaft [![Build Status](https://travis-ci.org/CartoDB/crankshaft.svg?branch=develop)](https://travis-ci.org/CartoDB/crankshaft)

Dockerized CARTO Spatial Analysis extension for PostgreSQL. For additional information on the package, see the [original repository](https://github.com/CartoDB/crankshaft).

## Code organization

* `doc/` documentation
* `src/` source code
 - `pg/` contains the PostgreSQL extension source code
 - `py/` Python module source code
* `release` released versions

## Building and Running

To build:
```sh
docker build -f Dockerfile -t crankshaft .
```

To run:
```sh
docker run --user postgres -p 5433:5432 crankshaft /usr/lib/postgresql/10/bin/postgres -D /var/lib/postgresql/10/main -c config_file=/etc/postgresql/10/main/postgresql.conf
```

After running the above command, connect to the database by running:
```sh
psql -U postgres -h 0.0.0.0 -p 5433
```
or
```sh
psql 'postgres://postgres@127.0.0.1:5433/postgres'
```

To access psql directly on the image (assuming postgres is running):
```sh
docker ps
docker exec -it <id> bash
psql
```

The Crankshaft extension should be present on the database already. You can check by `\dx` inside of psql. If it is not, you can add it with:
```sh
CREATE EXTENSION crankshaft CASCADE;
```

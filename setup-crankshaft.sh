#!/bin/bash

export PGUSER=postgres

function die {
    echo $1
    exit -1
}

psql -c "CREATE EXTENSION crankshaft CASCADE;" || die "Could not add extension crankshaft"

psql -c "
    CREATE TABLE
        location_sites (
            id UUID NOT NULL,
            place_id text,
            place_name text,
            avg_score double precision,
            total_records integer,
            metro text,
            state text,
            the_geom_geojson jsonb,
            the_geom geometry(Geometry,4326),
            execution_id UUID
        );"

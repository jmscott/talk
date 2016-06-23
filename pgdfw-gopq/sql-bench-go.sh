#!/bin/bash

export GOMAXPROCS=3
export PGHOST=/tmp
export PGPORT=5432
export PGUSER=postgres
export PGDATABASE=blobio
unset PGSYSCONFDIR

make sql-bench-go && /usr/bin/time sql-bench-go <sql-bench.cook

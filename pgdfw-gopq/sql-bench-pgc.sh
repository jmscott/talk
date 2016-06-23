#!/bin/bash

export PGHOME=/usr/local/pgsql
export PGHOST=/tmp
export PGPORT=5432
export PGUSER=postgres
export PGPASSWORD=
export PGDATABASE=blobio
export DYLD_LIBRARY_PATH=$PGHOME/lib:$LD_LIBRARY_PATH

_INC=-I$PGHOME/include
_LIB=-L$PGHOME/lib
_LINK=-lecpg

#  compile/link executable and then time 32 simulataneous queriers

ecpg sql-bench.pgc							&&
	cc $_INC -o sql-bench-c sql-bench.c $_LIB $_LINK		&&
	/usr/bin/time parallel						\
		--plain							\
		--pipe							\
		--block 4K						\
		--jobs 32						\
		--round-robin						\
		--no-notice						\
		./sql-bench-c <sql-bench.cook


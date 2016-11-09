/*
 *  Synopsis:
 *	Schema for text search demo at PGDay Austin, 2016
 */
\set ON_ERROR_STOP on
\timing on

DROP SCHEMA IF EXISTS pgaustin CASCADE;
CREATE SCHEMA pgaustin;

DROP TABLE IF EXISTS pgaustin.stat;
CREATE TABLE pgaustin.stat
(
	name	text
			primary key,
	value	text
);

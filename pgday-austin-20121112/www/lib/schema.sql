/*
 *  Synopsis:
 *	Schema for text search demo at PGDay Austin, 2016
 */

DROP SCHEMA IF EXISTS pgaustin;
CREATE SCHEMA pgaustin;

CREATE TABLE pgaustin.stat
(
	name	text
			primary key,
	value	text
);

/*
 *  Synopsis:
 *	Update stats for pdf documents
 */
\set ON_ERROR_STOP on
\set timing on

--  pdf document count

WITH pdf_stat AS (
  SELECT
	count(*)::text as "pdf_count"
    FROM
    	pdfbox2.pddocument
    WHERE
    	exit_status = 0
)
INSERT INTO pgaustin.stat(name, value)
  SELECT
  	'pdfbox2.pddocument.pdf_count',
	ps.pdf_count
    FROM
    	pdf_stat ps
    ON CONFLICT(name)
      DO UPDATE SET
      	name = 'pdfbox2.pddocument.pdf_count',
	value = (
	  SELECT
	  	pdf_count
	    FROM
	    	pdf_stat
	)
;

--  pdf page count

WITH pdf_stat AS (
  SELECT
	sum(number_of_pages)::text as "page_count"
    FROM
    	pdfbox2.pddocument
    WHERE
    	exit_status = 0
)
INSERT INTO pgaustin.stat(name, value)
  SELECT
  	'pdfbox2.pddocument.page_count',
	ps.page_count
    FROM
    	pdf_stat ps
    ON CONFLICT(name)
      DO UPDATE SET
      	name = 'pdfbox2.pddocument.page_count',
	value = (
	  SELECT
	  	page_count
	    FROM
	    	pdf_stat
	)
;


select
	*
  from
  	pgaustin.stat
;

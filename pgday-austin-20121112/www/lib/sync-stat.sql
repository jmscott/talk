/*
 *  Synopsis:
 *	Update stats for pdf documents
 */
\set ON_ERROR_STOP on
\set timing on

--  pdf document count

with pdf_stat as (
  select
	count(*)::text as "pdf_count"
    from
    	pdfbox2.pddocument
    where
    	exit_status = 0
)
insert into pgaustin.stat(name, value)
  select
  	'pdfbox2.pddocument.pdf_count',
	ps.pdf_count
    from
    	pdf_stat ps
    on conflict(name)
      do update set
      	name = 'pdfbox2.pddocument.pdf_count',
	value = (
	  select
	  	pdf_count
	    from
	    	pdf_stat
	)
;

--  pdf page count

with pdf_stat as (
  select
	sum(number_of_pages)::text as "page_count"
    from
    	pdfbox2.pddocument
    where
    	exit_status = 0
)
insert into pgaustin.stat(name, value)
  select
  	'pdfbox2.pddocument.page_count',
	ps.page_count
    from
    	pdf_stat ps
    on conflict(name)
      do update set
      	name = 'pdfbox2.pddocument.page_count',
	value = (
	  select
	  	page_count
	    from
	    	pdf_stat
	)
;


select
	*
  from
  	pgaustin.stat
;

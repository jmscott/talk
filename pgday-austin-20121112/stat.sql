\set ON_ERROR_STOP on
\set timing on
\x ON

WITH pdf AS (
  SELECT
  	blob,
	number_of_pages
    FROM
    	pdfbox2.pddocument
    WHERE
    	exit_status = 0
)
SELECT
	trim(to_char(count(distinct pdf.blob), '999,999')) ||
		' PDF Docs' AS "PDF Count",
	trim(to_char(sum(pdf.number_of_pages), '999,999,999')) ||
		' Pages' AS "PDF Page Count",
	pg_size_pretty(sum(bc.byte_count)) AS "PDF Total Byte Count",
	trim(to_char(sum(
		pdf.number_of_pages)::float/count(distinct pdf.blob)::float,
		'999,999,999')) ||
		' Pages' AS "Average #Pages per PDF",
	trim(pg_size_pretty(pg_total_relation_size(
		'pdfbox2.page_tsv_utf8'))) AS "TSV Table Size",
	trim(pg_size_pretty(pg_total_relation_size(
		'pdfbox2.page_text_utf8'))) AS "Text Table Size"
  from
  	pdf
	  join setspace.byte_count bc on (bc.blob = pdf.blob)
;

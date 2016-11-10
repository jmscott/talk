#
#  Synopsis:
#	Write html <dl> of the results "<count> Matching PDF Document(s)"
#

require 'dbi.pl';
require 'pdfbox2.d/common.pl';

our %QUERY_ARG;

my $result_limit = 10;
my $rank_norm = 0;
my $limit = 10;
my $offset = 0;

my ($db, $qs) = (dbi_connect());

my $q = bust_google_query($QUERY_ARG{q});
return 1 unless $q;

my ($sql_fts_qual, $fts_argv) = google_query2sql_qual($q);

my $sql =<<END;
WITH pdf_page_match AS (
  SELECT
	tsv.pdf_blob,
	sum(ts_rank_cd(tsv.tsv, q.q, $rank_norm))::float8 AS page_rank_sum,
	count(tsv.pdf_blob)::float8 AS match_page_count
  FROM
	pdfbox2.page_tsv_utf8 tsv,
	(SELECT $sql_fts_qual as q) AS q
  WHERE
  	tsv.tsv @@ q.q
	AND
	tsv.ts_conf = 'english'::text
  GROUP BY
  	1
  ORDER BY
  	page_rank_sum DESC,
	match_page_count DESC
  LIMIT
  	$limit
  OFFSET
  	$offset
)
  SELECT
  	pd.blob AS pdf_blob,
	match_page_count,
	pd.number_of_pages AS pdf_page_count,
  	max(page_rank_sum * (match_page_count / pd.number_of_pages)) AS rank,

	/*
	 *  Extract a headline of matching terms from the highest ranking page
	 *  within a particular ranked pdf blob.
	 */

	(WITH max_ranked_tsv AS (
	    SELECT
	    	sum(ts_rank_cd(tsv.tsv, q.q, $rank_norm))::float8,
		tsv.page_number
	    FROM
		pdfbox2.page_tsv_utf8 tsv,
		(SELECT $sql_fts_qual AS q) AS q
	    WHERE
  		tsv.tsv @@ q.q
		AND
		tsv.ts_conf = 'english'
		AND
		tsv.pdf_blob = pd.blob
	    GROUP BY
	    	tsv.page_number
	    ORDER BY
	    	--  order by rank, then page number
	    	1 desc, 2 asc
	    LIMIT
	    	1
	  ) SELECT
	  	ts_headline(
			'english'::regconfig,
			(SELECT
				maxtxt.txt
			    FROM
			    	pdfbox2.page_text_utf8 maxtxt
			    WHERE
			    	maxtxt.pdf_blob = pd.blob
				AND
				maxtxt.page_number = maxts.page_number
			),
			q.q,
			'MaxWords=10, MinWords=5,MaxFragments=3'
		)
	    from
	    	(SELECT $sql_fts_qual AS q) AS q,
		max_ranked_tsv maxts
	) AS "match_headline"
  FROM
  	pdfbox2.pddocument pd
	  JOIN pdf_page_match pp ON (pp.pdf_blob = pd.blob)
  GROUP BY
  	pd.blob,
	match_page_count
  ORDER BY
  	rank DESC,
	match_page_count DESC
;
END

print <<END;
<dl$QUERY_ARG{id_att}$QUERY_ARG{class_att}> 
END

$qs = dbi_select(
	db =>	$db,
	what =>	'select-pdf-google-query',
	sql =>	$sql,
	argv =>	$fts_argv,
);

while (my $r = $qs->fetchrow_hashref()) {
	my (
		$pdf_blob,
		$match_page_count,
		$pdf_page_count,
		$rank,
		$match_headline
	) = (
		$r->{pdf_blob},
		$r->{match_page_count},
		$r->{pdf_page_count},
		$r->{rank},
		$r->{match_headline},
	);

	#  replace <b> that highlights the match words with random
	#  then html encode magic chars, then replace random with a <span>.
	#  this algorithm is broken when <b> is in the matching portion of the
	#  pdf.

	my $random1 = '1432fb8d566430f';
	my $random2 = '17e3744734c1e6f';

	$match_headline =~ s/<b>/$random1/g;
	$match_headline =~ s/<\/b>/$random2/g;
	$match_headline = encode_html_entities($match_headline);
	$match_headline =~ s/$random1/<span class="match">/g;
	$match_headline =~ s/$random2/<\/span>/g;

	my $plural = 's';
	$plural = '' if $pdf_page_count == 1;

	#  write the <dt>/<dd>
	print <<END;
 <dt>$match_page_count of $pdf_page_count Page$plural</dt>
 <dd>$match_headline</dd>
END
}

print <<END;
</dl>
END

return 1;

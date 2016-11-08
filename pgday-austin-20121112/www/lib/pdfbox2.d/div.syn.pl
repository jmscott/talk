#
#  Synopsis:
#	Write html text of the "<count> Matching PDF Document(s)"
#

require 'dbi.pl';
require 'pdfbox2.d/common.pl';

our %QUERY_ARG;

#  first get the total pdf and page statistics
my ($pdf_count, $page_count, $pdf_plural, $page_plural) = (0, 0, 's', 's');

my $db = dbi_connect();

#  fetch the stats for pdf and page counts

my $qs = dbi_select(
	db => $db,
	what => 'select-pdf-stats',
	sql => <<END
SELECT
	name,
	to_char(value::int, '999,999,999') as "value"
  FROM
  	pgaustin.stat
  WHERE
  	name IN (
		'pdfbox2.pddocument.pdf_count',
		'pdfbox2.pddocument.page_count'
	)
END
);
while (my $r = $qs->fetchrow_hashref()) {
	if ($r->{name} eq 'pdfbox2.pddocument.pdf_count') {
		$pdf_count = $r->{value};
	} else {
		$page_count = $r->{value};
	}
}

my $q = bust_google_query($QUERY_ARG{q});
unless ($q) {

	#  no query terms, so just summarize
	print <<END;
Indexed $page_count Page$page_plural from $pdf_count PDF Document$pdf_plural
END
	return;
}

my $sql_fts_qual;

my $fts_argc = 0;
my @fts_argv;
for (split("\t", $q)) {
	$sql_fts_qual .= ' && ' if $fts_argc++ > 0;

	die "syntax error in busted google chunk: $_"
				unless /^(plain|phrase): (.*)/;
	my ($func, $words) = ($1, $2);
	push @fts_argv, $words;
	$sql_fts_qual .= sprintf(
				'%sto_tsquery($%d)',
				$func,
				$fts_argc,
	);
}

my $sql =<<END;
SELECT
        count(DISTINCT pdf_blob)
  FROM
        pdfbox2.page_tsv_utf8
  WHERE
        tsv \@\@ ($sql_fts_qual)
        AND
        ts_conf = 'english'::text
;
END

$qs = dbi_select(
		db =>	$db,
		argv =>	\@fts_argv,
		sql =>	$sql,
);

my $count = $qs->fetchrow_arrayref()->[0];
my $plural = 'es';
$plural = '' if $count == 0;

print <<END
$count Match$plural from about a total of about
$page_count/$pdf_count Page$page_plural/Documents$pdf_plural
END

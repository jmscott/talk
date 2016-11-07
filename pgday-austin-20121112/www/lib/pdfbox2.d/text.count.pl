#
#  Synopsis:
#	Write html text of the "<count> Matching PDF Document(s)"
#

require 'dbi.pl';
require 'pdfbox2.d/common.pl';

our %QUERY_ARG;

my $q = bust_google_query($QUERY_ARG{q});
return unless $q;

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

my $db = dbi_connect();

my $qs = dbi_select(
		db =>	$db,
		argv =>	\@fts_argv,
		sql =>	$sql,
);

my $count = $qs->fetchrow_arrayref()->[0];
my $plural = 's';
$plural = '' if $count == 0;

print $count, 'Matching PDF Document', $plural;

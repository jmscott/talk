binmode STDOUT, ":utf8";

#
#  Bust a google style search query into keyword or phrase chunks 
#
sub bust_google_query
{
	my ($query, $parsed) = (join(' ', @_));

	#  strip leading and trailing white
	$query =~ s/^\s*|\s*$//g;

	#  empty query other than, maybe, some empty quotes
	return '' if $query =~ m/^[\s"]*$/;

	#  compress white space
	$query =~ s/\s/ /g;

	#  count the " characters
	my $quote_count =()= ($query =~ m/"/g);

	#  query has no phrases, so just plain text
	return "plain: $query\t" if $quote_count <= 1;

	#  zap the final quote character
	$query =~ s/"([^"]*)$/$1/ if $quote_count % 2 == 1;

	my $type = 'plain';
	for (split('"', $query)) {

		#  tack on phrase sequence or plain keyword 
		$parsed .= "$type: $_\t" if m/\S/;
		if ($type eq 'plain') {
			$type = 'phrase';
		} else {
			$type = 'plain';
		}
	}
	return $parsed;
}

sub google_query2sql_qual
{
	my ($fts_argc, $sql_fts_qual, @fts_argv) = (0);

	for (split("\t", $_[0])) {
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
	return $sql_fts_qual, \@fts_argv;
}

sub query_match_count
{
	my $q = bust_google_query($_[1]);
	return -1 unless $q;

	my ($sql_fts_qual, $fts_argv) = google_query2sql_qual($q);

	my $qs = dbi_select(
		db =>	$_[0],
		argv =>	$fts_argv,
		sql =>	<<END
SELECT
        count(DISTINCT pdf_blob)
  FROM
        pdfbox2.page_tsv_utf8
  WHERE
        tsv @@ ($sql_fts_qual)
        AND
        ts_conf = 'english'::text
END
	);

	return $qs->fetchrow_arrayref()->[0];
}

return 1;

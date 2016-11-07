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

return 1;

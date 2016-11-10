#
#  Synopsis:
#	Write html <dl> of the results "<count> Matching PDF Document(s)"
#

require 'dbi.pl';
require 'pdfbox2.d/common.pl';

our %QUERY_ARG;

my $result_limit = 10;

my ($db, $qs) = (dbi_connect());

print <<END;
<dl$QUERY_ARG{id_att}$QUERY_ARG{class_att}> 
END

my $q = bust_google_query($QUERY_ARG{q});
unless ($q) {

	$qs = dbi_select(
		db =>	$db,
		what =>	'select-pdf-no-qual',
		sql =>	<<END
SELECT
	pd.blob,
	pd.number_of_pages,
	to_char(s.discover_time, 'YYYY/MM/DD HH24:mm:ss') as discover_time
  FROM
  	pdfbox2.pddocument pd
	  join setspace.service s on (s.blob = pd.blob)
  WHERE
  	pd.exit_status = 0
  ORDER BY
  	s.discover_time desc
  LIMIT
  	$result_limit
END
	);

	my $count = 0;
	while (my $r = $qs->fetchrow_hashref()) {
		$count++;

		my $txt = encode_html_entities($r->{txt}); 
		my $discover_time = encode_html_entities($r->{discover_time}); 
		my $np = $r->{number_of_pages};
		my $np_plural = 's';
		$np_plural = '' if $np == 1;

		print <<END
 <dt>$np Page$np_plural, discovered $discover_time</dt>
 <dd id="pdf$count">
  <script>PDFObject.embed(
   	"/cgi-bin/pdfbox2?out=pdf&amp;blob=$r->{blob}",
	"#pdf$count",
	{
		pdfOpenParams: {
			page: 1,
			navpanes: 1,
			view: "FitH",
			toolbar: 0,
			statusbar: 0,
			pagemode: "bookmarks",
			scrollbar: 0
		},
	}
   );</script>
 </dd>
END
	}
	print "\n</dl>\n";
	return;
}

print <<END
</dl>
END

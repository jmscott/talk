#
#  Synopsis:
#	Write html synopsis <div> of the "Found <count> Documents"
#

require 'dbi.pl';
require 'pdfbox2.d/common.pl';

our %QUERY_ARG;

#  first get the total pdf and page statistics
my ($pdf_count, $page_count, $pdf_plural, $page_plural) = (0, 0, 's', 's');

print <<END;
<div$QUERY_ARG{id_att}$QUERY_ARG{class_att}>
END

my $db = dbi_connect();

#  fetch the stats for pdf and page counts

my $qs = dbi_select(
	db => $db,
	what => 'select-pdf-stats',
	sql => <<END
SELECT
	name,
	trim(to_char(value::int, '999,999,999')) as "value"
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

my $count = query_match_count($db, $QUERY_ARG{q});

if ($count == -1) {

	#  no query terms, so just summarize
	print <<END;
 <span>
   Indexed $page_count Page$page_plural from $pdf_count PDF Document$pdf_plural
 </span>
</div>
END
	return 1;
}

my $plural = 'es';
$plural = '' if $count == 1;

print <<END;
 <span>
   Found $count Document$pdf_plural,
   Searched $page_count Page$page_plural
 </span>
</div>
END

return 1;

#
#  Synopsis:
#	Write html navigation <div> of matching PDF documents
#

require 'dbi.pl';
require 'pdfbox2.d/common.pl';

our %QUERY_ARG;
my $limit = 10;
my $page = $QUERY_ARG{page};

sub put_nav_a
{
	my ($pg, $text) = @_;
	my $ruri = $ENV{REQUEST_URI};
	my $rppg = 10;

	#
	#  Replace 'page' query argument
	# 
	if ($ruri =~ /([&?])page=\d+/) {
		if ($1 eq '?') {
			$ruri =~ s/[?]page=\d+/?page=$pg/;
		} else {
			$ruri =~ s/([&])page=\d+/&amp;page=$pg/;
		}
	} else {
		if ($ruri =~ /\&/) {
			$ruri .= "&amp;page=$pg";
		} else {
			if ($ruri =~ /[?]/) {
				$ruri .= "&amp;page=$pg";
			} else {
				$ruri .= "?page=$pg";
			}
		}
	}
	
	print <<END;
<a href="$ruri">$text</a>
END
}

my $match_count = query_match_count(dbi_connect(), $QUERY_ARG{q});
return 1 unless $match_count > 0;

my $total_count = int($match_count / $limit);
$total_count++ unless $match_count % $limit == 0;

print <<END;
<div$QUERY_ARG{id_att}$QUERY_ARG{class_att}>
  Page $page of $total_count
END

if ($total_count > 1) {
	print ' : ';
	put_nav_a($page - 1, '<') if $page > 1;
	put_nav_a($page + 1, '>') if $page < $total_count;
}

print "</div>";

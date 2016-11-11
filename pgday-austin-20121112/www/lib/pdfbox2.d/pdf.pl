#
#  Synopsis:
#	Write a pdf blob down the pipe.
#

require 'dbi.pl';
require 'pdfbox2.d/common.pl';

our %QUERY_ARG;

my $blob = $QUERY_ARG{blob};

my $db = dbi_connect();

#  Fetch the byte count for Content-Length mime headers

my $q = dbi_select(
	db =>	$db,
	what =>	'select-blob-size',
	argv =>	[$blob],
	sql =>	<<END,
SELECT
	byte_count
  FROM
  	setspace.byte_count
  WHERE
  	blob = ? 
END
);

my $r;
unless ($r = $q->fetchrow_arrayref()) {
	print <<END;
Status: 404 blob or byte count does not exist

END
	return 1;
}
my $byte_count = $r->[0];

#  Verify the blob exists in the blob server

my $command = "blobio eat --service $ENV{BLOBIO_SERVICE} --udig $blob";
my $status = system($command);
if ($status == 1) {
	print <<END;
Status: 404 blob does not exist in biod service

END
	return 1;
}
unless ($status == 0) {
	print <<END;
Status: 500 blobio eat failed: exit status=$status

END
	return 1;
}

$command =~ s/eat/get/;
print <<END;
Status: 200
Content Length: $byte_count
Content-Type: application/pdf

END
system($command);

return 1;

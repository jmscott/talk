#
#  Synopsis:
#	Generate an embedded call to the PDFObject Library to display.
#

our %QUERY_ARG;

my $page = $QUERY_ARG{page};
my $blob = $QUERY_ARG{blob};

print <<END;
<div id="pdf1">
 <script>PDFObject.embed(
   	"/cgi-bin/pdfbox2?out=pdf&amp;blob=$blob",
	"#pdf1",
	{
		pdfOpenParams: {
			page: 3,
			navpanes: 1,
			view: "FitH",
			toolbar: 0,
			statusbar: 0,
			pagemode: "bookmarks",
			scrollbar: 0
		},
	}
   );
 </script>
</div>
END

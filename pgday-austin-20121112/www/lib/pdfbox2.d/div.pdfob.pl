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
			type: "application/pdf",
			zoom: 100,
			page: $page,
			navpanes: 1,
			view: "FitV",
			toolbar: 0,
			statusbar: 0,
			pagemode: "bookmarks",
			scrollbar: 0
		},
		page: $page
	}
   );
 </script>
</div>
END

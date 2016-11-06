all: cgi-bin/env cgi-bin/pdfbox2
clean:
	rm cgi-bin/env cgi-bin/pdfbox2

cgi-bin/env: lib/env.cgi
	cgi2perl5 --source-path lib/env.cgi --cgi-bin-dir cgi-bin --cgi-lib-dir lib

cgi-bin/pdfbox2: lib/pdfbox2.cgi
	cgi2perl5 --source-path lib/pdfbox2.cgi --cgi-bin-dir cgi-bin --cgi-lib-dir lib

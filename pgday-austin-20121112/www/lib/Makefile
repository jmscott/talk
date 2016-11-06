all: ../cgi-bin/env ../cgi-bin/pdfbox2

../cgi-bin/env: env.cgi
	cgi2perl5 --source-path env.cgi
	mv env ../cgi-bin

../cgi-bin/pdfbox2: pdfbox2.cgi
	cgi2perl5 --source-path pdfbox2.cgi
	mv pdfbox2 ../cgi-bin

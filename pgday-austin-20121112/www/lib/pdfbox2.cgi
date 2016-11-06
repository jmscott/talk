<?xml version="1.0" encoding="UTF-8"?>
<cgi
	name="pdfbox2"
 >
 <title>PDFBox2 Widgets</title>

 <synopsis>
 Query the pdfbox2 schema defined in https://github.com/jmscott/setspace
 </synopsis>
 <subversion
 	id="$Id"
 />
 <blame>John the Scott, jmscott@setspace.com</blame>

 <GET>

 <out content-type="text/html">

  <putter name="text.count">
   <title>Count of Matching PDF Files</title>
   <synopsis>
    Write the count of matching pdf files.
   </synopsis>
   <query-args>
    <arg
    	name="q"
	perl5_re=".{1,256}"
    />
  </query-args>
  </putter>

  <putter name="input.q">
   <title>Text Search Query Input Field</title>
   <synopsis>
    Write an html &lt;input&gt; element seeded with
    the value of a text search query argument.
   </synopsis>
   <query-args>
    <arg
    	name="q"
	perl5_re=".{1,256}"
    />
   </query-args>
  </putter>

 </out>
</GET>
</cgi>

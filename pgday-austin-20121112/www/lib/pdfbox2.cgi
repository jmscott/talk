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

 <out>

  <putter
    name="text.count"
    content-type="text/plain"
  >
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

  <putter
    name="input.q"
    content-type="text/html"
  >
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

  <putter
    name="div.syn"
    content-type="text/html"
  >
   <title>Search Synopsis &lt;div&gt; for a PDF Document Search</title>
   <synopsis>
    Write an html &lt;div&gt; element that summarizes a search for pdf
    documents.
   </synopsis>
   <query-args>
    <arg
    	name="q"
	perl5_re=".{1,256}"
    />
   </query-args>
  </putter>

  <putter
    name="div.nav"
    content-type="text/html"
  >
   <title>Search Navigation &lt;div&gt; for a PDF Document Search</title>
   <synopsis>
    Write an html &lt;div&gt; element that navigations forward/backward
    through a search documents.
   </synopsis>
   <query-args>
    <arg
    	name="q"
	perl5_re=".{1,256}"
    />
    <arg
    	name="page"
	perl5_re="[1-9][0-9]{0,19}"
	default="1"
    />
   </query-args>
  </putter>

  <putter
    name="dl.q"
    content-type="text/html"
  >
   <title>Write an html &lt;dl&gt; of PDF Search Query</title>

   <query-args>
    <arg
    	name="q"
	perl5_re=".{1,256}"
    />
    <arg
    	name="page"
	perl5_re="[1-9][0-9]{0,19}"
	default="1"
    />
   </query-args>
  </putter>

  <putter name="pdf">
   <title>Write a pdf blob</title>
   <query-args>
    <arg
    	name="blob"
	required="yes"
	perl5_re="[a-z][a-z0-9]{0,7}:[[:graph:]]{32,128}"
    />
   </query-args>
  </putter>

  <putter
    name="div.pdfob"
    content-type="text/html"
  >
   <query-args>
    <arg
    	name="blob"
	required="yes"
	perl5_re="[a-z][a-z0-9]{0,7}:[[:graph:]]{32,128}"
    />
    <arg
    	name="page"
	perl5_re="[1-9][0-9]{0,19}"
	default="1"
    />
   </query-args>
  </putter>

 </out>
</GET>
</cgi>

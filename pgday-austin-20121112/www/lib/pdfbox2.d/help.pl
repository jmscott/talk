#
#  Synopsis:
#	Write <div> help page for script pdfbox2.
#  Source Path:
#	lib/pdfbox2.cgi
#  Source SHA1 Digest:
#	No SHA1 Calculated
#  Note:
#	pdfbox2.d/help.pl was generated automatically by cgi2perl5.
#
#	Do not make changes directly to this script.
#

our (%QUERY_ARG);

print <<END;
<div$QUERY_ARG{id_att}$QUERY_ARG{class_att}>
END
print <<'END';
 <h1>Help Page for <code>/cgi-bin/pdfbox2</code></h1>
 <div class="overview">
  <h2>Overview</h2>
  <dl>
<dt>Title</dt>
<dd>PDFBox2 Widgets</dd>
<dt>Synopsis</dt>
<dd>Query the pdfbox2 schema defined in https://github.com/jmscott/setspace</dd>
<dt>Blame</dt>
<dd>John the Scott, jmscott@setspace.com</dd>
  </dl>
 </div>
 <div class="GET">
  <h2><code>GET</code> Request.</h2>
   <div class="out">
    <div class="handlers">
    <h3>Output Scripts in <code>$SERVER_ROOT/lib/pdfbox2.d</code></h3>
    <dl>
     <dt>text.count - Count of Matching PDF Files</dt>
     <dd>
<div class="query-args">
 <h4>Query Args</h4>
 <dl>
  <dt>q</dt>
  <dd>
   <ul>
    <li><code>perl5_re:</code> .{1,256}</li>
   </ul>
  </dd>
  </dl>
</div>
     </dd>
     <dt>input.q - Text Search Query Input Field</dt>
     <dd>
<div class="query-args">
 <h4>Query Args</h4>
 <dl>
  <dt>q</dt>
  <dd>
   <ul>
    <li><code>perl5_re:</code> .{1,256}</li>
   </ul>
  </dd>
  </dl>
</div>
     </dd>
     <dt>div.syn - Search Synopsis &#60;div&#62; for a PDF Document Search</dt>
     <dd>
<div class="query-args">
 <h4>Query Args</h4>
 <dl>
  <dt>q</dt>
  <dd>
   <ul>
    <li><code>perl5_re:</code> .{1,256}</li>
   </ul>
  </dd>
  <dt>pos</dt>
  <dd>
   <ul>
    <li><code>perl5_re:</code> 1|2</li>
   </ul>
  </dd>
  </dl>
</div>
     </dd>
  </dl>
 </div>
</div>
 </div>
</div>
END

1;

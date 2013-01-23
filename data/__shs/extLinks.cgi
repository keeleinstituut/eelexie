#!/usr/bin/perl

push @INC, "./";
require "extLinksProc.pl";

use utf8;
use Encode;
use CGI;

my $q = new CGI;

# kui on parameetrid:
my $dictid = $q->param('dictid');
my $sone = decode_utf8($q->param('sone'));

# kui on POST
if (! $dictid) {
    ($dictid, $sone) = split(/\x{e001}/, decode_utf8($q->param('POSTDATA')));

# kui midagi pole
}
if (! $dictid) {
    $dictid = 'qs_';
    $sone = 'päring';
}

loadlinks ();

binmode (STDOUT, ":utf-8");
print "Content-type: text/html; charset=utf-8\n\n";
print "<HTML>\n";
print "<HEAD>\n";
print << 'JS';
<title>EELex: välised ressursid</title>
<script type="text/javascript" src="/js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="/js/editable.js"></script>
<script type="text/javascript">
JS

print "var dictid=\"$dictid\"\n";
print "var sone=\"$sone\"\n";
print "var scriptname=\"$scriptname\"\n";

print << 'JS';
var avatudaknad = new Array;
var editid;
$(document).ready(function() {
    $('.editable').editable('./extLinksSave.cgi', {
	"type" : 'textarea',
	rows : 1,
	cols : 60,
	submit : 'Salvesta',
	cancel : 'Tühista',
	onreset : jeditableReset,
	"callback" : function(value, settings) {
	    $(editid).css('display','none');
	    location.reload();
	}
    });
    $('.editsone').editable('./extLinksSave.cgi', {
	"callback" : function(value, settings) {
	    uusurl = encodeURI('./extLinks.cgi?dictid='+dictid+'&sone='+value);
	    window.location.href = uusurl;
	}
    });
    function jeditableReset (settings, original) {
	$(editid).css('display','none');
    }
});
$(window).unload(function() {
    $.each (avatudaknad, function(i, val) {
	val.window.close();
    })
});

function editdesc(id, sisu) {
    editid = '#editdesc' + id;
    $(editid).html(sisu);
    $(editid).css('display','inline');
    $(editid).click();
}
function editlink(id, sisu) {
    editid = '#editlink' + id;
    $(editid).html(sisu);
    $(editid).css('display','inline');
    $(editid).click();
}
function openlink(id, link) {
    if ( link.match (/^http/) ) {
	avatudaknad.push ( window.open (encodeURI(link), id) );
    }
}
</script>
<style type="text/css">
#yhisedlingid, #erilisedlingid {
    float: left;
    width: 400px;
    margin: 20px;
}
.lingidiv {
    border-bottom-style: dotted;
    border-color: green;
    border-width: 1;
}
.editsone {
    padding: 20px;
    border-color: green;
    background-color: #E0FFFF;
    text-align: center;
}
.hypatav {
    color: navy;
    cursor: pointer;
}
</style>
JS
print "</HEAD>\n";
print "<BODY>\n";

print "<h2 class=\"editsone\">$sone</h2>\n";
loadlinks ();
printlinks ($dictid, $sone);

print "</BODY>\n";
print "</HTML>\n";

1;

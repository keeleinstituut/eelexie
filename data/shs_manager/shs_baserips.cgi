#!/usr/bin/perl
use strict;

use utf8;
use Encode 'decode_utf8';
binmode(STDOUT, ":utf8");

use POSIX qw(strftime);
use CGI;

use XML::LibXML;
use XML::LibXSLT;


use lib qw( ../ );
use SHS_man;
use SHS_list;
use SHS_cfg (':dir', ':file');


my $q = new CGI;
print $q->header ( -charset => "UTF-8" );

my $ua = $ENV{HTTP_USER_AGENT};
my $ra = $ENV{REMOTE_ADDR};

 
my $eelexid = $q->param('eelexid'); 
my $eelexwv = $q->param('workver');

my $subdir = SHS_test_dir; #mis on vaja

if($eelexwv eq 'T'){
    $subdir=SHS_test_dir;
}else{
    $subdir=SHS_work_dir;
}

my $xsl = $q->param('xlst');

#Vaata mitu kõidet on
my $dicparser = XML::LibXML->new();
my $eelexprefix = 'x';
my $eelexuri = 'http://www.eki.ee/dict/'.$eelexid;
my $lastKF = 3;

my $kfn=0;
my $aeg = strftime("%Y-%m-%dT%H:%M:%S", localtime);

if(-e $subdir."shsconfig_${eelexid}.xml"){
        
        my $things = $dicparser->parse_file($subdir."shsconfig_${eelexid}.xml")->getDocumentElement;
        $lastKF =   $things->findnodes("vols/vol")->size();
        $eelexprefix =   $things->findvalue("dicpr");
        $eelexuri =   $things->findvalue("dicuri");
        
}else{
        print "Puudu: ".$subdir."shsconfig_${eelexid}.xml";
        die("Puudu: ".$subdir."shsconfig_${eelexid}.xml");
    }


my $lexName ='Täitmine';

#üleüldse vead
if($eelexid eq ''){
        print "<h2>Viga. </h2>";
        exit;
}

print <<"LoginPage";
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
	<head>
		<title>$lexName</title>
		<META http-equiv="Content-Type" content="text/html; charset=utf-8">
		
<script type="text/javascript">
//<![CDATA[ 
var t;
 t=setTimeout("doTimer()",1000);
function doTimer(){
//kerib
    window.scrollTo(0, document.body.scrollHeight);
    if (document.getElementById('end')==null){ //kui lõpus on element käes siis enam ei tee
         t=setTimeout("doTimer()",500);
    }
}

//]]> 
</script>


	</head>
	<body>
				
		<H2>$lexName</H2>
		ID: $eelexid<br />
		Prefix: $eelexprefix<br />
		Uri: $eelexuri<br />
		<br />
		<br />
LoginPage



 for ($kfn = 1; $kfn <= $lastKF; $kfn++) {
  
  print 'valmib '.$kfn.':'.strftime("%Y-%m-%dT%H:%M:%S", localtime).'.<br />' ;
    tee( $subdir.'__sr/'.$eelexid.'/'.$eelexid.$kfn.'.xml');
 }
 
print 'valmis:'.strftime("%Y-%m-%dT%H:%M:%S", localtime).'.<br />' ;


sub tee{
    my ($fail) = @_;
    my $xslt = XML::LibXSLT->new();
  
    my $source = XML::LibXML->load_xml(location => $fail);
    my $style_doc = XML::LibXML->load_xml(string=>$xsl , no_cdata=>1);

    my $stylesheet = $xslt->parse_stylesheet($style_doc);
    my $results = $stylesheet->transform($source);
  

    open FILE, ">", $fail or die $!;
    #binmode(FILE, ":utf8");
    print FILE $stylesheet->output_as_bytes($results);
1;   
}


print <<"LoginPage2";	
        <h2 id="end"> Valmis </h2>
        <a href="/">Algusesse</a> <br/> <a href="../shs_login.cgi?app_id=$eelexid">Sõnastiku juurde</a> <br/> <a href="/shs_list.cgi#$eelexid">Nimekirja juurde</a>
		</body>
</html>

LoginPage2


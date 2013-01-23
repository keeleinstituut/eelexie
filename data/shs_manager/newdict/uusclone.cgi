#!/usr/bin/perl
use strict;
#teeb uue sõnastiku teisenduse

use utf8;
use Encode 'decode_utf8';
binmode(STDOUT, ":utf8");

use POSIX qw(strftime);
use CGI;
use XML::LibXML;


use lib qw( ../ );
use SHS_man;
use SHS_list;
use SHS_cfg (':dir', ':file');


my $q = new CGI;
print $q->header ( -charset => "UTF-8" );

my $ua = $ENV{HTTP_USER_AGENT};
my $ra = $ENV{REMOTE_ADDR};


 
my $eelexid = $q->param('app_id'); 
my $eelexidv = $q->param('app_idv'); 
my $eelexprefix = 'x';
my $eelexuri = 'http://www.eki.ee/dict/'.$eelexid;
my $eelexnimiet = $q->param('eelexnimiet'); 
my $eelexnimien = $q->param('eelexnimien'); 


my $lexName ='Teeme '.$eelexnimiet;

if($eelexid eq ''){
        print "<h2>käivita uus.htm'ist</h2>";
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
		Vana id: $eelexidv<br />
		Nimi: $eelexnimiet<br />
		Nimi: $eelexnimien<br />


		<br />
		<br />
LoginPage


#D - data,B - backup, R - rootconfig, C - config,G - generated,L - Logsm, T - temp, N - aluspuu(siin ei kasuta), K - sõnastiku omad kaustad
#D|B|R|C|G|L|T|N|K

SHS_man::SHS_doprint_level(1);


#SHS_man::SHS_set_Langs('__lang__',$eelexlang);
SHS_man::SHS_set_src('x','http://www.eki.ee/dict/'.$eelexidv,$eelexidv,SHS_work_dir);
SHS_man::SHS_set_dest('x','http://www.eki.ee/dict/'.$eelexid,$eelexid ,SHS_test_dir);
SHS_man::SHS_dofiles(\&SHS_man::SHS_dodict_cloneFnP,'D|R|C|G|K|N');


print "<br />lisan kirje lexlisti <br />";

my %nimed;
$nimed{'et'} = $eelexnimiet;

unless($eelexnimien eq ''){
    $nimed{'en'} = $eelexnimien;
}
SHS_man::SHS_clear_err();
SHS_man::SHS_clear_msg();
SHS_man::SHS_clear_log();
 
#($id, $type, $er, $lf, $note, $comment, ( 'et' => "nimi" , 'en' => "name" ))
my $comment= "${eelexidv}'ist genereerinud: $ENV{REMOTE_USER} ".strftime("%Y-%m-%dT%H:%M:%S", localtime);
$a = SHS_list::makeLLelement($eelexid , 'Uus', 'T', '', 'Kontrollimata',$comment , %nimed);
SHS_list::addAlterLLelement($eelexid ,$a,'');

my $fex2='';

if($eelexidv eq 'ex2'){
  $fex2= '<a href="uusex2.cgi?app_id='.$eelexid.'">Täida EX andmetega</a> <br/>';
}

print <<"LoginPage2";	
        <h2 id="end"> Valmis </h2>
        $fex2 <a href="../../shs_login.cgi?app_id=$eelexid">Sõnastiku avalehele</a> <br/> <a href="../shs_list.cgi$eelexid">Sõnastike haldusesse<br/> <a href="/">EELexi avalehele</a></a>
		</body>
</html>

LoginPage2


#!/usr/bin/perl
use strict;

use utf8;
use Encode 'decode_utf8';
binmode(STDOUT, ":utf8");

use POSIX qw(strftime);
use CGI;


use lib qw( ../ );
use SHS_man;
use SHS_list;
use SHS_cfg (':dir', ':file');


my $q = new CGI;
print $q->header ( -charset => "UTF-8" );

my $ua = $ENV{HTTP_USER_AGENT};
my $ra = $ENV{REMOTE_ADDR};


 
my $eelexid = $q->param('app_id'); 


#my $eelexid = 'aaa'; 
my $eelexprefix = 'x';
my $eelexuri = 'http://www.eki.ee/dict/'.$eelexid;
my $kfn=1;


my $veelexid = 'ex_'; 
my $veelexprefix = 'x';
my $veelexuri = 'http://www.eki.ee/dict/ex';


my $lexName ='Täitmine';

if($eelexid eq ''){
        print "<h2>Viga. </h2>";
        exit;
}

print <<"LoginPage";
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
	<head>
		<META http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" type="text/css" href="../../eelex.css" />
		
	    <style type="text/css">
            .style1
            {
                width: 100%;
            }
                    input
        {            width: 95%;
        }
        </style>
		<title>$lexName</title>
		    <script language="javascript" type="text/javascript">
// <![CDATA[
        function loadLang() {
            var xmlhttp;
            if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
                xmlhttp = new XMLHttpRequest();
            }
            else {// code for IE6, IE5
                xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
            }
            xmlhttp.onreadystatechange = function () {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                   
                    langlist = document.getElementById('eelexlang');
                    langlist.options.length = 0;
                    
                    tec=0;
                    maas=0; 
                    x = xmlhttp.responseXML.documentElement.getElementsByTagName("record");
                    for (i = 0; i < x.length; i++) {
                        xx = x[i].getElementsByTagName("name");
                        {
                            // see tasub uuesti kirjutada
                            tec ='0';
                            try {
                                tec = x[i].getAttribute("technical");
                            }
                            catch (er) {
                            }
                            if(tec!='1'){
                                try {
                                    a = x[i].getAttribute("code");
                                    langlist.options[i+maas] = new Option(a + " - " + xx[0].firstChild.nodeValue.slice(0, 28), a);
                                }
                                catch (er) {
                                }
                            }else{
                            //et ära jäetud keelte asemele augud ei jääks
                                maas--;
                            }
                            
                        }
                    }

                 //   document.getElementById('debug').innerHTML = txt.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");

                }
            }
            xmlhttp.open("GET", "/iso639_1.xml", true);
            xmlhttp.send();
        }
// ]]>
    </script>
    </head>
	<body onload="loadLang();">
<div id="kasutajad" class="sektsioon">	
		<H2>$lexName</H2>
		ID: $eelexid<br />
		<br />
		<br />
LoginPage

system('cp -p '.SHS_work_dir.'__sr/ex_/ex_1.xml '.SHS_test_dir.'__sr/'.$eelexid.'/'.$eelexid.'1.xml');
system('cp -p '.SHS_work_dir.'__sr/ex_/ex_2.xml '.SHS_test_dir.'__sr/'.$eelexid.'/'.$eelexid.'2.xml');
system('cp -p '.SHS_work_dir.'__sr/ex_/ex_3.xml '.SHS_test_dir.'__sr/'.$eelexid.'/'.$eelexid.'3.xml');


my $aeg = strftime("%Y-%m-%dT%H:%M:%S", localtime);

print 'Esimene:'.$aeg.'-<br />' ;
tee( SHS_test_dir.'__sr/'.$eelexid.'/'.$eelexid.'1.xml');
print 'Teine:'.strftime("%Y-%m-%dT%H:%M:%S", localtime).'-<br />' ;
$kfn=2;
tee( SHS_test_dir.'__sr/'.$eelexid.'/'.$eelexid.'2.xml');
print 'Kolmas:'.strftime("%Y-%m-%dT%H:%M:%S", localtime).'-<br />' ;
$kfn=3;
tee( SHS_test_dir.'__sr/'.$eelexid.'/'.$eelexid.'3.xml');
print 'valmis:'.strftime("%Y-%m-%dT%H:%M:%S", localtime).'-<br />' ;



sub tee($){
my ($fail) = @_;
    open(FILE, $fail) || die("Cannot Open File input '$fail'");
    my(@fcont) = <FILE>;
    close FILE;

    open(FOUT,">$fail") || die("Cannot Open File output '$fail'");
    foreach my $line (@fcont) {
        $line =~ s/$veelexuri/$eelexuri/g;

        print FOUT $line;
    }
    close FOUT;
    @fcont = ();
}

print <<"LoginPage2";	
<h2>Vali sisu</h2>			
       <form id="uuseelex" action="uusex3.cgi" method="post">
	    <table id="thetable" class="style1">
            <tr>
                <td align="right">
                    Sõnastiku id:</td>
                <td>
                     <input id="Hidden1" type="hidden" name="id" value="$eelexid"/>
                    <h2>$eelexid</h2></td>
                <td>
                    &nbsp;</td>
            </tr>
            
            <tr>
                <td align="right">
                    Maht:</td>
                <td>
                    <select id="Select1" name="maht">
                        <option value="-">Kõik</option>
                        <option value="K">Keskmine</option>
                        <option value="V">Väike</option>
                        <option value="D">Demo</option>
                        <option value="P">Põhisõnavara</option>
                    </select></td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td align="right">
                    keel:</td>
                <td>
                    <select id="eelexlang" name="eelexlang">
                        <option value="-">Laadimisel</option>

                    </select></td>
                <td>
                    &nbsp;</td>
            </tr>
            
            <tr>
                <td align="right">
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
            </tr>
          
            <tr>
                <td align="right">
                    &nbsp;</td>
                <td>
                    <input style="width:10em" id="Submit1" type="submit" value="submit" /></td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td align="right">
                    <a href="shs_list.cgi#$eelexid">Tagasi nimekirja juurde</a>&nbsp;</td>
                <td>
                    &nbsp;</td>
                <td>
                    &nbsp;
                    </td>
                    
            </tr>
            
        </table>
       </form>
	 </div>
  </body>
</html>

LoginPage2


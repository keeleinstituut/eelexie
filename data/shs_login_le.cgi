#!/usr/bin/perl
use strict;

use utf8;
use Encode 'decode_utf8';
binmode(STDOUT, ":utf8");

use CGI;
use Socket;
use XML::LibXML;

use Tie::File;
use POSIX qw(strftime);

print "Content-type: text/html; charset=utf-8\n\n";

my $q = new CGI;
my $ua = $ENV{HTTP_USER_AGENT};
my $ra = $ENV{REMOTE_ADDR};
my $hn = gethostbyaddr(inet_aton($ra), AF_INET);
my $usrName = $ENV{REMOTE_USER};

#võta keel ja kui puudub siis pane eesti
my $APP_LANG  =$q->param('app_lang');
if($APP_LANG eq ''){
  $APP_LANG ='et';
}

my $lexId ="elt"; 

my $dicparser = XML::LibXML->new();
#nupud sisse välja
my $testEnabled;
my $workEnabled;
my $lexName;
my $lexNote;

if($lexId eq ""){ #id'd ei antud
   $lexName="NO app_id";
   $testEnabled = 'disabled="disabled"';
   $workEnabled = 'disabled="disabled"';
}else{
      # lae sõnastiku nimi
      # kui faili pole tuleb brauserisse tühi väljund 
      my $lcDom = $dicparser->parse_file('lexlist.xml');
      
      $lexName =$lcDom->documentElement()->findvalue("lex[\@id = '${lexId}']/name[\@l = '${APP_LANG}']");
      if($lexName eq ""){#kui soovitud keeles pole siis päri 'et'
         $lexName =$lcDom->documentElement()->findvalue("lex[\@id = '${lexId}']/name[\@l = 'et']"); 
         
         if($lexName eq ""){# kui ikka nime ei leitud
          $lexName="Sõnastikku ei leitud";
         }
      }
      #millised nupud lahti
      my $er =$lcDom->documentElement()->findvalue("lex[\@id = '${lexId}']/\@er");
     
      $lexNote=$lcDom->documentElement()->findvalue("lex[\@id = '${lexId}']/note"); 
      if($lexNote eq ""){
      $lexNote ="";
      }else{
      $lexNote ="<br/>".$lexNote;
      }
      if($er ne "WT"){

          if($er eq ""){
              $testEnabled = 'disabled="disabled"';
              $workEnabled = 'disabled="disabled"';
          }

          if($er eq "W"){
              $testEnabled = 'disabled="disabled"';
          }

          if($er eq "T"){
              $workEnabled = 'disabled="disabled"';
          }
      }
      
}

# app_nimetus võiks ka kaasa panna
# kasutaja võiks kuidagi nupud lahti saada või on dev login eraldi
# HTML'is kasutatud muutujad $lexName $lexId $APP_LANG $workEnabled $testEnabled $lexNote

print <<"LoginPage";
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
    <head>
        <title>$lexName - login</title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <script type="text/javascript">
            <!--
            var uaname = "$ua";

            function pl()
            {
                if (uaname.indexOf(" MSIE") < 0) {
                    dicenter.disabled = true;
                    dicdemo.disabled = true;
                    notes.innerHTML = "Palun kasutada <b>MSIE 8.0+</b>!";
                }
            }

            function GoToWork() {
				if (uaname.indexOf(" MSIE") < 0) {
					// if ("$lexId" == "ess" \|\| "$lexId" == "ies" \|\| "$lexId" == "mer" \|\| "$lexId" == "ems" \|\| "$lexId" == "har") {
						sdata.action = "__shs/art_dx.cgi";
						sdata.submit();
					// }
					// else {
					//	alert("Palun kasuta IE9 ! (Sõnastiku ettevalmistus!)");
					// }
				}
				else {
					sdata.action = "__shs/art_le.cgi";
					sdata.submit();
				}
            }

            function GoToDemo(event) {
				if (uaname.indexOf(" MSIE") < 0) {
					sdata.action = "__shs_test/art_dx.cgi";
				}
				else {
					sdata.action = "__shs_test/art_le.cgi";
				}
				sdata.submit();
            }
            -->
        </script>
    </head>
    <body>
        <br/>
        <br/>
        <table width="100%" border="0"><tr>
                <td width="14%"><img src="EELEX_tume.png" alt="" id="eeLex" title="EELex logo"></td>
                <td width="68%" bgcolor="#FFFFFF"><div align="center"><H2>$lexName</H2>$lexNote</div></td>
                <td width="18%">&nbsp;</td>
            </tr></table>
        <table style="WIDTH: 100\%; HEIGHT: 70px; BACKGROUND-COLOR: silver" align="center">
            <tr>
                <td align="center"><input id="dicenter" name="dicenter" type="button" $workEnabled value="Tööversioon" onclick="GoToWork()"></td>
                <td align="center"><input id="dicdemo" name="dicdemo" type="button" $testEnabled value="Testversioon" onclick="GoToDemo(event)"></td>
            </tr>
        </table>
        <br/>
        <br/>
        <hr width="100%" SIZE="1">
        <div id="ua" style="color:gray;font-size:x-small">Brauser $ua</div>
        <div id="from" style="color:gray;font-size:x-small">aadressilt: $ra ($hn)</div>
        <br/>
        <div id="notes" style="color:red;font-size:small"></div>
        <br />
        <form name="sdata" method="post" action="__shs_test/art_le.cgi">
            <input id="app_id" name="app_id" type="hidden" value="$lexId">
            <input id="app_lang" name="app_lang" type="hidden" value="$APP_LANG">
        </form>
    </body>
</html>

LoginPage

# Logime ka
use lib qw( ./ );
use Browscap;

my $stime = strftime("%Y-%m-%dT%H:%M:%S", localtime);

my $browscap=new HTTP::Browscap('browscap.ini');
$browscap || die("Browscap.ini did nto initialize: $!");
my $browser=$browscap->identify($ua);
my $winx = 'nonwin';
$winx = 'win16' if($browser->{'win16'} eq 'true'); 
$winx = 'win32' if($browser->{'win32'} eq 'true'); 
$winx = 'win64' if($browser->{'win64'} eq 'true'); 
$browser || ($browser = {platform => 'na',platform_version => 'na',ismobiledevice => 'na',browser => 'na',version => 'na',javascript => 'na',javaapplets => 'na',vbscript => 'na',activexcontrols => 'na'});
my $lostr = '"'. $stime.'","'. $ra.'","'.$usrName.'","'.$lexId.'","'.$winx.'","'.$browser->{'platform'}.'","'.$browser->{'platform_version'}.'","'.$browser->{'ismobiledevice'}.'","'.$browser->{'browser'}.'","'.$browser->{'version'}.'","'.$browser->{'javascript'}.'","'.$browser->{'javaapplets'}.'","'.$browser->{'vbscript'}.'","'.$browser->{'activexcontrols'}.'"';

my @logLines;
tie(@logLines, 'Tie::File', "/var/log/eelex_visits.log");
push(@logLines, $lostr);
untie(@logLines);

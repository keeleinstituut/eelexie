#!/usr/bin/perl
use strict;

use utf8;
use Encode 'decode_utf8';
binmode(STDOUT, ":utf8");

use Switch;
use XML::LibXML;
use CGI;
use Socket; #ja miks seda vaja on ?
use POSIX qw(strftime);
use File::Basename;

my $q = new CGI;
print $q->header ( -charset => "UTF-8" );

use lib qw( ./ );
use SHS_man;
use SHS_cfg (':dir', ':file');

my $SHS_backup_dir = SHS_backup_dir; 


my $dicparser = XML::LibXML->new();

my $logi="";
my $id ="";
my $nameet ="";

my $LLDOM;
my $LLRoot;
my $nodes;
my $rnode;

$LLDOM = $dicparser->parse_file(SHS_lexlist_file);
$LLRoot = $LLDOM->getDocumentElement;


my $dicpr='';
my $dicuri ='';


 
$id = $q->param('app_id');
$nodes = $LLRoot->findnodes("lex[\@id='${id}']");
$rnode = $nodes->get_node(1);
if($rnode eq undef){
print "<h2>viga: Ei leia kirjet. (app_id='$id')<a href=\"shs_list.cgi\">Tagasi Nimekirja juurde</a></h2>";
exit;
}
$nameet = $rnode->findvalue("name[\@l='et']");

if(-r SHS_work_dir."shsconfig_$id.xml"){
    $dicpr = $dicparser->parse_file(SHS_work_dir."shsconfig_$id.xml")->getDocumentElement->findvalue('dicpr');
    $dicuri = $dicparser->parse_file(SHS_work_dir."shsconfig_$id.xml")->getDocumentElement->findvalue('dicuri');
}
if($dicuri eq ''){
    if(-r SHS_test_dir."shsconfig_$id.xml"){
        $dicpr = $dicparser->parse_file(SHS_test_dir."shsconfig_$id.xml")->getDocumentElement->findvalue('dicpr');
        $dicuri = $dicparser->parse_file(SHS_test_dir."shsconfig_$id.xml")->getDocumentElement->findvalue('dicuri');
    }
}


my $pvorm;
if($q->request_method()eq "POST"){ 
$pvorm=1;
print<<"axa";
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <link rel="stylesheet" type="text/css" href="../eelex.css" />
        <meta http-equiv="Content-type" content="text/html;charset=UTF-8" />
        <title>Sõnastiku $id Toimingud</title>
        <script type="text/javascript">
        //<![CDATA[ 
        var t;
        t=setTimeout("doTimer()",1000);
        function doTimer(){
            window.scrollTo(0, document.body.scrollHeight);

            if (document.getElementById('end')==null){ //kui lõpus on element käes siis enam ei tee
                 t=setTimeout("doTimer()",500);
            }
        }

        //]]> 
        </script>
        <style type="text/css">
            .style1
            {
                width: 100%;
            }

        </style>
    </head>
    <body>
axa

my $sDir;  #selected dir
my $nsDir;  #mitte valitud 
my $suund; #logi jaoks
my $margitud; #logi jaoks

if($dicuri eq ''){
 print ' (dicuri ei leitud)';
}

my $er = $q->param('er');
if($er ne 'T' && $er ne 'W'){
 print '<h2>versioooni valik tegemata</h2>';
 exit;
}


my $operation = $q->param('operation');

if($operation ne 'copy' && $operation ne 'delete' && $operation ne 'backup' && $operation ne 'restore' && $operation ne 'clean' ){
 SHS_man::logi($id, 1 ,strftime("%Y%m%dT%H%M%S", localtime), "Üritati teha puuduvat tegevust:".$operation);
 print '<h2>Halb tegevus</h2>';
 exit;
}

my $copyname = $q->param('copyname');

my $note = $q->param('note');

my $dotypes;
my $dotypesns; # ilma eraldajata
 foreach ('doR', 'doC', 'doG', 'doD', 'doL', 'doT', 'doB') {# K tuleb ka läbi mõelda ,N siia ei kõlba
  	$dotypes .= $q->param($_);
  	$dotypesns .= $q->param($_);
 } 
$dotypes =~ s/\B/|/g;

if($er eq 'T'){
  $sDir=SHS_test_dir;
  $nsDir=SHS_work_dir; 
  $suund='Test - > Work';
  $margitud='Test';
}else{
  $sDir=SHS_work_dir;
  $nsDir=SHS_test_dir;
  $suund='Work - > Test';
  $margitud='Work';
}

SHS_man::SHS_doprint_level(1);
#D - data,B - backup, R - rootconfig, C - config,G - generated,L - Logsm, T - temp, N - aluspuu(siin ei kasuta), K - sõnastiku omad kaustad
#D|B|R|C|G|L|T|N|K
SHS_man::SHS_set_src($dicpr,$dicuri,$id ,$sDir);
SHS_man::SHS_set_dest($dicpr,$dicuri,$id ,$nsDir);

if($operation eq 'clean' ){
SHS_man::logi($id, 1 ,strftime("%Y%m%dT%H%M%S", localtime), "Tühjendati baas: $margitud Mess: $note");
 SHS_man::SHS_MakeBase(1);
}


if($operation eq 'delete' ){
SHS_man::logi($id, 1 ,strftime("%Y%m%dT%H%M%S", localtime), "Kustutati:$dotypes, $margitud Mess: $note");
 SHS_man::SHS_dofiles(\&SHS_man::SHS_dodict_delete, $dotypes);
}

if($operation eq 'copy' ){
 SHS_man::logi($id, 1 ,strftime("%Y%m%dT%H%M%S", localtime), "Kopeeriti:$dotypes, $suund Mess: $note");
 SHS_man::SHS_dofiles(\&SHS_man::SHS_dodict_copy, $dotypes.'|K');
}

if($operation eq 'backup' ){

##temp kausta nimi
my $temproot = SHS_temp_dir."bac_$ENV{REMOTE_USER}_".strftime("%Y%m%dT%H%M%S", localtime).'/';
# loo tmp
system('mkdir -p '.$temproot);
if ($? == -1) {
    die( "mkdir failed to execute: $!, stoped");
}
if($? == 0){
    chmod(0775, $temproot) 
}
 
 # kopy tempi
 SHS_man::SHS_set_dest($dicpr,$dicuri,$id ,$temproot);
 SHS_man::SHS_dofiles(\&SHS_man::SHS_dodict_copy, $dotypes.'|K|N');
 
 SHS_man::logi($id, 1 ,strftime("%Y%m%dT%H%M%S", localtime), "Varundati:$dotypes, $margitud Mess: $note");
 ## backup nimi
 my $backupfile = $id.'_'.$er.'_'.strftime("%Y-%m-%dT%H:%M:%S", localtime).'_'.$dotypesns.'.tar.gz';
 SHS_man::logi($id, 0 ,$backupfile, $note);
 $backupfile = SHS_backup_dir.$backupfile;
 # paki
 print "tar -zcf $backupfile -C $temproot . ";
 system("tar -zcf $backupfile -C $temproot .");
 
 # kustuta temp
 system('rm -f -r '.$temproot);
    

}

if($operation eq 'restore' ){

##temp kausta nimi
my $temproot = SHS_temp_dir."res_$ENV{REMOTE_USER}_".strftime("%Y%m%dT%H%M%S", localtime).'/';
# loo tmp
system('mkdir -p '.$temproot);
if ($? == -1) {
    die( "mkdir failed to execute: $!, stoped");
}
if($? == 0){
    chmod(0775, $temproot) 
}
 SHS_man::logi($id, 1 ,strftime("%Y%m%dT%H%M%S", localtime), "Taastati:$dotypes, $margitud Mess: $note");
 # paki

 print "tar -xpf $SHS_backup_dir$copyname -C $temproot<br/>";
 system("tar -xpf $SHS_backup_dir$copyname -C $temproot");
 
 # kopy temp'ist välja
 SHS_man::SHS_set_src($dicpr,$dicuri,$id ,$temproot);
 SHS_man::SHS_set_dest($dicpr,$dicuri,$id ,$sDir);

 SHS_man::SHS_dofiles(\&SHS_man::SHS_dodict_copy, $dotypes.'|K');
 # kustuta temp
 system('rm -f -r '.$temproot);


}





    print '<h2 id="end"> Valmis </h2><a href="shs_operations.cgi?app_id='.$id.'">Toimingu lehele</a> <br/>';
    print '<a href="shs_list.cgi">Tagasi nimekirja juurde</a>';
    print '</body></html>';

}

my $dodypes='';
	foreach my $cc ($dicparser->parse_file(SHS_dmacro_id_file)->getDocumentElement->findnodes('dotypes/dotype[./@user=\'T\']')) {
	my	$dok = $cc->findvalue('@id');
	my	$don = $cc->findvalue('@name');
	my	$doS = $cc->findvalue('./description');
      #<label for="doB">backup</label><input id="doB" type="checkbox" name="doB" value="B"/><br/>
      #${dok}${don}${doS}
    $dodypes .=  "<input id=\"do${dok}\" title=\"${doS}\" type=\"checkbox\" name=\"do${dok}\" value=\"${dok}\"/><label title=\"${doS}\" for=\"do${dok}\"> ${don}</label><br/>"
	}

exit if($pvorm);

my $koopjad = '';

foreach (<$SHS_backup_dir*>){
    #kas fail pakub meile huvi
    my $filename= fileparse($_);
    unless($filename=~m/(${id}_([WT])_(.*)_(.*)).tar.gz/){
        next;
    }
    $koopjad .="<option value=\"$filename\">$1</option>";

}




# document out 
# kasutatud muutujad $id, $nameet, $koopjad

print<<"axa";
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <link rel="stylesheet" type="text/css" href="../eelex.css" />
        <meta http-equiv="Content-type" content="text/html;charset=UTF-8" />
        <title>Sõnastiku $id Toimingud</title>
        <style type="text/css">
            .style1
            {
                width: 100%;
            }

        </style>
    </head>
    <body>
        <div id="kasutajad" class="sektsioon"><h2>Sõnastiku $id toimingud</h2>
            <form id="fo" action="shs_operations.cgi" method="post">
            <input id="Hidden1" type="hidden" name="app_id" value="$id"/>
                <table>
                    <tr>
                        <td align="center">
                            <h3>$id</h3></td>
                        <td align="center">
                            <h3>$nameet</h3></td>
                        <td>
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td align="right">
                            sõnastik:
                        </td>
                        <td>
                            <select id="Select1" name ="er">
                                <option value="">Vali versioon</option>
                                <option value="W">Tööversioon</option>
                                <option value="T">Testersioon</option>
                            </select>
                        </td>
                        <td>
                            Vali millise versiooniga toiminguut teha soovid.
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            toiming:
                        </td>
                        <td>
                            <select id="Select2" name ="operation">
                                <option value="">Vali toiming</option>
                                <option value="copy">kopeeri välja</option>
                                <option value="delete">kustuta</option>
                                <option value="clean">Tühjenda baas</option>
                                <option value="backup">varunda</option>
                                <option value="restore">taasta</option>
                            </select>
                        </td>
                        <td>
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            Fail taastamiseks:
                        </td>
                        <td>
                            <select id="Select3" name ="copyname">
                                <option value="">Vali koopia</option>
                                $koopjad
                                </select>
                        </td>
                        <td>
                            Kasutatakse ainult taastamise ajal.&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            osad:
                        </td>

                        <td>
                              $dodypes
                        </td>
                        <td>
                            Osad millega toimingut tehakse. Vihjed tooltipis.&nbsp;
                        </td>
                    </tr>
                     <tr>
                    <td align="right">
                        märkus oma tegevuse kohta:</td>
                    <td>
                       <input id="Text3" type="text" name="note" value="" /></td> 
                    <td>
                        Võib tühjaks jääda.</td>
                    </tr>
                    <tr>
                        <td align="right">
                            <a href="shs_list.cgi#$id">Tagasi nimekirja juurde</a>&nbsp;</td>
                        <td>
                            <input id="Submit1" type="submit" value="submit" /></td>
                        <td>
                            &nbsp;
                        </td>

                    </tr>
                </table>
            </form>
        </div>
    </body>
</html>
axa

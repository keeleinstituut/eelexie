#!/usr/bin/perl
use strict;

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
 my($eelexid, $Veelexid, $Veelexprefix, $Veelexuri, $eelexid, $eelexprefix, $eelexuri,$eelexnimiet,$eelexnimien, $er  );
 my $viga='';
if($q->request_method()eq "POST"){ 

    $eelexid = $q->param('app_id'); 
    
    $Veelexid = $q->param('Vapp_id'); 
    
    my $dicparser = XML::LibXML->new();
    if(-r SHS_work_dir."shsconfig_$Veelexid.xml"){
        $Veelexprefix = $dicparser->parse_file(SHS_work_dir."shsconfig_$Veelexid.xml")->getDocumentElement->findvalue('dicpr');
        $Veelexuri = $dicparser->parse_file(SHS_work_dir."shsconfig_$Veelexid.xml")->getDocumentElement->findvalue('dicuri');
    }
    if($Veelexuri eq ''){
        if(-r SHS_test_dir."shsconfig_$Veelexid.xml"){
            $Veelexprefix = $dicparser->parse_file(SHS_test_dir."shsconfig_$Veelexid.xml")->getDocumentElement->findvalue('dicpr');
            $Veelexuri = $dicparser->parse_file(SHS_test_dir."shsconfig_$Veelexid.xml")->getDocumentElement->findvalue('dicuri');
        }
    }
    if($Veelexuri eq ''){
     $viga.='Ei leitud vana versiooni shsconfig_$id.ixl ';
    }

    $er = $q->param('er'); 
    if($er eq 'T'){
        $er=SHS_test_dir;
    }else{
        $er=SHS_work_dir;
    }
    
     $eelexprefix = 'x';
     $eelexuri = 'http://www.eki.ee/dict/'.$eelexid;
     $eelexnimiet = $q->param('eelexnimiet'); 
     $eelexnimien = $q->param('eelexnimien'); 


    my $lexName ='Teeme '.$eelexnimiet;

    if($eelexid eq ''){
            print "<h2>Käivita õigest kohast</h2>";
            exit;
    }
if($viga eq ''){#parem kontroll vaja
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
        Vana ID: $Veelexid<br />
        Vana prefix: $Veelexprefix<br />
        Vana Uri: $Veelexuri<br />
        Nimi: $eelexnimiet<br />
        Nimi: $eelexnimien<br />


        <br />
        <br />
LoginPage


    #D - data,B - backup, R - rootconfig, C - config,G - generated,L - Logsm, T - temp, N - aluspuu(siin ei kasuta), K - sõnastiku omad kaustad
    #D|B|R|C|G|L|T|N|K

    SHS_man::SHS_doprint_level(1);


    #SHS_man::SHS_set_Langs('__lang__',$eelexlang);
    SHS_man::SHS_set_src($Veelexprefix,$Veelexuri,$Veelexid,$er);
    SHS_man::SHS_set_dest($eelexprefix,$eelexuri,$eelexid ,SHS_test_dir);
    SHS_man::SHS_dofiles(\&SHS_man::SHS_dodict_cloneF,'D|R|C|G|K|N');


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
    my $comment= "Loodud: $ENV{REMOTE_USER} ".strftime("%Y-%m-%dT%H:%M:%S", localtime);
    $a = SHS_list::makeLLelement($eelexid , 'Uus', 'T', '', 'Kontrollimata',$comment , %nimed);
    SHS_list::addAlterLLelement($eelexid ,$a,'');


print <<"LoginPage2";	
        <h2 id="end"> Valmis </h2>
        <a href="/">Algusesse</a> <br/> <a href="shs_baserip.cgi?app_id=$eelexid&app_ver=T">Tee osasõnastik</a> <br/><a href="../shs_login.cgi?app_id=$eelexid">Sõnastiku juurde</a> <br/> <a href="shs_list.cgi#$eelexid">Nimekirja juurde</a>
        </body>
</html>

LoginPage2
exit;
}#kas kopeerida
}#kas on postitatud
$Veelexid = $q->param('Vapp_id');

my $newoyt ='';

$newoyt  ='<option value="W">Tööversioon</option>' if(-r SHS_work_dir."shsconfig_$Veelexid.xml");
$newoyt .='<option value="T">Testversioon</option>' if(-r SHS_test_dir."shsconfig_$Veelexid.xml");
$newoyt  ='<option value="">Ei leia versioone</option>' if($newoyt eq '');

print <<"LoginPage3";	
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Uue sõnastiku loomine $lexName'ist</title>
    <style type="text/css">
        .style1
        {
        }
        .style2
        {
            height: 26px;
        }
        .style3
        {
            height: 27px;
        }
        input
        {            width: 95%;
        }
        .punane
        {
        color:red;
        }
        .must
        {
        color:black;
        }
    </style>
    <script language="javascript" type="text/javascript">
// <![CDATA[

//täidab rippmenüü keeltega
        function checkid() {
            tid =document.getElementById('eelexid').value
            var xmlhttp;
            if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
                xmlhttp = new XMLHttpRequest();
            }
            else {// code for IE6, IE5
                xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
            }
            xmlhttp.onreadystatechange = function () {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    var longstring = xmlhttp.responseText;
                    if(longstring=="true"){
                       setvhint('vid','punane',"On juba kasutusel");
                       document.getElementById("Submit1").disabled =true;
                       
                    }else{
                       reg=/^[a-z][a-z0-9][a-z0-9_]\$/;
                       if(reg.exec(tid)==null){
                          setvhint('vid','punane',"Peab olema 3 märki: [a-z][a-z0-9][a-z0-9_]");
                          document.getElementById("Submit1").disabled =true;
                       }else{
                         setvhint('vid','must',"väli: OK");
                         document.getElementById("Submit1").disabled=false;
                       }

                    }
                       if(document.getElementById('eelexnimiet').value.length<3){
                             setvhint('vnimiet','punane',"väli on kohustuslik");
                             document.getElementById("Submit1").disabled =true;
                       }else{
                          setvhint('vnimiet','must',"väli: OK");
                       }

                }
            }
            xmlhttp.open("GET", "idfree.cgi?id="+tid, true);
            xmlhttp.send();
        }
       
        
        //muuda vihjet
        function setvhint(name, classname, text ){
        
             document.getElementById(name).className = classname;
             document.getElementById(name).innerHTML = text;
             
        }

             //näitest tekstiväljale
        function n2txt(see,kuhu) {
            document.getElementById(kuhu).value = see.innerHTML;
            valideeri();
        }

// ]]>
    </script>
</head>
<body>
<div id="debug" onload="checkid()"></div>
    <div >
        <div style="border: thin solid #000000;" align="center">
        <form id="uuseelex" action="shs_clone.cgi" method="post">
            <input id="eelexidf" name="Vapp_id" type="hidden" value="$Veelexid" />
            <table class="style1">
                <tr>
                    <td align="left">
                        Uue sõnastiku info:
                    </td>
                    <td align="left">
                        &nbsp;
                    </td>
                    <td align="left">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        sõnastiku id: 
                    </td>
                    <td align="left">
                        <input id="eelexid" name="app_id" type="text" value="$eelexid" />
                    </td>
                    <td align="left">
                    <span id="vid" class="punane" >Viga: sisestamata</span><br/>
                      
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        sõnastiku versioon: 
                    </td>
                    <td align="left">
                            <select id="Select1" name ="er">
$newoyt
                            </select>
                    </td>
                    <td align="left">
                    Millest uus tehakse.
                    </td>
                </tr>
                <tr>
                    <td align="right" class="style3">
                        sõnastiku nimi:</td>
                    <td align="left" class="style3">
                        <input id="eelexnimiet" type="text" name="eelexnimiet" value="$eelexnimiet" /></td>
                    <td align="left" class="style3">
                     <span id="vnimiet" class="punane" ></span><br/>
                     <span id="snimiet" onclick="n2txt(this,'eelexnimiet')">Eesti-XXX sõnaraamat</span>
                    </td>
                </tr>
                <tr>
                    <td align="right" class="style2">
                        sõnastiku nimi inglise keeles:</td>
                    <td align="left" class="style2">
                        <input id="eelexnimien" type="text" name="eelexnimien"  value="$eelexnimien"/></td>
                    <td align="left" class="style2">
                     <span id="vnimien" class="punane" ></span><br/>
                        <span id="snimien" onclick="n2txt(this,'eelexnimien')">Estonian-XXX dictionary</span></td>
                </tr>
                <tr>
                    <td align="right">
                        &nbsp;
                    </td>
                    <td align="left">
                        <input id="ktr" name="ktr" type="button" value="Kontrolli" onclick="return checkid()"/>
                    </td>
                    <td align="left">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        <input id="Reset1" type="reset" value="Taasta algseis" />
                    </td>
                    <td align="left">
                        <input id="Submit1" type="submit" value="Käivita" disabled="disabled" />
                    </td>
                    <td align="left">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        &nbsp;
                    </td>
                    <td align="left">
                        &nbsp;
                    </td>
                    <td align="left">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        &nbsp;
                    </td>
                    <td align="left">
                        &nbsp;
                    </td>
                    <td align="left">
                        &nbsp;
                    </td>
                </tr>
            </table>
            </form>
        </div>
    </div>
</body>
</html>

LoginPage3

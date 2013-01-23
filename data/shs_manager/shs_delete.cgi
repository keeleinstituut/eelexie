#!/usr/bin/perl

use strict;

#Kasutatakse kustutamiseks
use utf8;
use Encode 'decode_utf8';
binmode(STDOUT, ":utf8");
use POSIX qw(strftime);
use XML::LibXML;
use CGI;


use lib qw( ./ );
use SHS_man;
use SHS_list;
use SHS_cfg (':dir', ':file');

my $q = new CGI;
print $q->header ( -charset => "UTF-8" );

#kogu nimekirja jaoks
my $dicparser = XML::LibXML->new();
my $LLDOM = $dicparser->parse_file(SHS_lexlist_file);
my $LLRoot = $LLDOM->getDocumentElement;


my $logi="";

my $id ="";

if($q->request_method()eq "POST"){
    #salvesta muudatused
    $id =$q->param('id');         # peab exiteerima
        print<<"axa";
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
        <meta http-equiv="Content-type" content="text/html;charset=UTF-8" />
        <link rel="stylesheet" type="text/css" href="../eelex.css" />
            <title>$id kustutamine</title>
            <style type="text/css">
                .style1
                {
                    width: 100%;
                }

            </style>
          
        </head>
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
        <body>
        <H2> Kustutamine $id</H2>
axa
my $dicpr;
my $dicuri;
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


SHS_man::SHS_doprint_level(1);
#D - data,B - backup, R - rootconfig, C - config,G - generated,L - Logsm, T - temp, N - aluspuu(siin ei kasuta), K - sõnastiku omad kaustad
#D|B|R|C|G|L|T|N|K
SHS_man::logi($id, 1 ,strftime("%Y%m%dT%H%M%S", localtime), "Sõnastik kustutati süsteemist");
print" <br/>Temp<br/>";
my $rootdir = SHS_test_dir;
my $rootdir2 = SHS_work_dir;
SHS_man::SHS_set_src($dicpr,$dicuri,$id ,$rootdir);
SHS_man::SHS_set_dest($dicpr,$dicuri,$id ,$rootdir2);
SHS_man::SHS_dofiles(\&SHS_man::SHS_dodict_delete, "D|B|R|C|G|L|T|K");
print" <br/>Töö<br/>";
SHS_man::SHS_set_src($dicpr,$dicuri,$id ,$rootdir2);
SHS_man::SHS_set_dest($dicpr,$dicuri,$id ,$rootdir);
SHS_man::SHS_dofiles(\&SHS_man::SHS_dodict_delete, "D|B|R|C|G|L|T|K");
print" <br/> Lexlist<br/>";
SHS_list::deleteLLelement($id);
print<<"axa";
 <br/> Valmis<br/>
        <a id="end" href="shs_list.cgi#$id">Tagasi nimekirja juurde</a>
        </body>
    </html>
axa

}else{
    $id = $q->param('app_id');
    #hoiatus
    #ja uuesti küsimine
    print<<"axa";
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
        <meta http-equiv="Content-type" content="text/html;charset=UTF-8" />
        <link rel="stylesheet" type="text/css" href="/eelex.css" />
            <title>$id suvandid</title>
            <style type="text/css">
                .style1
                {
                    width: 100%;
                }

            </style>
          
        </head>
        <body>
        <H2> Soovid kustutada $id</H2>
        tee enne varukoopia, kustutamine on lõplik.<br/>
        
        <form id="kustutaeelex" action="shs_delete.cgi" method="post">
         <input id="Hidden1" type="hidden" name="id" value="$id"/>
        <input id="Submit1" type="submit" value="Kustuta" />
         </form>
         <br/>
          <a href="shs_list.cgi#$id">Tagasi nimekirja juurde</a>
        </body>
    </html>
axa
}

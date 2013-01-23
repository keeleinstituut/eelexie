#!/usr/bin/perl

use strict;

#kuvab sõnastike nimekirja
use utf8;
use Encode 'decode_utf8';
binmode(STDOUT, ":utf8");

use Switch;
use XML::LibXML;
use CGI;

my $q = new CGI;
print $q->header ( -charset => "UTF-8" );



use lib qw( ./ );
use SHS_man;
use SHS_config;
use SHS_cfg (':dir', ':file');


my $dicparser = XML::LibXML->new();

my $LLDOM;
my $LLRoot;
my $nodes;
my $rnode; #ajutine kasutusel ühe lex node hoidmiseks

$LLDOM = $dicparser->parse_file(SHS_lexlist_file);
$LLRoot = $LLDOM->getDocumentElement;


#näita andmed
my $trows ="";

my $lexid;
my $lextype;
my $lexer;
my $lexnameen;
my $lexnameet;
my $lexnote;
my $lexcomment;
my $pt;
my $lukud;
my $ddb;
my $hald;

foreach my $rnode ($LLRoot->findnodes("lex")) {
     $lexid = $rnode->findvalue('@id');
     $lextype = $rnode->findvalue('@type');
     $lexer = $rnode->findvalue('@er');
     
     $lexnameet = $rnode->findvalue("name[\@l='et']");
     $lexnameen = $rnode->findvalue("name[\@l='en']");
     $lexnote = $rnode->findvalue("note");
     $lexcomment = $rnode->findvalue("comment");
     
     ($pt,$lukud ,$hald )=shsconfid();
     
     
     $ddb = idDb($lexid);
     
     # kasutatud muutujad $lexid, $lextype, $lexer ,$lexnote, $lexcomment, $lexnameen ,$lexnameet ,...
     $trows .=<<"TabRoW";
    <tr>
        <td>
        <a id="$lexid">
            $lexid ($lextype)<br />[$lexer] {<span style="color:red">$lukud</span>} $hald</a></td>
        <td>
            <a href="../shs_login.cgi?app_id=$lexid">$lexnameet</a>
            <br />$lexnameen
      <br /><br />note: $lexnote
            <br />KOM: $lexcomment
            </td>
        <td>
           $pt
        <td>
           $ddb
        <td>
            <a href="shs_properties.cgi?app_id=$lexid">Sätted</a><br />
            <a href="shs_operations.cgi?app_id=$lexid">Toimingud</a><br />
            <a href="shs_report.cgi?app_id=$lexid">Raport</a><br />
            <a href="shs_clone.cgi?Vapp_id=$lexid">Klooni</a><br />
            <a href="shs_delete.cgi?app_id=$lexid">Kustuta</a><br /></td>
    </tr>
TabRoW

}

sub idDb($){
my ($id)=@_;
my ($Wxml,$Wsql, $Txml, $Tsql)=SHS_config::getDB($lexid);
if($Wxml eq '0'){
$Wxml='';
}else{
$Wxml='XML';
}
if($Txml eq '0'){
$Txml='';
}else{
$Txml='XML';
}
if($Wsql eq '0'){
$Wsql='';
}else{
$Wsql="MySQL $Wsql";
}
if($Tsql eq '0'){
$Tsql='';
}else{
$Tsql="MySQL $Tsql";
}

return "Work:<br /> $Wxml $Wsql <br /><br />Test:<br />$Txml $Tsql";
}

#conf failist
sub shsconfid(){
    #peatoimetajad
    my $pts='<table style="border-width:0px;" border="0"><tr><td style="border-width:0">Work: <br/>';
    #ajutine peatoimetajad
    my $ptd ='';
    #lukud
    my $lukk='';
    my $cdoc;
    my %haldurid;
    my $haldur='';
    
    #work
    if(-r SHS_work_dir."shsconfig_$lexid.xml"){
    $cdoc = $dicparser->parse_file(SHS_work_dir."shsconfig_$lexid.xml")->getDocumentElement;
    $ptd = $cdoc->findvalue('ptd');
    $ptd =~ s/;$//g;
    $ptd =~ s/;/<li>/g;
    
    $haldur = $cdoc->findvalue('haldur');
    while ($haldur =~ m/;?(.*?);/g) {
      $haldurid{$1}=1;
    }

    $lukk ='W' if($cdoc->findvalue('msg/@type') eq 'stop');
    
    }
    
    $pts .=$ptd.'</td><td style="border-width:0">Test: <br/>';
    
    #test
    if(-r SHS_test_dir."shsconfig_$lexid.xml"){
    $cdoc = $dicparser->parse_file(SHS_test_dir."shsconfig_$lexid.xml")->getDocumentElement;
    $ptd = $cdoc->findvalue('ptd');
    $ptd =~ s/;$//g;
    $ptd =~ s/;/<li>/g;
    
    $haldur = $cdoc->findvalue('haldur');
    while ($haldur =~ m/;?(.*?);/g) {
      $haldurid{$1}=1;
    }
    
    $lukk .='T' if($cdoc->findvalue('msg/@type') eq 'stop');
    }
    $pts.=$ptd.'</td></tr></table>';
    
    my $i = 0;
    $haldur = '<br/>';
    for my $key ( keys %haldurid ) {
        $haldur .= '<br/>' . $key;
        $i = $i + 1;
    }
    if($i == 0){
       # $haldur = '<br/><span style="color:red">Haldur puudu</span>';
        $haldur = '<br/>';
    }
    return $pts,$lukk,$haldur;
}
    #<lex id="id_" type="xxx" er="WT" >
    #    <name l="et">Eesti nimi</name>
    #    <name l="en">English name</name>
    #    <note>notetext</note>
    #    <comment>Comment text</comment>
    #</lex>


# document out 
# kasutatud muutujad $trows
print<<"axa";
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
    <link rel="stylesheet" type="text/css" href="../eelex.css" />
	<meta http-equiv="Content-type" content="text/html;charset=UTF-8" />
		<title>Sõnastike haldus: sõnastike nimekiri</title>
	    <style type="text/css">
            .style1
            {
                width: 100%;
            }
            td
            {
            vertical-align:text-top;
            }
            

        </style>
	</head>
	<body>
	<div id="kasutajad" class="sektsioon"><h2>Sõnastike haldus</h2>
        <table>
            <tr>
                <td>
                    Kood(tüüp)<br />[saadavus]{lukk}</td>
                <td>
                    Nimi, Märkus ja Kommentaar</td>
                <td>
                    Peatoimetajad</td>
                <td>
                    Andmed</td>
                <td>
                    Vaata</td>
            </tr>
$trows
        </table>
	</div>
	</body>
</html>
axa

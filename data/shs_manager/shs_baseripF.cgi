#!/usr/bin/perl

#see puhastab sõnastiku andmete seest kasutaja valitud väljad

use strict;
use utf8;
use Encode 'decode_utf8';
binmode(STDOUT, ":utf8");
use POSIX qw(strftime);
use XML::LibXML;
use CGI;


use lib qw( ./ );
use SHS_cfg (':dir', ':file');
my $dicparser = XML::LibXML->new();
my $xsURI ='http://www.w3.org/2001/XMLSchema';
my %sr=();
my $aste=0;
my @aadres = ();
my $aeg = strftime("%Y-%m-%dT%H:%M:%S", localtime);


my $q = new CGI;
print $q->header ( -charset => "UTF-8" );

my $id =$q->param('eelexid'); 
my $Afilt = $q->param('xlst'); 
my $svew = $q->param('workver'); 
my $versioon ='';
if($svew eq 'T'){
    $versioon=SHS_test_dir;
}else{
    $versioon=SHS_work_dir;
}


my $prefix = 'x';
my $uri = 'htte://midagi';

if(-e $versioon."shsconfig_${id}.xml"){
        
        my $things = $dicparser->parse_file($versioon."shsconfig_${id}.xml")->getDocumentElement;
        $prefix =   $things->findvalue("dicpr");
        $uri =   $things->findvalue("dicuri");
        
}else{
        print "Puudu: ".$versioon."shsconfig_${id}.xml";
        die("Puudu: ".$versioon."shsconfig_${id}.xml");
}
html1_P($id);
teeskeem($id,$versioon);
html1_F();

sub teeskeem{
	my ($inid,$ver)=@_;
	if(-r "${ver}xsd/schema_${inid}.xsd"){
		my $inDom = $dicparser->parse_file("${ver}xsd/schema_${inid}.xsd");
		$inDom->documentElement()->setNamespace($xsURI, 'xs', 0);
		praseelm($inDom->documentElement()->findnodes("xs:element[\@name='sr']")->get_node(0), 1, 1, $inDom->documentElement());
	}else{
		#print "ei loe /schema_${inid}.xsd\n";
	}
	
0;
}
sub praseelm{
my ($inel,$inmin,$inmax,$srn)=@_;

my $elnimi=$inel->findvalue('.//xs:annotation/xs:documentation[@xml:lang="et"]');
my $pnimi = $inel-> findvalue('@name');

  $aste=$aste+1;
  push(@aadres, $prefix.':'.$pnimi);
  html1_R($elnimi,$pnimi,$aste,join('/',@aadres), $inmin, $inmax,1);#$snimi,$silt, $sygavus, $aadress 

#sisu = sisu & pnimi & ", " & srstring & ", "
#TrukiElm(pnimi, min, max)
 foreach my $felems ($inel -> findnodes('.//xs:element') ) { 
  my $min='-2';
  my $max='-3';
  my $tmp = $felems->findnodes( "\@minOccurs" ) ;
  if ( $tmp->size() == 0 ) {
  } else {  # artiklis juba A sees olemas
     $min = $tmp ->get_node(0)->nodeValue ;
  }
  $tmp = $felems->findnodes( "\@maxOccurs" ) ;
  if ( $tmp->size() == 0 ) {
  } else { 
    $max= $tmp ->get_node(0)->nodeValue ;
    if($max eq 'unbounded'){
		$max=-1;
    }
  }
  my $tmp2 = substr($felems->findvalue("\@ref"),2);
  $tmp = $srn->findnodes( "xs:element[\@name='${tmp2}']")->get_node(0);
  #$els{$tmp->findvalue('@name') }={'min'=>$min, 'max'=>$max, };
  
  praseelm($tmp, $min, $max,$srn);

 }

my $obl;
	foreach my $telem ($inel->findnodes('.//xs:attribute')) {
	
	if( $telem->findvalue('@use') eq 'required'){
    $obl = 1 ;
	}else{
    $obl = 0 ;
	}
	my $atname = substr($telem->findvalue('@ref'),2 );

my $atenameet='--::--';
   eval  {
      my $atenode = $srn->findnodes( "xs:attribute[\@name='${atname}']")->get_node(0);
      $atenameet=$atenode->findvalue('.//xs:annotation/xs:documentation[@xml:lang="et"]');
   };
if($atname eq 'l:lang'){#  muuda pärast
$atname = 'lang';
$atenameet='XML Keel';
	#häk- 1
html1_R($atenameet,'@'.$atname,$aste,join('/',@aadres).'/@xml:'.$atname, $obl, 1,0);#$snimi,$silt, $sygavus, $aadress 
}else{
#häk- 2
	 html1_R($atenameet,'@'.$atname,$aste,join('/',@aadres).'/@'.$prefix.':'.$atname, $obl, 1,0);#$snimi,$silt, $sygavus, $aadress 
	 }#hiljem
	 html1_Rf('@'.$atname); # see on nii häk 1 ja 2 lõpp
	}
	
  html1_Rf($pnimi);
	
	pop(@aadres);
	$aste=$aste-1;
0;
}

sub html1_P(){
my ($id) = @_;
print <<"LoginPage3";	
<!DOCTYPE html>
<head>
    <title>Andmete Kärpimine ($id)</title>
    <style type="text/css">
        .punane
        {
          color:red;
        }
        ul.ele
        {
        list-style-type:circle;
        }
        ul.atr
        {
        list-style-type:disc;
        }
    </style>
    <script>
function myFunction()
{
document.write("Oops! The document disappeared!");
}

function licl(s)
{
var p = s.parentNode;
var ch = s.checked;
    var inputs = p.getElementsByTagName("input"); //or document.forms[0].elements;  
    for (var i = 0; i < inputs.length; i++) {  
      if (inputs[i].type == "checkbox") {  
        inputs[i].checked = ch;
      }  
    }  
}

function makexx()
{
var str = '<?xml version="1.0"?><xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:$prefix="$uri"> <xsl:output indent="yes" method="xml"/> <xsl:template match="\@* | node()"><xsl:copy> <xsl:apply-templates select="\@* | node()" /></xsl:copy></xsl:template>$Afilt';
    
    var inputs = document.getElementsByTagName("input"); //or document.forms[0].elements;  
    for (var i = 0; i < inputs.length; i++) {  
      if (inputs[i].type == "checkbox") {  
        if (!inputs[i].checked) {  
        
          str= str + '<xsl:template match="/'+inputs[i].id+'"/>';
        } 
      }  
      
    }  
     str= str + '<xsl:template match="$prefix:K"><xsl:element name="$prefix:{local-name()}" >EKI</xsl:element></xsl:template><xsl:template match="$prefix:KA"><xsl:element name="$prefix:{local-name()}" >$aeg</xsl:element></xsl:template></xsl:stylesheet>';
    document.getElementById('xlst').value = str;
    return true;
}

</script>

</head>
<body>
    <form name="sender" action="shs_baserips.cgi" method="post">
<input type="hidden" name="eelexid" value = "$id"/>
<input type="hidden" name="workver" value = "$svew"/>
<input type="hidden" name="xlst" id="xlst" value = ""/>
<input type="submit" value="Käivita" onclick="makexx()"/>
</form> 
<div style="PADDING-BOTTOM: 0px; BACKGROUND-COLOR: white; MARGIN: 0px; PADDING-LEFT: 0px; WIDTH: 100%; PADDING-RIGHT: 0px; HEIGHT: 85%; PADDING-TOP: 0px" id=div_skeemiJupp>
<ul class="ele" >
<li> [0, ∞] - &lt;${prefix}:A&gt; = Artikkel
LoginPage3

1;
}
sub html1_R(){
my ($snimi,$silt, $sygavus, $aadress , $min, $max , $catr) = @_;
my $obl= '';
if($max == -1){
$max ="∞";
}
if($min > 0){
$obl ='disabled="disabled"';
}
if($silt eq 'sr' or $silt eq 'A'){
  0;
  return;
}
my $class= 'class="ele"';
if($catr==1){
$class= 'class="atr"';
}

print <<"LoginPage3";	
<ul $class>
<li><INPUT id="$aadress" value="" checked="checked" $obl type="checkbox" onclick="licl(this)"><LABEL for="$aadress">[$min, $max] - &lt;$prefix:$silt&gt; = $snimi</LABEL>
LoginPage3
1;
}

sub html1_Rf(){
my ($silt) = @_;
if($silt eq 'sr' or $silt eq 'A'){
  0;
  return;
}
print <<"LoginPage3";	
</li></ul>
LoginPage3
1;
}

sub html1_F(){
my ($innode ) = @_;
print <<"LoginPage3";	
</li></ul>
</div>
</body>
</html>
LoginPage3

1;
}

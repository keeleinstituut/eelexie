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


 
my $eelexid = $q->param('id'); 
my $eelexmaht = $q->param('maht');
my $eelexlang = $q->param('eelexlang');
my $eelexprefix = 'x';
my $eelexuri = 'http://www.eki.ee/dict/'.$eelexid;
my $uuslang = 'ed';
my $kfn=1;



my $lexName ='Täitmine';

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
		maht: $eelexmaht<br />
		keel: $eelexlang<br />
		<br />
		<br />
LoginPage

my $aeg = strftime("%Y-%m-%dT%H:%M:%S", localtime);

my $xsl = <<"XSLT";
<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:x="http://www.eki.ee/dict/$eelexid">

<xsl:output indent="yes" method="xml"/>

    <!--identity template to copy content forward by default-->
    <xsl:template match="\@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="\@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="x:A">
        <xsl:if test="./x:maht='$eelexmaht'">
            <xsl:copy>
                <xsl:apply-templates select="\@* | node()" />
            </xsl:copy>
        </xsl:if>
        <xsl:if test="'-'='$eelexmaht'">
            <xsl:copy>
                <xsl:apply-templates select="\@* | node()" />
            </xsl:copy>
        </xsl:if> 
    </xsl:template>
    
    <xsl:template match="\@x:KF">
       <xsl:attribute name="x:{local-name()}">$eelexid<xsl:value-of select="substring(.,4)"/></xsl:attribute>
    </xsl:template>

    <xsl:template match="\@xml:lang[.='ex']">
       <xsl:attribute name="xml:lang">$eelexlang</xsl:attribute>
    </xsl:template>

    <xsl:template match="\@x:g"/>
    <xsl:template match="\@x:aT"/>
    <xsl:template match="\@x:aTA"/>
    <xsl:template match="\@x:k"/>

    <xsl:template match="x:mf"/>
    <xsl:template match="x:all"/>
    <xsl:template match="x:data"/>
    <xsl:template match="x:I"/>
    
    <!--Artikli andmed-->
    <xsl:template match="x:K">
        <xsl:element name="x:{local-name()}" >EKI</xsl:element>
    </xsl:template>
    <xsl:template match="x:KA"><xsl:element name="x:{local-name()}" >$aeg</xsl:element></xsl:template>
    <xsl:template match="x:KL"/>
    <xsl:template match="x:T"/>
    <xsl:template match="x:TA"/>
    <xsl:template match="x:TL"/>
    <xsl:template match="x:PT"/>
    <xsl:template match="x:PTA"/>
    <xsl:template match="x:X"/>
    <xsl:template match="x:XA"/>

</xsl:stylesheet>
XSLT
#<x:K>YViks</x:K><x:KA>2008-01-16T16:17:31</x:KA>


print 'Esimene:'.$aeg.'-<br />' ;
tee( SHS_test_dir.'__sr/'.$eelexid.'/'.$eelexid.'1.xml');
print 'Teine:'.strftime("%Y-%m-%dT%H:%M:%S", localtime).'.<br />' ;
$kfn=2;
tee( SHS_test_dir.'__sr/'.$eelexid.'/'.$eelexid.'2.xml');
print 'Kolmas:'.strftime("%Y-%m-%dT%H:%M:%S", localtime).'.<br />' ;
$kfn=3;
tee( SHS_test_dir.'__sr/'.$eelexid.'/'.$eelexid.'3.xml');
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

sub kasvaja(){
    my ($arta)=@_;
    #my @num = $art->findnodes('x:maht[.='.$eelexmaht.']')->size();
    #$eelexmaht
    if($eelexmaht eq '-' ){
        1;
    }else{
        my $ok = 0;
        foreach my $maht ($arta->findnodes('x:maht')) {
            if($maht->textContent eq $eelexmaht){
            $ok = 1;
            }
        }
        $ok;
        #if($arta->findnodes('/x:maht[.="'.$eelexmaht.'"]')->size() == 1){
        #if($arta->findvalue('x:maht[.="'.$eelexmaht.'"]') eq  $eelexmaht){
        #if($ok){
        #print 'v:'.strftime("%M:%S", localtime).';' ;
        #    1;
        #}else{
        #print 's:'.strftime("%M:%S", localtime).';' ;
        #    0;
        #}
    }

}

sub korrastaArt(){
my ($art)=@_;
print 'a:'.strftime("%M:%S", localtime).';' ;
1;
}

print <<"LoginPage2";	
        <h2 id="end"> Valmis </h2>
        <a href="/">Algusesse</a> <br/> <a href="../../shs_login.cgi?app_id=$eelexid">Sõnastiku juurde</a> <br/> <a href="../shs_list.cgi#$eelexid">Nimekirja juurde</a>
		</body>
</html>

LoginPage2


#!/usr/bin/perl

use strict;
use utf8; # skripti ja tema sees olla võivate utf-8 muutujate (nimed, väärtused) tõttu
# decode_utf8, encode_utf8 ...
# use Encode;
# et print laseks kõik utf-8 -s välja (kui on välja kommitud, siis iga 'print' po 'encode_utf8',
# VÄLJA ARVATUD 'DOM->toString' korral, sest on ise juba UTF-8
# Seega: kõik 'funcs' sarnased cgi-d po ILMA 'binmode' -ta.
# binmode(STDOUT, ":utf8");


# *****************************************************
# Constants
# *****************************************************


# *****************************************************
# CGI parameters
# *****************************************************

# use CGI;
# my $q = new CGI;
# my @parms = split(/\x{e001}/, decode_utf8($q->param('POSTDATA')));


# use LWP::Simple;
# my $html = get("http://www.amazon.com/exec/obidos/ASIN/1565922433")
#  or die "Couldn't fetch the Perl Cookbook's page.";
# print $html;


use File::Path;

require LWP::UserAgent;

my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->env_proxy;

my $locBase = 'backup/loomamees/';
my $ws = 'http://www.der-stuermer.org/'; #  . 'indest.htm'

my $proto = 'http://';
my $protoS = 'https://';
my $protoPtrn = quotemeta($proto);
my $wsAddrPtrn = qr/^$protoPtrn([\w._\-+=]+\/?)(.*)$/o;

# print "Content-type: text/html; charset=utf-8\n\n";
print "Content-type: text/html;\n\n";

if (substr($ws, 0, length($protoS)) eq $protoS) {
	print "<h1>'https:\/\/'-i vaatame hiljem!</h1>";
	exit;
}

if (substr($ws, 0, length($proto)) ne $proto) {
	$ws = $proto . $ws;
}
my ($wsSite, $wsPath);
if ($ws =~ /$wsAddrPtrn/) {
	$wsSite = $1;
	$wsPath = $2;
}
unless ($wsSite) {
	print "<h1>Sait puudub!</h1>";
	exit;
}
if (substr($wsSite, length($wsSite) - 1, 1) ne '/') {
	$wsSite .= '/';
}
# print "<br/>site: '${wsSite}'";
# print "<br/>path: '${wsPath}'";
# exit;

my $locWsBase = $locBase . $wsSite;
my $extBase = 'ext/';
my $locExtBase = $locWsBase . $extBase;

umask 0000;
# näib, et kausta loomisel võib nime lõpus '/' olla küll ...
my $dirCnt;
$dirCnt = mkpath($locWsBase, 0, 0777); # nn 'modern' stiil on igal juhul 'verbose', PUUK ...
$dirCnt = mkpath($locExtBase, 0, 0777); # nn 'modern' stiil on igal juhul 'verbose', PUUK ...

my $src = '(<([\w\-:]+)([^>]*)\s+src\s*=\s*((?:[\w.\-+/:?&=]+|"[\w\s.\-+/:?&=]+"|\'[\w\s.\-+/:?&=]+\'))([^>]*)>)';
my $srcPtrn = qr/$src/sio;

getReq($ws);



sub getReq {
my $currUri = shift(@_);

my $linkAttrVal;
my ($myErrMsg, $ixSisu, $myContent, $saba);
my ($itmSite, $itmPath, $itmFile, $itmDir, $i);

my $r = $ua->get($currUri);

if ($r->is_success) {
	$ixSisu = '';
	$myContent = $r->content;
	while ($myContent =~ /$srcPtrn/) {
		$linkAttrVal = $4;
		if (substr($linkAttrVal, 0, 1) eq "'" || substr($linkAttrVal, 0, 1) eq '"') {
			$linkAttrVal = substr($linkAttrVal, 1, length($linkAttrVal) - 2);
		}
		$ixSisu .= $` . "<${2}${3} src="; # kõik eelnev + nimi + nime ja 'src' atr vahel + 'src' atr algus
		$saba = "${5}>";
		$myContent = $'; # kõik järgnev

		$itmSite = '';
		$itmPath = '';
		if (substr($linkAttrVal, 0, length($proto)) eq $proto) {
			if ($linkAttrVal =~ /$wsAddrPtrn/) {
				$itmSite = $1;
				$itmPath = $2;
			}
			if ($itmSite eq '' || $itmPath eq '') {
				$myErrMsg = "Ei saanud jupitada 'linkAttrVal'-i, stopped (seisatud)";
				print "<br/>${myErrMsg}";
				die $myErrMsg;
			}
		}
		# ., .., / alguses jäävad praegu ära
		else {
			$itmPath = $linkAttrVal;
		}
		$i = rindex($itmPath, '/');
		$itmDir = '';
		if ($i > -1) {
			$itmDir = substr($itmPath, 0, $i + 1); # '/' kaasa ...
		}
		$itmFile = substr($itmPath, $i + 1);
		$i = index($itmFile, '?');
		if ($i > -1) {
			$itmFile = substr($itmFile, 0, $i);
		}
		# algab 'http://': absoluutne, väline?, aadress
		if (substr($linkAttrVal, 0, length($proto)) eq $proto) {
			if ($itmSite ne $wsSite) { # väline
				my $itmR = $ua->mirror($linkAttrVal, $locExtBase . $itmFile);
				$ixSisu .= "\"${extBase}${itmFile}\"";
			}
			else {
				if ($itmDir) {
					$dirCnt = mkpath($locWsBase . $itmDir, 0, 0777); # nn 'modern' stiil on igal juhul 'verbose', PUUK ...
				}
				my $itmR = $ua->mirror($linkAttrVal, $locWsBase . $itmPath);
				$ixSisu .= "\"${linkAttrVal}\"";
			}
		}
		else {
			if ($itmDir ne '') {
				$dirCnt = mkpath($locWsBase . $itmDir, 0, 0777); # nn 'modern' stiil on igal juhul 'verbose', PUUK ...
			}
			my $itmR = $ua->mirror($currUri . $linkAttrVal, $locWsBase . $itmPath);
#			print "<br/>linkAttrVal: '${linkAttrVal}', locWsBase: '${locWsBase}', itmPath: '${itmPath}', itmDir: '${itmDir}'";
			$ixSisu .= "\"${linkAttrVal}\"";
		}
		$ixSisu .= $saba;
	}
	$ixSisu .= $myContent;
	my $locFn = $r->filename;
	unless ($locFn) {
		$locFn = 'ix.htm';
	}
	open(RH, ">", $locWsBase . $locFn);
	print(RH $ixSisu);
	close(RH);
	print $r->content;
}
else {
	die $r->status_line;
}

return 0;
}

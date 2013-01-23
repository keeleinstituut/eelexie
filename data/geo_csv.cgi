#!/usr/bin/perl
#Geoloogide sõnastiku teeb .csv-ks
#Elgar, Kati okt 2012
use strict;

use utf8;
use Encode 'decode_utf8';
binmode(STDOUT, ":utf8");
use XML::LibXML;

my $essFile ="/var/www/EELex/data/__shs/__sr/geo/geo1.xml";

my $dicparser = XML::LibXML->new();
my $nsURI ='http://www.eki.ee/dict/geo';
my $LLRoot = $dicparser->parse_file($essFile)->getDocumentElement;

my $valjund = '"vald","Eesti1","Eesti2","Def","Inglise1","Inglise2","Saksa1","Saksa1_s","Saksa2","Saksa2_s","Soome","Vene1","Vene1_s","Vene2","Vene2_s"'."\n";
print "Content-disposition: attachment; filename=geo.csv\nContent-type: text/txt; charset=UTF-8\n\n";

foreach my $camelid ($LLRoot->findnodes('g:A')) {
	my ($vald, $Eesti1, $Eesti2, $Def, $Inglise1, $Inglise2, $Saksa1,$Saksa1_s, $Saksa2, $Saksa2_s,$Soome,$Vene1,$Vene1_s,$Vene2,$Vene2_s) = ('','','','','','','','','','','','','','','');
	foreach my $vallad ($camelid->findnodes('./g:P/g:mg/g:v')) {
		if ($vald eq '') {
			$vald = $vallad->textContent;
		}else{
			$vald .= ', '.$vallad->textContent;
		}
	}
		foreach my $eestid ($camelid->findnodes('./g:P/g:ep/g:terg/g:ter')) {
		if ($Eesti1 eq '') {
			
			$Eesti1 = $eestid->textContent.$eestid->findvalue('./@g:i');
		}else{
			if ($Eesti2 eq '') {
				$Eesti2 = $eestid->textContent.$eestid->findvalue('./@g:i');
			} 
		}
	}
	$Def = $camelid->findvalue('./g:S/g:tg/g:dg/g:def');
	foreach my $inglised ($camelid->findnodes('./g:S/g:xp[@xml:lang="en"]/g:xg/g:x')) {
		if ($Inglise1 eq '') {
			
			$Inglise1 = $inglised->textContent;
		}else{
			if ($Inglise2 eq '') {
				$Inglise2 = $inglised->textContent;
			} 
		}
	}
	foreach my $saksad ($camelid->findnodes('./g:S/g:xp[@xml:lang="de"]/g:xg/g:x')) {
		if ($Saksa1 eq '') {
			$Saksa1 = $saksad->textContent;
			$Saksa1_s = $saksad ->findvalue('../g:xgrg/g:xzde') ;
		}else{
			if ($Saksa2 eq '') {
				$Saksa2 = $saksad->textContent;
				$Saksa2_s = $saksad ->findvalue('../g:xgrg/g:xzde') ;
			} 
		}
	}
	foreach my $soomed ($camelid->findnodes('./g:S/g:xp[@xml:lang="fi"]/g:xg/g:x')) {
		if ($Soome eq '') {
			$Soome = $soomed->textContent;
		}
	}
		foreach my $vened ($camelid->findnodes('./g:S/g:xp[@xml:lang="ru"]/g:xg/g:x')) {
		if ($Vene1 eq '') {
			$Vene1 = $vened->textContent;
			$Vene1_s = $vened ->findvalue('../g:xgrg/g:xzru') ;
		}else{
			if ($Vene2 eq '') {
				$Vene2 = $vened->textContent;
				$Vene2_s = $vened ->findvalue('../g:xgrg/g:xzru') ;
			} 
		}
	}
	
	
	
	
	$valjund .=  '"'.$vald.'","'.$Eesti1.'","'. $Eesti2.'","'. $Def.'","'.$Inglise1.'","'. $Inglise2.'","'. $Saksa1.'","'.$Saksa1_s.'","'. $Saksa2.'","'. $Saksa2_s.'","'.$Soome.'","'.$Vene1.'","'.$Vene1_s.'","'.$Vene2.'","'.$Vene2_s.'"'."\n" ;

}
print $valjund;

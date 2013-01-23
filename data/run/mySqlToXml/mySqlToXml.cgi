#!/usr/bin/perl

# $ENV{PERL_BADFREE} = 0;

require '/var/www/EELex/shs_config/shs_config.ini';
our $mysql_ip;

use strict;

# Only one case remains where an explicit use utf8 is needed:
# if your Perl script itself is encoded in UTF-8,
# you can use UTF-8 in your identifier names,
# and in string and regular expression literals, by saying use utf8.

use utf8;


# decode_utf8, encode_utf8 ...
use Encode;


# To output UTF-8, use the :utf8 output layer. Prepending
# binmode(STDOUT, ":utf8");
# to this program ensures that the output is completely UTF-8.

# binmode(STDOUT, ":utf8");



use XML::LibXML;
my $dicparser = XML::LibXML->new();
$dicparser->validation(0);
$dicparser->recover(0);
$dicparser->expand_entities(1);
$dicparser->keep_blanks(0);
$dicparser->pedantic_parser(0);
$dicparser->line_numbers(0);
$dicparser->load_ext_dtd(0);
$dicparser->complete_attributes(0);
$dicparser->expand_xinclude(0);
$dicparser->clean_namespaces(1);

# use XML::LibXSLT;
# my $xslt = XML::LibXSLT->new();


# *****************************************************
# Constants
# *****************************************************

my $cmdId = 'dicToXml';


# *****************************************************
# Functions
# *****************************************************


use Fcntl ':flock';
my $lockType;
if ($^O eq 'MSWin32') {
	$lockType = LOCK_SH;
}
else {
	$lockType = (LOCK_EX | LOCK_NB);
}

my $mySqlDbName = 'xml_dicts';

my $startTime = time();

print "Content-type: text/html; charset=utf-8\n\n";

use DBI();
my $dbh = DBI->connect("DBI:mysql:database=${mySqlDbName};mysql_enable_utf8=1;host=${mysql_ip}",
						"eelex", "EELex",
						{'RaiseError' => 1});

chdir("/var/www/EELex/data/run/mySqlToXml/");
my $pathBase = "../../__shs/";

my $eeLexConfDom = $dicparser->parse_file("${pathBase}shsConfig.xml");
my $eeLexAMS = $eeLexConfDom->documentElement()->findvalue('ainultMySql');

if ($cmdId eq "dicToXml") {
	my @dics = split(/;/, substr($eeLexAMS, 1, length($eeLexAMS) - 2));
	for (my $i = 0; $i < scalar(@dics); $i++) {
		my $DIC_DESC = $dics[$i];
		print "'${DIC_DESC}' ...\n";
		my $shsConfFile = "${pathBase}shsconfig_${DIC_DESC}.xml";
		my $shsconfig = $dicparser->parse_file($shsConfFile);
		my $DIC_VOLS_COUNT = $shsconfig->documentElement()->findnodes('vols/vol')->size();
		my $DICPR = $shsconfig->documentElement()->findvalue('dicpr');
		my $DICURI = $shsconfig->documentElement()->findvalue('dicuri');
		my $rootLang = $shsconfig->documentElement()->findvalue('rootLang');
		my $dicBase = "${pathBase}__sr/${DIC_DESC}/";

# kas ongi vaja
		my $koide1 = "${dicBase}${DIC_DESC}1.xml";
		my $timestamp = "${dicBase}/mySqlTimeStamp.txt";
		if ((-e $timestamp) and (-e $koide1)) {
		    my $muutmisaeg = (stat($timestamp))[9];
		    my $salvestusaeg = (stat($koide1))[9];
		    next if $muutmisaeg < $salvestusaeg;
		}

		for (my $vol_Nr = 0; $vol_Nr <= $DIC_VOLS_COUNT; $vol_Nr++) {
			my $xmlFile = "${dicBase}${DIC_DESC}${vol_Nr}.xml";
			if (open(XMLF, '>:utf8', $xmlFile)) {
			if (flock(XMLF, $lockType)) {
				my $exportCmd = "SELECT ${DIC_DESC}.art AS art FROM ${DIC_DESC} WHERE ${DIC_DESC}.vol_nr = ${vol_Nr} ORDER BY ${DIC_DESC}.ms_att_OO";
				my $sth = $dbh->prepare($exportCmd);
				$sth->execute();
				my $artCnt = $sth->rows;

				print(XMLF "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n");
				print(XMLF "<${DICPR}:sr xml:lang=\"${rootLang}\" xmlns:${DICPR}=\"${DICURI}\">\n");

				while (my $ref = $sth->fetchrow_hashref()) {
					my $artStr = decode_utf8($ref->{'art'});
					$artStr =~ s/ xmlns:$DICPR="$DICURI">/>/;
					print(XMLF "${artStr}\n");
				}

				print(XMLF "</${DICPR}:sr>\n");
				flock(XMLF, LOCK_UN);
				close(XMLF);

				$sth->finish();
			}
			}
			else {
				print("Failed to open '${xmlFile}' for writing, (${cmdId})!\n");
			}
		} # for (my $vol_Nr = 0; $vol_Nr <= $DIC_VOLS_COUNT; $vol_Nr++) {
		sleep(15);
	} # for (my $i = 0; $i < scalar(@dics); $i++) {
}


# Disconnect from the database.
$dbh->disconnect();


my $elTime = (time() - $startTime);

print "Tehtud. ${elTime}s.\n";

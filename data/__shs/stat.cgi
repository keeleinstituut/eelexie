#!/usr/bin/perl
#Ajutine statistika korjamise skript

use strict;
use utf8; # skripti ja tema sees olla võivate utf-8 muutujate (nimed, väärtused) tõttu
# decode_utf8, encode_utf8 ...
use Encode;
use POSIX qw(strftime);
use CGI;
my $q = new CGI;

use Tie::File;
my @logLines;
tie(@logLines, 'Tie::File', "../sandbox/xmlivead.log");


unshift(@logLines, strftime("%Y-%m-%dT%H:%M:%S", localtime));
unshift(@logLines, $q->param('POSTDATA'));
untie(@logLines);



print "Content-type: text/xml; charset=utf-8\n\n";
print "ok\n";

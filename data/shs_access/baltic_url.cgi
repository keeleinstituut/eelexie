#!/usr/bin/perl -T
# use strict;
use Encode;

my $viganeurl = $ENV{'REDIRECT_URL'};
my $uusurl = decode_utf8($viganeurl);
$uusurl = encode("CP1257", $uusurl);
my $fn = '/var/www/EELex/data' . $uusurl;

if (-e $fn) {
#    print "Status: 302 Moved\nLocation: $uusurl\n\n";
    print "Status: 200 OK\n";
    print "Content-type: text/html; charset=utf-8\n\n";
    open (F, "<$fn");
    while (<F>) { print; }
    close (F);
}
else {
    print "Status: 404 Not Found\n";
    print "Content-type: text/html; charset=utf-8\n\n";
    print "<h2>404 Faili $viganeurl ei leitud</h2>";
}

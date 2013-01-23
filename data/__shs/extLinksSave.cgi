#!/usr/bin/perl

use utf8;
use Encode;
use CGI;

push @INC, "./";
require "extLinksProc.pl";
binmode (STDOUT, ":utf8");

print "Content-type: text/html; charset=utf-8\n\n";

my $q = new CGI;
my $dictid = decode_utf8($q->param('id'));
my $value = decode_utf8($q->param('value'));

loadlinks();
if ($dictid =~ /^editlink/) {
    setlink ($', $value);
}
if ($dictid =~ /^editdesc/) {
    setdesc ($', $value);
}
savelinks();

print "$value";

#!/usr/bin/perl

#kontrollib kas id'ga sõnastik on registreeritud ja vastab true false (ajax)
# kasutatud uus.htm
use strict;
use utf8;
use Encode 'decode_utf8';
binmode(STDOUT, ":utf8");
use CGI;
my $q = new CGI;

use lib qw( ./ );
use SHS_list;

my $id = $q->param('id');
my $found = 'true';
if(SHS_list::getLLelement($id)==undef){
    $found = 'false';
}
print "Content-type: text/txt; charset=utf-8\n\n";
print $found;

#!/usr/bin/perl

#Id ja versiooni ja päringu alusel vastab mitu artiklit leiti
#kasutatud kloonimis juures?
use strict;
use utf8;
use Encode 'decode_utf8';
binmode(STDOUT, ":utf8");
use CGI;
my $q = new CGI;

use lib qw( ./ );
use SHS_cfg (':dir', ':file');

my $id = $q->param('id');
my $uri = $q->param('uri');
my $prefix = $q->param('prefix');
my $er = $q->param('er');
my $query = $q->param('query');
#id uri prefix froot re query
my $found = 0;

if($er eq 'T'){
    $er=SHS_test_dir;
}else{
    $er=SHS_work_dir;
}

use XML::LibXML;
my $dicparser = XML::LibXML->new();
my $kn = 0;
while(1){
  $kn++;
  my $xmlFile ="${er}__sr/${id}/${id}${kn}.xml";
  if(-e $xmlFile){
  eval {
      my $xmlRoot = $dicparser->parse_file($xmlFile)->getDocumentElement;
      #$xmlRoot->setNamespace($uri, $prefix, 0);
      my $nodes = $xmlRoot->findnodes("$prefix:A[$query]");
      $found= $found+$nodes->size();
   }
  }else{
    last;
  }
}

#print "Content-type: text/txt; charset=utf-8\n\n";
print $q->header ( -charset => "UTF-8", -Content-type => "text/txt" );
print $found;

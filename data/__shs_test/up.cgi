#!/usr/bin/perl  
use strict;
use CGI;
use CGI::Carp qw ( fatalsToBrowser );
use File::Basename;
use Encode 'decode_utf8';
use utf8;
binmode(STDOUT, ":utf8");
use XML::LibXML;
use POSIX qw(strftime);


$CGI::POST_MAX = 1024 * 500000; # vaata üle
my $q = new CGI;

my $id = $q->param('id');
print $q->header ( );
print <<END_HTML;
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
<title>Thanks!</title>
<style type="text/css"> img {border: none;} </style> </head>
<body>
END_HTML

#kas selle idga tohib ükles laadida
my $usrName = "$ENV{REMOTE_USER}";
my $dicparser = XML::LibXML->new();


my $confDom = $dicparser->parse_file("shsconfig_$id.xml");
my $impusers = $confDom->documentElement()->findvalue("import");

unless($impusers =~ m/;$usrName;/){
    $confDom = $dicparser->parse_file("shsConfig.xml");
    $impusers = $confDom->documentElement()->findvalue("eeLexAdmin");
    
    unless($impusers =~ m/;$usrName;/){
        print "Ei ole õigust";
        exit;
    }
}

my $upload_dir = "__sr/$id/";
my $back_dir = "backup/import/";
my $xfilename = '';
my $xfilename2 =='';
my $i;
for($i = 1; $i < 4; $i++) {
    my $filename = $q->param("k$i");
    if ( $filename ) {
        $xfilename = "$id$i.xml";
        $xfilename2 = "$id${i}_".strftime("%Y-%m-%dT%H:%M:%S", localtime).".xml";
        my $upload_filehandle = $q->upload("k$i");
        system("cp $upload_dir$xfilename $back_dir$xfilename2");
        open ( UPLOADFILE, ">$upload_dir$xfilename" ) or die "$!";
        binmode UPLOADFILE;
        while ( <$upload_filehandle> ) { 
            print UPLOADFILE;
        } 
    } 
    close UPLOADFILE;
}

print <<END_HTML;
Failid on paigaldatud.
</body> 
</html> 
END_HTML

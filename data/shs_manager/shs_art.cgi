#!/usr/bin/perl
# sõnastiku failid
use strict;

use utf8;
use Encode 'decode_utf8';
binmode(STDOUT, ":utf8");

#use Switch;
use XML::LibXML;
use File::Basename;
use CGI;
use Socket; #ja miks seda vaja on ?

use lib qw( ./ );
use SHS_cfg (':dir', ':file');

my $q = new CGI;
print $q->header ( -charset => "UTF-8" );

my $dicparser = XML::LibXML->new();
#testid
my $rdir = SHS_test_dir;
my $c = 0;
sub dodir{

my ($dir) = @_;

my ($fItem, $fDir);

my @dir = <$dir*>;
foreach my $full (@dir){
$c = $c + 1;
$fItem= fileparse($full);
$full =~ m/$rdir(.*)$fItem/;
$fDir = $1;


print "<tr><td>$c:</td><td>/$fDir</td><td>$fItem</td></tr>";



if(-d $full){
    dodir($full.'/');
}

}

}
# document out 

print<<"axa";
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
    <link rel="stylesheet" type="text/css" href="../eelex.css" />
	<meta http-equiv="Content-type" content="text/html;charset=UTF-8" />
		<title>EELex'i failid</title>
	    <style type="text/css">
            .style1
            {
                width: 100%;
            }
            .errlevel0
            {
                background-color: #00FF00;
            }
            .errlevel1
            {
                background-color: #00FFFF;
            }
            .errlevel2
            {
                background-color: #FF0000;
            }

        </style>
	</head>
	<body>
	<div id="kasutajad" class="sektsioon"><h2>EELex'i failid</h2>
        
        <table >
            <tr>
                <td>
                    &nbsp;</td>
                <td>
                    2</td>
                <td>
                    1</td>
            </tr>
axa

dodir($rdir);


print<<"axa";
        </table>
        <br />

	</div>
	</body>
</html>
axa

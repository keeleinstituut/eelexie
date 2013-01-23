#!/usr/bin/perl
use strict;

#Trykib viidad tpl tüüpi failide kloonimiseks.

use utf8;
use Encode 'decode_utf8';
binmode(STDOUT, ":utf8");

use POSIX qw(strftime);
use CGI;
use XML::LibXML;


use lib qw( ../ );
use SHS_man;
use SHS_list;
use SHS_cfg (':dir', ':file');


my $q = new CGI;
print $q->header ( -charset => "UTF-8" );

my $ua = $ENV{HTTP_USER_AGENT};
my $ra = $ENV{REMOTE_ADDR};

my $dicparser = XML::LibXML->new();

print <<"LoginPage";
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-type" content="text/html;charset=UTF-8" />
        <link rel="stylesheet" type="text/css" href="../../eelex.css" />
        <title>Uue sõnastiku loomine</title>
        <style type="text/css">
            .acenter
            {
                text-align: center;
            }
            .aright
            {
                text-align: right;
            }
            
        </style>
    </head>
    <body>
        <div id="kasutajad" class="sektsioon"><h2>Uue sõnastiku loomine</h2>
                <table>
LoginPage
#lae list
my ($tid,$tseletus,$ter, $tetname);
foreach my $cc ($dicparser->parse_file(SHS_lexlist_file)->getDocumentElement->findnodes('lex[@type=\'tpl\']')) {
	
		$ter = $cc->findvalue('@er');
		if($ter =~ m/W/){
		$tid = $cc->findvalue('@id');
		$tetname = $cc->findvalue('./name[@l=\'et\']');
		$tseletus = $cc->findvalue('./note');
    
print <<"LoginPage2";	
<tr>
    <td class="aright">
         ${tetname}&nbsp;
    </td>
    <td>
        <a href="uusvorm.cgi?oid=$tid">Tegema</a>&nbsp;</td>
    </td>
    <td>
        ${tseletus}&nbsp;
    </td>
</tr>    
LoginPage2

		}
}


print <<"LoginPage2";	
                    <tr>
                        <td class="aright">
                             Registreeri sõnastik
                        </td>
                        <td>
                            <a href="uusid.htm">Tegema</a>&nbsp;</td>
                        </td>
                        <td>
                            Kasuta, kui lisad sõnastiku failid FTP-d kasutades.&nbsp;
                        </td>
                    </tr>
              </table>
        </div>
    </body>
</html>

LoginPage2

#!/usr/bin/perl
use strict;
use utf8;
use Encode 'decode_utf8';
binmode(STDOUT, ":utf8");

use URI::Escape;

use CGI;
my $q = new CGI;
print $q->header ( -charset => "UTF-8" );


my $em = "&nbsp;";
my $ra = $ENV{REMOTE_ADDR};
my %link;

my $mrk = $q->param('mark'); #millised märkida
$link{'mark'}=$mrk;
$mrk = 'x' if ($mrk eq '');

my $filter; 
if($q->param('filter') eq ''){
    $filter =0; # tühi string?
    $link{'filter'}='';
}else{
    $filter =1;
    $link{'filter'}='1';
}


my $logi ="";
#ja selle sees olev
my $me = "";
my $time =$em;
my $err = $em;
my $who = $em;
my $mess = "";

my $lineip;

my $marktime;
my $whatlasttime=$q->param('lasttime');;
my $lasttime;

open (MYFILE, '/var/log/httpd-error.log');
while (<MYFILE>) {
    chomp;
    #kui rida ei alga [ siis tee lühidalt
    if($_ =~/^\[/){
        
        
        ($time, $err, $who, $mess)=($_ =~/\[(.*?)\]\s+\[(.*?)\]\s+(?:\[(.*?)\]|)\s*(.*)/);
        if($filter){
                    #kui jama rida siis järgmine
            if($mess=~/^Digest:/){
                next;
            }
            if($err=~/notice|warn/){
                next;
            }
            # File does not exist: /var/www/EELex/data/__shs/xml/sp_/ag_p-sl_112_58_115_108.xml, referer: http://eelex.dyn.eki.ee/__shs/art.cgi
            if($mess=~/^File does not exist:(.*)\/xml\//){
                next;
            }
            
        }
        
        if($mess=~/^\[shs_carp_id:(.+?)\]/){
                my $h = '<a href="carplog.cgi?id='.$1.'">[shs_carp_id:'.$1.']</a>';
                $mess =~ s/^\[shs_carp_id:.+?\]/$h/g;
    
        }
        
        #tuunimist veel
        #utf8::decode($mess); 

        #tee aega lühemaks
        $lasttime=$time;
        if($time=~ m/$whatlasttime/){
        $marktime='timemark';
        }else{
        $marktime='';
        }
        $time =~ /\w{3}\s(\w{3}\s\d+\s\d\d:\d\d:\d\d)/;$time=$1;
        
        #kui põhjustaja väli puudub siis pane tühik
        $who=($who||$em);
        
        #jäta alles ainult ip aadress
        if($who=~/(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/){
            $lineip=$1;
            if($who=~/$mrk/){
                 $me="ipmrk";
            }else{
                #Värvi ennast ja majasisene teist värvi. välised lingiks
                if($who=~/$ra/){#ise
                    $me="ipme";
                }else{
                    if($who=~/192.168/){#majasisene
                        $me="ipus";
                    }else{# ülejäänud
                        $me="";
                        
                    }
                }
            }
            $who="<a href=\"http://whois.domaintools.com/$lineip\">IP: </a><a href=\"errlog.cgi".urlvarST('mark', $lineip)."\">$lineip</a>";
        }else{
            $me="";
        } 
        $logi = "<tr><td class=\"$marktime\">$time</td><td class=\"$err\">$err</td><td class=\"$me\">$who</td><td>$mess</td></tr>\n".$logi;
        
    }else{

        $logi = "<tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>$_</td></tr>\n".$logi;
    }
	
}
 
close (MYFILE); 

#vahetab väärtust ainult korraks ühe lingi jaoks
sub urlvarST($$) {
   my ($key,$value)=@_;
   
   my ($out,$tvalue);
   
   $tvalue =$link{$key};
   $link{$key}=$value;
   $out = urlvar();
   $link{$key}=$tvalue;
   return $out;
}

#tühjale jääb küsimärk alles ja lõppu jaab &
sub urlvar() {
    my  $url = '?';
    my ($key, $value);
    while(($key, $value) = each(%link)) {

        if($value eq ''){
            next;
        }
        $url .= $key.'='.uri_escape($value).'&';
    }
    
    return $url;
}

my $timelink = urlvarST('lasttime', $lasttime);
#Kustuta kõik 
#Filtreeri

#$lineip
#<a href=\"errlog.cgi$timelink\">Värskenda</a>


#taaskasutus  $filter
if($link{'filter'} eq ''){
    $filter ='Filter sisse'; 
    $link{'filter'}='1';
}else{
    $filter ='Filter Välja'; 
    $link{'filter'}='';
}

#taaskasutus  $filter
my $hlinks = "<a href=\"errlog.cgi$timelink\">Värskenda</a> - <a href=\"errlog.cgi".urlvar()."\">$filter</a>";


# kasutatud muutujad $logi, $hlinks

print <<"PageOut";
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>Log</title>
    <style type="text/css">
        .style1
        {
            width: 100%;
            border-collapse: collapse;
            border: 1px solid #000000;
           
        }
        .error
        {
            background-color: #FF0000;
        }
        .notice
        {
            background-color: #FFFF00;
        }
        .warn
        {
            background-color: #FF00FF;
        }
        
        .ipme
        {
            background-color: #9999CF;
        }
        .ipus
        {
            background-color: #EFEFFF;
        }
        .ipmrk
        {
            background-color: #FFAFAF;
        }
        .timemark
        {
            background-color: #AFAFFF;
        }
    </style>
</head>
<body>
    
    <h2>$hlinks</h2>
    <table class="style1">
        <tr>
            <td>
                Aeg</td>
            <td>
                Tüüp</td>
            <td>
                Klient</td>
            <td>
                &nbsp;</td>
        </tr>
$logi
    </table>

</body>
</html>
PageOut

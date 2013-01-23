#!/usr/bin/perl
use strict;
use utf8;
use Encode 'decode_utf8';
binmode(STDOUT, ":utf8");

use CGI;
my $q = new CGI;
print $q->header ( -charset => "UTF-8" );


my $em = "&nbsp;";

my $id = $q->param('id'); #millised märkida

if($id eq ''){
$id = '.+?';
}


#ajutine id hoidja
my $cid='';
#HOIAB udata andmeid, äärele printimiseks
my %udata;

#kogu veateade
my $logi ="";
#kõik veateated
my $logid ="";

my $found=0;
my $foundcount=0;



open (MYFILE, '/var/www/EELex/data/sandbox/shs_carp.log');
while (<MYFILE>) {


    if($found){
        if($_ =~/^\*\*\*.+?\*\*\*/){
            $found = 0;
            $udata{'id'}=$cid; #minema
            $logid .= '<tr><td>'.get_info().'</td><td><pre>'.$logi.'</pre></td></tr>';
            $logi ='';

            if($_ =~/^\*\*\*$id\*\*\*/){
                    redo;
            }
        }else{
            if($_ =~/^\[udata:dump\]/){
                make_info($_);
            }else{
                $logi .= $_;
            }
        }
    }else{
        if($_ =~/^\*\*\*($id)\*\*\*/){
            $cid=$1;
            $found = 1;
            $foundcount = $foundcount +1;
            next;
        }

    }

	
}
close (MYFILE); 
if($logi ne''){
$udata{'id'}=$cid; #minema
$logid .= '<tr><td>'.get_info().'</td><td><pre>'.$logi.'</pre></td></tr>';
}

 
my $hlinks = "<a href=\"errlog.cgi\">kh</a>";



sub make_info {
  my $str = shift @_;
  %udata = (); 
  $udata{'id'}=$cid;
  $str=~/^\[(.+)\]$/;
  $str=$1;
  my @values = split('\]\[', $str);

  foreach my $val (@values) {
     $val=~/(.+?):(.+)/;
     $udata{$1}=$2;
  }


$udata{'udata'}='';
}


sub get_info {
    my  $html = '';
    my ($key, $value);
    while(($key, $value) = each(%udata)) {

        if($value eq ''){
            next;
        }
        $html .= $key.': '.$value.'<br/>';
    }
    
    return $html;
}

if($id eq '.+?'){
$id = 'kõik';
}

# kasutatud muutujad $id, $logid, $hlinks

print <<"PageOut";
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>$id carp</title>
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
                info</td>
            <td>
                sisu</td>

        </tr>
$logid
    </table>

</body>
</html>
PageOut
 

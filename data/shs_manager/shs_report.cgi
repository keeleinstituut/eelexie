#!/usr/bin/perl

use strict;

use utf8;
use Encode 'decode_utf8';
binmode(STDOUT, ":utf8");

use Switch;
use XML::LibXML;
use CGI;
use Socket; #ja miks seda vaja on ?

use lib qw( ./ );
use SHS_man;
use SHS_cfg (':dir', ':file');



my $q = new CGI;
print $q->header ( -charset => "UTF-8" );


my $id = $q->param('app_id');
my $prefix = $q->param('app_prefix');
if($prefix eq ''){
$prefix = 'x';  
}

#test ja work error level
my $terror=0;
my $werror=0;

my $tmpError=0;
my $tmpMsg='';

my $dicparser = XML::LibXML->new();
#testid

my $tuhirida = "<tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>";


sub dotests{
  my ($ref) = @_;
  
  my ($werr, $wmess,$testname) =  &$ref(SHS_work_dir);
  $werror = $werr if($werror < $werr);
  my ($terr, $tmess) =  &$ref(SHS_test_dir);
  $terror = $terr if($terror < $terr);
  
  return "<tr><td>$testname</td><td class=\"errlevel$werr\">$wmess</td><td class=\"errlevel$terr\">$tmess</td></tr>"; 
}

#Näidis
sub test1(){
  my $testname ="standart:";
  my ($dir) = @_;
  my $errlevel = 2;
  if($dir eq SHS_test_dir){
   $errlevel = 1;
  }
  
  # erlevel, väljund, testname
  return ($errlevel,"test sõnum",$testname); 
}

#andmefailid
sub oigused(){
    my $testname ="Faili õiguste kontroll:";

    my ($dir) = @_;

    #D - data,B - backup, R - rootconfig, C - config,G - generated,L - Logsm, T - temp, N - aluspuu(siin ei kasuta), K - sõnastiku omad kaustad
    #D|B|R|C|G|L|T|N|K
    SHS_man::SHS_set_src($prefix,'',$id ,$dir);
    SHS_man::SHS_clear_msg();
    SHS_man::SHS_clear_err();

    SHS_man::SHS_dofiles(\&SHS_man::SHS_dodict_testprem,'D|B|R|C|G|L|T|N|K');
    
    $tmpMsg=SHS_man::SHS_get_msg();
    ( $tmpError) =SHS_man::SHS_get_err();    
    $tmpMsg= 'OK' if($tmpMsg eq '');
    return ($tmpError,$tmpMsg,$testname); 
}

#shsconfig_ võiks sisu ka vaadata
sub cfgchk(){
    my ($dir) = @_;
    my $testname ="shsconfig_${id}.xml kontroll:";
    $tmpMsg= '';
    if(-e $dir."shsconfig_${id}.xml"){
        $tmpError =0;
        $tmpMsg= 'OK';
    }else{
        $tmpError =2;
        $tmpMsg= 'Fail puudu';
    }
   

    return ($tmpError,$tmpMsg,$testname); 
}


sub grpchk(){
    my ($dir) = @_;
    my $testname ="Kasutajaõiguste kontroll:";
    $tmpMsg= '';
    $tmpError =0;
    my $grpfile = '';
    open (HTACCESS, "<", $dir.'.htaccess') || die "can't open '.htaccess': $!";
    while (<HTACCESS>) {
        s/\s+$//; # chomp näib reavahetuse tühikuga asendavat ...
        next unless /^AuthGroupFile /;
        $grpfile = $';
    }
    close(HTACCESS) || die "can't close '.htaccess': $!";
    
    
    if (-e "$grpfile") {
        open (F, "<$grpfile");
        binmode (F, ":utf8");
        my @grupid = (<F>);
        chomp @grupid;
        my ($toim,$vaat)=(2,2);
        foreach my $line (@grupid) {
            #grp_od_: VKorrovits KKuusk KJKangur EKolli MTiits
            if($line =~/^grp_$id:\s(.*)$/){
                if($1 eq ''){
                    $toim =1;
                }else{
                    $toim =0;
                }
            }
            if($line =~/^quest_$id:\s(.*)$/){
                if($1 eq ''){
                    $vaat =1;
                }else{
                    $vaat =0;
                }
            }
        }
        close (F);
        
       
        if($toim == 0){
            $tmpMsg.= "grp_$id OK<br/>";
        }else{
            if($toim == 1){
                $tmpMsg.= "grp_$id tühi<br/>";
                $tmpError =1;
            }else{#2
                $tmpMsg.= "grp_$id puudu<br/>";
                $tmpError =1;
            }    
        }
        if($vaat == 0){
            $tmpMsg.= "guest_$id OK";
        }else{
            if($vaat == 1){
                $tmpMsg.= "guest_$id tühi";
            }else{#2
                $tmpMsg.= "guest_$id puudu";
            }    
        }
        
    } else {
        $tmpError =2;
        $tmpMsg= $grpfile.' puudu';
    }
    
    if($tmpMsg eq ''){
        $tmpError =2;
        $tmpMsg= "grp_$id guest_$id puudu";
    }
   
    return ($tmpError,$tmpMsg,$testname); 
}


# document out 
# kasutatud muutujad $trows, $id, $terror, $werror
print<<"axa";
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
    <link rel="stylesheet" type="text/css" href="../eelex.css" />
	<meta http-equiv="Content-type" content="text/html;charset=UTF-8" />
		<title>$id raport</title>
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
	<div id="kasutajad" class="sektsioon"><h2>$id</h2>
        
        <table >
            <tr>
                <td>
                    &nbsp;</td>
                <td id="wh" class=\"errlevel$werror\">
                    Tööversioon</td>
                <td id="th" class=\"errlevel$terror\">
                    Testversioon</td>
            </tr>
axa

print dotests(\&cfgchk);
print dotests(\&oigused);
print dotests(\&grpchk);

# midagi koondavat veel
# varem tegi kõik tesdtid ja siis saatis vastust

print<<"axa";
        </table>
        <br />

	</div>
	<script type="text/javascript">
    //<![CDATA[ 

    document.getElementById("wh").setAttribute("class", \"errlevel$werror\");
	document.getElementById("th").setAttribute("class", \"errlevel$terror\");
    //]]> 
    </script>
	</body>
</html>
axa

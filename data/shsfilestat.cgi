#!/usr/bin/perl

# inspektor
#
use strict;
use utf8;
use Encode 'decode_utf8';
binmode(STDOUT, ":utf8");
use POSIX qw(strftime);
use XML::LibXML;
use CGI;

use lib qw( ./shs_manager/ );
use SHS_cfg (':dir', ':file');

my $dicparser = XML::LibXML->new();
my $aeg = strftime("%Y-%m-%dT%H:%M:%S", localtime);
my $q = new CGI;

print $q->header ( -charset => "UTF-8" );

my $workdir =SHS_work_dir;

my $ids = makeID();
my ($filf,$fild)=makeF($ids);

html1_P("jada");
print "$filf , $fild";
dodir("/var/www/EELex/data/__shs/");
html1_F(0);


sub dodir(){
my ($r) = @_;
  foreach (<$r*>){
     my $f=$_;
   #  $f =~ m/^$workdir(?((.*)\/(.*?)$)(.*)\/(.*?)$|(.*?)$)/;
     my $ld;
     my $lf;
     
    if($f =~ m/^$workdir(.*)\/(.*?)$/){
       $ld=$1;
       $lf=$2;
    }else{
       $f =~ m/^$workdir(.*?)$/;
       $ld='';
       $lf=$1;
    }
     
     #my $m= fileparse($_);
     if(-d $f){
       unless($lf =~ m/^($ids)$/){
          print "$ld - ($lf)</br>";
       }
       if(lookin($f, $ld,$lf)){
        dodir($f."/");
       }
     }else{
       unless($f =~ m/$filf/){
            print "$ld - $lf</br>";
       }
     }
  }

0;
}

sub lookin(){
my ($f, $ld,$lf) = @_;

    if($ld =~ m/^__sr/){
       return 0;
    }
    if($lf =~ m/^(backup|logs|temp)/){
       return 0;
    }
    if($lf =~ m/dhtmlx/){
       return 0;
    }
1;
}

sub makeID(){
my $out = '';
foreach my $rnode ($dicparser->parse_file(SHS_lexlist_file)->getDocumentElement->findnodes("lex")) {
     $out .= $rnode->findvalue('@id').'|';
}
$out =~m/^(.*)\|$/;
$out =$1;
return $out;
}


sub makeF(){
  my ($sa) = @_;
  my $ff='^'.$workdir.'(';
  my $df='^'.$workdir.'(';
  my $fv='';
  my $dv='';
  my $xmlDOM = $dicparser->parse_file(SHS_dmacro_file);
  my $xmlRoot = $xmlDOM->getDocumentElement;

  foreach my $rnode ($xmlRoot->findnodes("do")) {
    my $fDir = $rnode->findvalue('@dir');
    $fDir =~ s/:d:/\($sa\)/g;
    $fDir =~ s/:p:/./g;
    my $fregex = $rnode->findvalue('@item');
    $fregex =~ s/:d:/\($sa\)/g;
    $fregex =~ s/:p:/./g;
    $fregex =~ s/:op:/.{1,3}/g;
    my $itemtype = $rnode->findvalue('@itemtype');
    if($itemtype eq 'F'){ 
      $ff.=$fv.$fDir.$fregex;
      $fv='|';
    }else{
      $df.=$fv.$fDir.$fregex;
      $dv='|';
    }
  }

  $df.=')$';
  $ff.=')$';
  return ($ff,$df);

}

sub html1_P(){
my ($id) = @_;
print <<"LoginPage3";	
<!DOCTYPE html>
<head>
    <title>Ae ($id)</title>
    <style type="text/css">
        .punane
        {
          color:red;
        }
    </style>
    <script>
    </script>
</head>
<body>

LoginPage3

1;
}
sub html1_R(){
my ($catr) = @_;

print <<"LoginPage3";	

LoginPage3
1;
}



sub html1_F(){
my ($innode ) = @_;
print <<"LoginPage3";	
</body>
</html>
LoginPage3

1;
}

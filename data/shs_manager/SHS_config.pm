package SHS_config;
use strict;
use warnings;

use utf8;
use Encode 'decode_utf8';
binmode(STDOUT, ":utf8");


use HTTPD::UserAdmin();
use XML::LibXML;



use SHS_Carp;

#$SIG{__WARN__} = \&carp_hwl;
$SIG{__DIE__}  = \&carp_hdl;

use SHS_cfg (':dir', ':file');

my $dicparser = XML::LibXML->new();
#Püsimuutujad
my %TSql;
my %TNSql;
my %WSql;
my %WNSql;

#See tuleb uuesti üle käia
BEGIN {
    use Exporter ();
    our (@ISA, @EXPORT, @EXPORT_OK);
    @ISA = qw(Exporter);
    @EXPORT_OK = qw( &getDB);
}
our @EXPORT_OK;
INIT 
{ 
load();
}
#
#esimene täht on versioon
# xml 0- eo ole kasutuses, 1 - on
# sql 0- ei ole kasutuses, teised numbrid versiooni
sub getDB($){
    my ($id)=@_;
    my ($Wxml,$Wsql, $Txml, $Tsql)=(1,0,1,0);
#defined exists
    $Wxml= 0 if defined $WNSql{$id};
    $Wsql=$WSql{$id} if defined $WSql{$id} ;
    
    $Txml= 0 if defined $TNSql{$id};
    $Tsql=$TSql{$id} if defined $TSql{$id} ;

    return ($Wxml,$Wsql, $Txml, $Tsql);
}

#laeb 
sub load(){
    my $file=SHS_test_dir.'shsConfig.xml';
    my $string = '';		# config sisu
my $line;
    if (-e $file) {
        open (F, "<$file");
        # binmode (F, ":utf8");
        my(@Fin) = <F>;
        foreach my $line (@Fin) {
            chomp $line;
            
            if($line =~ /<qmMySql>(.*)<\/qmMySql>/){
                $string = $1;
                while ($string =~ m/;?(.*?);/g) {
                  $TSql{$1}=getSqlVer($1,SHS_test_dir);
                }
            }
            if( $line =~/<ainultMySql>(.*)<\/ainultMySql>/){
                $string = $1;
                while ($string =~ m/;?(.*?);/g) {
                  $TNSql{$1}='1';
                }
            }
            
        }
        close (F);
    }
#work
        $file=SHS_work_dir.'shsConfig.xml';
        if (-e $file) {
        open (F, "<$file");
        # binmode (F, ":utf8");
        my(@Fin) = <F>;
        foreach my $line (@Fin) {
            chomp $line;
            if($line =~ /<qmMySql>(.*)<\/qmMySql>/){
                $string = $1;
                while ($string =~ m/;?(.*?);/g) {
                   $WSql{$1}=getSqlVer($1,SHS_work_dir);
                }
            }
            
            if($line =~ /<ainultMySql>(.*)<\/ainultMySql>/){
                $string = $1;
                while ($string =~ m/;?(.*?);/g) {
                  $WNSql{$1}='1';
                }
            }
            
        }
        close (F);
    }

  
}

sub getSqlVer($$){
my ($id,$path)=@_;
my $grpfile =$path.'shsconfig_'.$id.'.xml';
if (-e "$grpfile") {
    open (F, "<$grpfile");
    binmode (F, ":utf8");
    my @grupid = (<F>);
    chomp @grupid;
    foreach my $line (@grupid) {
        
        if($line =~/<mySqlDataVer>(.*)<\/mySqlDataVer>/){
            return $1;
        }
    }
    close (F);
    
}
return 1;



}

1;

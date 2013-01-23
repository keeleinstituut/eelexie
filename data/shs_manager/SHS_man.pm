package SHS_man;
use strict;
use warnings;

use utf8;
use Encode 'decode_utf8';
binmode(STDOUT, ":utf8");
use Encode;

use Fcntl ':mode';
use HTTPD::UserAdmin();
use Digest::MD5;
use XML::LibXML;
use File::Basename;


#use lib qw( ./perl/lib/ ); #seda pole vaja vist

use SHS_Carp;

#$SIG{__WARN__} = \&carp_hwl;
$SIG{__DIE__}  = \&carp_hdl;




use SHS_cfg (':dir', ':file');

my $dicparser = XML::LibXML->new();

#See tuleb uuesti üle käia
BEGIN {
    use Exporter ();
    our (@ISA, @EXPORT, @EXPORT_OK);
    @ISA = qw(Exporter);
    @EXPORT_OK = qw( &filestats &SHS_clear_err &SHS_clear_msg &SHS_clear_log &SHS_get_err &SHS_get_msg &SHS_get_log &SHS_set_src &SHS_set_dest &SHS_dofiles &SHS_dict_clone &SHS_dict_delete &SHS_dict_clone2 );
}
our @EXPORT_OK;

# f* source , t* destination 
my ($fRootDir, $fDir, $fItem, $fregex,  $tRootDir, $tDir, $tItem, $tregex, $dotype, $itematr, $itemnr, $itemFilter, $itemtype ) = ('', '', '', '', '', '','', '', '', '', '', '', '');

#sõnaraamatu id ja xmli prefix, uri
#kasutatakse kopeerimise ja teisendamise juures
my ($srcPrefix, $srcURI, $srcID, $destPrefix, $destURI,  $destID)=('', '', '', '', '', '');

my ($srcOPrefix, $destOPrefix)=('', '');

my ($srcLang, $destLang)=('', '');

#täislogi
my $logi='';
#sõnumid kasutaja jaoks
my $msgi='';
#veatase või arv
my $error=0;
my $warning=0; # vist maha

#realajas printimine sisse välja
my $tmpmsg='';
#realajas printimine sisse välja
my $loud=0;

#$tmpmsg ="$omething";
#$msgi .= $tmpmsg ;
#$logi .= $tmpmsg ;
#print $tmpmsg if($loud);

# vajab veel tuunimist vist
sub SHS_set_Langs($$) {
  ($srcLang, $destLang)=@_;
  
}

#enne päringuid sisesta andmed
sub SHS_set_src($$$$) {
   ($srcPrefix,$srcURI,$srcID,$fRootDir)=@_;
   $srcOPrefix =  ord($srcPrefix);
}

sub SHS_set_dest($$$$) {
   ($destPrefix,$destURI,$destID, $tRootDir)=@_;
   $destOPrefix =  ord($destPrefix);
}

#0 ja 1 määravad kas prindidake tegevused või lähevad ainult logisse
sub SHS_doprint_level($) {
   ($loud)=@_;
}

sub SHS_clear_err() {
   $error=0;
   $warning=0;
}
sub SHS_clear_msg() {
   $msgi='';
}
sub SHS_clear_log() {
   $logi='';
}

sub SHS_get_err() {
   return ($error, $warning);
}

sub SHS_get_msg() {
   return $msgi;
}
sub SHS_get_log() {
   return $logi;
}



sub SHS_dodict_delete() {
#võibolla midagi et work ja test juurikas N tüüpi kustutust ei tehtaks
#rm -f vaikselt -r rekursiivselt
   
       my ($ff,$tt)= fnl($fRootDir.$fDir.$fItem,$tRootDir.$tDir.$tItem); 
       
    system('rm -f -r '.$ff); # or die("deletida ei saanud"); # see sureb koguaeg maha $? == vaja
         
    $tmpmsg ="<li>DELD: $fDir, '$fItem'";
    #$msgi .= $tmpmsg;
    $logi .= $tmpmsg;
    print $tmpmsg if($loud);

}

sub SHS_dodict_testprem(){
   my ($ff,$tt)= fnl($fRootDir.$fDir.$fItem,$tRootDir.$tDir.$tItem); 
my $fn = $ff;
my ($size, $permissions) = filestats($fn);

my $v='';
while ($itemnr =~ m/(.)/ig) {
  
  if($1 eq 'R'){
   $v='R' unless (-r $fn);
  }
  if($1 eq 'r'){
   $v='r' if (-r $fn);
  }
  
  if($1 eq 'W'){
   $v='W' unless (-w $fn);
  }
  if($1 eq 'w'){
   $v='w' if (-w $fn);
  }
  
  if($1 eq 'X'){
   $v='X' unless (-x $fn);
  }
  if($1 eq 'x'){
   $v='x' if (-x $fn);
  }
}


if($v eq ''){
    $logi .= "<li>oige: $fDir$fItem= $permissions == ($itematr)";
}else{
    #see tuleks ilusamaks teha
    unless($size == -1){
        $error =2 if($error < 2);

        $tmpmsg ="<li>Vale: $fDir$fItem= $permissions != ($itematr)";
        $msgi .= $tmpmsg ;
        $logi .= $tmpmsg ;
        print $tmpmsg if($loud);
    }
}

}


sub SHS_dodict_copy() {
    
    
    if($itemtype eq 'D'){
        system('mkdir -p '.$tRootDir.$tDir.$tItem);
        if ($? == -1) {
            die( "mkdir failed to execute: $!, stoped");
        }
        if($? == 0){
            chmod(0775, $tRootDir.$tDir.$tItem) #or die "Couldn't chmod $tRootDir.$tDir: $!";
        }
    }else{
        my ($ff,$tt)= fnl($fRootDir.$fDir.$fItem,$tRootDir.$tDir.$tItem);
        system('cp -p "'.$ff.'" "'.$tt.'"');
        #system('cp -p "'.$fRootDir.$fDir.$fItem.'" "'.$tRootDir.$tDir.$tItem.'"');
        #chmod(0660, $dir) or die "Couldn't chmod $dir: $!";
        
        #muuda faili
    }
    $tmpmsg ="<li>Clone: $fDir, '$fItem' => '$tItem'</li>";
    $logi .= $tmpmsg ;
    print $tmpmsg if($loud);

}

#Seda ei tohi kasutada
sub SHS_dodict_modify() {

     my ($ff,$tt)= fnl($fRootDir.$fDir.$fItem,$tRootDir.$tDir.$tItem);   
open(FILE, $tt) || die("Cannot Open File input '$tRootDir.$tDir.$tItem'");
my(@fcont) = <FILE>;
close FILE;

open(FOUT,">$tt") || die("Cannot Open File output '$tRootDir$tDir$tItem'");
foreach my $line (@fcont) {


    $line =~ s/$srcURI/$destURI/g;
    $line =~ s/$srcPrefix/$destPrefix/g;
    $line =~ s/$srcID/$destID/g;
    if($srcLang ne ''){
    $line =~ s/$srcLang/$destLang/g;            
    }
    print FOUT $line;
}
close FOUT;
@fcont = ();
}

sub SHS_dodict_modifyF() {
my ($ff,$tt)= fnl($fRootDir.$fDir.$fItem,$tRootDir.$tDir.$tItem);     
open(FILE, $tt) || die("Cannot Open File input '$tRootDir.$tDir.$tItem'");
my(@fcont) = <FILE>;
close FILE;

open(FOUT,">$tt") || die("Cannot Open File output '$tRootDir$tDir$tItem'");
foreach my $line (@fcont) {
#see peab keerukam olema

    $line =~ s/$srcURI/$destURI/g;
    
    $line =~ s/(_|>)${srcPrefix}-(.*?)_${srcOPrefix}_/$1${destPrefix}-$2_${destOPrefix}_/g;
    
    $line =~ s/>$srcPrefix</>$destPrefix</g;

    $line =~ s/([\|\/\@\(\s>;<"':])$srcPrefix:/$1$destPrefix:/g; #"

    $line =~ s/_${srcPrefix}_/_${destPrefix}_/g; #
    
    $line =~ s/xmlns:${srcPrefix}=/xmlns:${destPrefix}=/g;
    
    $line =~ s/"$srcID/"$destID/g;
    $line =~ s/([^<])\/$srcID/$1\/$destID/g; #vahetas elementide nimesid  $line =~ s/\/$srcID/\/$destID/g;
    $line =~ s/>$srcID</>$destID</g;
    $line =~ s/_${srcID}_/${destID}_/g;
    $line =~ s/'$srcID'/'$destID'/g;
    
    print FOUT $line;
}
close FOUT;
@fcont = ();

}

sub SHS_dodict_modifyFnP() {
   my ($ff,$tt)= fnl($fRootDir.$fDir.$fItem,$tRootDir.$tDir.$tItem); 
open(FILE, $tt) || die("Cannot Open File input '$tRootDir.$tDir.$tItem'");
my(@fcont) = <FILE>;
close FILE;

open(FOUT,">$tt") || die("Cannot Open File output '$tRootDir$tDir$tItem'");
foreach my $line (@fcont) {
#see peab keerukam olema

   
    $line =~ s/$srcURI/$destURI/g;

    $line =~ s/"$srcID/"$destID/g;
    $line =~ s/\/$srcID/\/$destID/g;
    $line =~ s/>$srcID</>$destID</g;
    $line =~ s/_${srcID}_/${destID}_/g;
    $line =~ s/'$srcID'/'$destID'/g;
    
    print FOUT $line;
}
close FOUT;
@fcont = ();

}

sub SHS_dodict_clone() {

    SHS_dodict_copy();
    if($itemtype eq 'F'){
        SHS_dodict_modify();
    }

}

sub SHS_dodict_cloneF() {
    SHS_dodict_copy();
    if($itemtype eq 'F'){
        SHS_dodict_modifyF();
    }
}

sub SHS_dodict_cloneFnP() {
    SHS_dodict_copy();
    if($itemtype eq 'F'){
        SHS_dodict_modifyFnP();
    }
}


#(\&$)
sub SHS_dofiles {
    my ($funcref, $stypes) = @_;
    my ($hoidja, $hoidja2);
    my $xmlDOM = $dicparser->parse_file(SHS_dmacro_file);
    my $xmlRoot = $xmlDOM->getDocumentElement;


    $tmpmsg ="root $fRootDir -> $tRootDir<br/>";
    $logi .= $tmpmsg ;
    print $tmpmsg if($loud);
    
    
    foreach my $rnode ($xmlRoot->findnodes("do")) {
    
    $dotype = $rnode->findvalue('@dotype');
    
    # $stypes ='D|B|R|C|G|L|T|N|K'
    unless($dotype=~m/$stypes/){
        next;
    }
    
    $fDir = $rnode->findvalue('@dir');
    $tDir = $fDir;
    $fDir =~ s/:d:/$srcID/g;
    $fDir =~ s/:p:/$srcPrefix/g;
    
    $tDir =~ s/:d:/$destID/g;
    $tDir =~ s/:p:/$destPrefix/g;
    
    $fregex = $rnode->findvalue('@item');
    $tregex = $fregex;
    $fregex =~ s/:d:/$srcID/g;
    $fregex =~ s/:p:/$srcPrefix/g;
    $fregex =~ s/:op:/$srcOPrefix/g;
    
    $tregex =~ s/:d:/$destID/g;
    $tregex =~ s/:p:/$destPrefix/g;
    $tregex =~ s/:op:/$destOPrefix/g;
    
    $itemFilter = $rnode->findvalue('@skipfilter');
    $itemFilter =~ s/:d:/$srcID/g;
    $itemFilter =~ s/:p:/$srcPrefix/g;
    
    $itematr = $rnode->findvalue('@atr');
    $itemnr = $rnode->findvalue('@nr');
    
    $itemtype = $rnode->findvalue('@itemtype');
    #  <do itemtype="F" dotype="C" atr="666" />
    
    $tmpmsg ="<br/>($dotype), '$fDir', '$fregex' -> '$tDir', '$tregex', [$itemtype$itematr], '$itemFilter'<br/>";
    $logi .= $tmpmsg ;
    print $tmpmsg if($loud);
    
       
       if($itemtype eq 'F'){ #faili puhul

           foreach (<$fRootDir$fDir*>){
            
               $fItem= fileparse($_);

               #kui filter puudu siis string tühi. kui klapib siis järgmine.
               unless($itemFilter eq ''){
                   if($fItem=~m/$itemFilter/){
                        next;
                   }
               }
             
               #Failinime l6pp !!!
               
               #kas fail pakub meile huvi

               unless($fItem=~m/^$fregex$/){
                    next;
               }
               $hoidja = $1;
               $hoidja2 = $2;

               #tee sihtmärgi failinimi
               #kui :d:(.*?).xml leiab ex_1.xml ja ex_2.xml
               #siis saaks teha        mar1.xml ja mar2.xml
               
               $tItem = $tregex;
               $tItem =~ s/\(\.\*\??\)/$hoidja/;
               $tItem =~ s/\(\.\*\??\)/$hoidja2/;
          
          #täpitähed failisüsteemis
            #  ($fItem,$tItem)= fn($fRootDir.$fDir,$fItem,$tItem);
        
          
               &$funcref();

               
            }
        }else{ #kui on tegu kaustaga
               
               $tItem = $tregex;
               $fItem = $fregex;

               #mingi eksistensi kontroll oleks ikka vaja
               &$funcref();
        }
    }
    return 0;
}


#Teeb baasi tühjaks või tühja baasi või puuduvad baasi failid.(ainult xml)
#määra koht SHS_set_src käsuga, 
sub SHS_MakeBase{
    #kas kirjutada üle, 0 kui ei soovi üle kirjutada
    my($ow)=@_;

    #Vaata mitu kõidet on
    my $dicparser = XML::LibXML->new();
     my $knum ;
    if(-e $fRootDir."shsconfig_${srcID}.xml"){
        $knum = $dicparser->parse_file($fRootDir."shsconfig_${srcID}.xml")->getDocumentElement->findnodes("vols/vol")->size();
    }else{
        print "Puudu: ".$fRootDir."shsconfig_${srcID}.xml";
        die("Puudu: ".$fRootDir."shsconfig_${srcID}.xml");
    }
    
    my $count = 0;
    
    my $logfile;
    my $app;
    for ($count = 0; $count <= $knum ; $count++) {
        $logfile = $fRootDir."__sr/${srcID}/${srcID}${count}.xml";
        
        $app = (-e $logfile ? 0 : 1);
        #
        if($ow || $app){
            open (L, '>'.$logfile);
            binmode(L, ":utf8");
               print L "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
               print L "<$srcPrefix:sr xmlns:$srcPrefix=\"$srcURI\" xml:lang=\"et\"></$srcPrefix:sr>\n";
            close (L);
        }       
    }
} 



#väljastab suuruse -1 kui faili ei leitud
sub filestats($) {
    
    my ($filename) = @_;
    my ($user, $group, $permissions);
    my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks);
    #
    if (($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks) = lstat($filename)) {
            $user = getpwuid($uid);
            $group = getgrgid($gid);
            $permissions = sprintf "%04o", S_IMODE($mode);
            #'0664' == '664'
            #$permissions = sprintf "%03o", S_IMODE($mode);
            #'664' == '664'
    } else {
            #või midagi sarnast
           ($size, $permissions, $user, $group)=(-1,-1,-1,-1);
           
    }
    return ($size, $permissions, $user, $group);
}


#### Check Memory Usage
sub Memory_Check {
    ## Get current memory from shell
    my @mem = `ps aux | grep \"$$\"`;
    my($results) = grep !/grep/, @mem;

    ## Parse Data from Shell
    chomp $results;
    $results =~ s/^\w*\s*\d*\s*\d*\.\d*\s*\d*\.\d*\s*//g; $results =~ s/pts.*//g;
    my ($vsz,$rss) = split(/\s+/,$results);

    ## Format Numbers to Human Readable
    
    my $virt = $vsz;
    substr( $virt, -3, 0, ' ' ); 
    #$virt =~ s/(\d{3})$/.$1/;

    my $res = $rss;
    # $res =~ s/(\d{3})$/.$1/;
    substr( $res, -3, 0, ' ' );

    print "Current Memory Usage: Virt: ${virt}K RES: ${res}K<br/>";


}


#[011-08-11T16:56:21][EKudritski]kommentar
#[file.name][EKudritski]kommentar
sub logi {
    my($id, $kuhu ,$aegfail, $mess)=@_;
    my $logfile;
    if($kuhu==1){
        $logfile = SHS_logs_dir."/${id}_log.log";
    }else{
        $logfile = SHS_logs_dir."/${id}_files.log";
    }
    my $app = (-e $logfile ? '>>' : '>');
    $app .= $logfile;

    open (L, $app);
    binmode(L, ":utf8");
    print L "[${aegfail}] [$ENV{REMOTE_USER}] $mess\n";
    close (L);
} 

sub fnl($$){
      my ($t,$d) = @_;
      my $in= $t;
        
      if (-e $in) {
  #    print "<span style='color: green;'>Muutmata: $in (utf?) <br/></span>";
        return ($t,$d);
      }else{
      ## siin oleks vaaj teisendust 
        $in = decode_utf8($in);
        $in = encode("CP1257", $in);
        if (-e $in){
 #       print "<span style='color: blue;'>muudetult: $in (no utf) <br/></span>";
            ##
            $t = decode_utf8($t);
            $t = encode("CP1257", $t);
            $d = decode_utf8($d);
            $d = encode("CP1257", $d);
            return ($t,$d);
        }else{
#            print "<span style='color: red;'>Ei suutnud vavada: $in (utf?) <br/></span>";
            return ($t,$d);
        }    
      }  
      0;
}

1;

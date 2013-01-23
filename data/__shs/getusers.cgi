#!/usr/bin/perl

#saadab eelex setupile (ajax) kasutajanimed
# kasutatud uus.htm
use strict;
use utf8;
use Encode 'decode_utf8';
binmode(STDOUT, ":utf8");
use CGI;
my $q = new CGI;
my $id = $q->param('id');
if($id eq ''){
    my @parms = split(/\x{e001}/, decode_utf8($q->param('POSTDATA')));
    if($parms[0] eq 'id'){
        $id = $parms[1];
    }
}

my $grpfile = '';
    open (HTACCESS, "<", '.htaccess') || die "can't open '.htaccess': $!";
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
    foreach my $line (@grupid) {
        #grp_od_: VKorrovits KKuusk KJKangur EKolli MTiits
        if($line =~/^grp_$id:\s(.*)$/){
            sendD($1);
        }
    }
    close (F);
} else {
}



sub sendD(){
my ($found)=@_;
$found =~ s/\s/;/g; 
print "Content-type: text/txt; charset=utf-8\n\n";
print ';'.$found.';'; 
exit;
}


print "Content-type: text/html; charset=utf-8\n";
print "Status: 500 Internal server error\n\n";
print "EiLeia";
die "Probleemid '$grpfile' avamisega v6i grupi leidmisega";

#!/usr/bin/perl -w -T

use strict;
use lib qw( ./ );
use SHS_access;
use SHS;
use CGI;

binmode(STDOUT, ":utf8");

my $q = new CGI;

my $pwdir = '/var/www/EELex/shs_users';
my $shsconfigdir = '/var/www/EELex/data/__shs';
my $usrfile = $pwdir . '/shs_digest_users.txt';
my $grpfile_too = $pwdir . '/shs_groups.txt';
my $grpfile_test = $pwdir . '/shs_test_groups.txt';
my $lcfile = '/var/www/EELex/data/lexlist.xml';
my $logfile = './halda.log';
my $remoteuser = $q->remote_user();

sub logi {
    my $teade = shift;
    open (L, ">>$logfile") or return;
    print L "$teade\n";
    close (L);
}

if ($remoteuser) {
    logi ("...");
} else {
    $remoteuser = 'REMOTE_USER puudub';
}

sub kirjad {
    my ($kasutaja, $jah) = @_;
    if ($jah eq 'on') {
	SHS_access::SHS_add_user_to_group ($kasutaja, 'grp_KIRJAD', $grpfile_too);
	logi ("$remoteuser lisas admhalda kaudu $kasutaja gruppi grp_KIRJAD");
    }
    else {
	SHS_access::SHS_remove_user_from_group ($kasutaja, 'grp_KIRJAD', $grpfile_too);
	logi ("$remoteuser eemaldas admhalda kaudu $kasutaja grupist grp_KIRJAD");
    }
}

sub lisajad {
    my ($kasutaja, $jah) = @_;
    if ($jah eq 'on') {
	SHS_access::SHS_add_user_to_group ($kasutaja, 'grp_LISAJAD', $grpfile_too);
    }
    else {
	SHS_access::SHS_remove_user_from_group ($kasutaja, 'grp_LISAJAD', $grpfile_too);
    }
}

sub peatoimetajad {
    my ($kasutaja, $jah) = @_;
    if ($jah eq 'on') {
	SHS_access::SHS_add_user_to_group ($kasutaja, 'grp_PTD', $grpfile_too);
    }
    else {
	SHS_access::SHS_remove_user_from_group ($kasutaja, 'grp_PTD', $grpfile_too);
    }
}

my $kasutaja = $q->param('kasutaja');

if ( defined ($q->param('gkirjad')) ) {
    kirjad ($kasutaja, $q->param('kirjad'));
}
if ( defined ($q->param('glisajad')) ) {
    lisajad ($kasutaja, $q->param('lisajad'));
}
if ( defined ($q->param('gpeatoimetajad')) ) {
    peatoimetajad ($kasutaja, $q->param('peatoimetajad'));
}

print $q->header();

print '<html><head><script type="text/javascript">history.back();</script></head></html>';

#print '<html>';
#foreach my $key ($q->param()) {
#    print "<li>$key = ", $q->param($key), "\n";
#}
#print '</html>';


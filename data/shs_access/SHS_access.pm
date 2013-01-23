package SHS_access;
use strict;
use warnings;
use HTTPD::UserAdmin();
use Digest::MD5;

BEGIN {
    use Exporter ();
    our (@ISA, @EXPORT, @EXPORT_OK);
    @ISA = qw(Exporter);
    @EXPORT_OK = qw(&SHS_user_exists &SHS_user_in_group &SHS_add_user_to_group &SHS_remove_user_from_group &SHS_set_group);
}
our @EXPORT_OK;

my $pwdir = '/var/www/EELex/shs_users';
my $grpfile = $pwdir . '/shs_groups.txt';
my $usrfile = $pwdir . '/shs_digest_users.txt';
my $ankfile = $pwdir . '/ankeedid.txt';

my @grupid = ();
my @kasutajad = ();
my @ankeedid = ();

sub SHS_user_exists($) {
    my $user = shift;
    return 0 unless -e $usrfile;
    open (F, "<$usrfile");
    binmode (F, ":utf8");
    while (<F>) {
	next unless /^(.+):(.+):(.+)$/;
	return 1 if $1 eq $user;
    }
    close (F);
    return 0;
}

sub SHS_user_in_group($$$) {
    my ($user, $group, $grpfile) = @_;
    return 0 unless -e "$grpfile";
    open (F, "<$grpfile");
    binmode (F, ":utf8");
    while (<F>) {
	return 1 if /^$group:.* $user\s/;
    }
    close (F);
    return 0;
}

sub SHS_add_user_to_group($$$) {
    @grupid = ();
    my ($user, $group, $grpfile) = @_;
    return 0 unless -e "$grpfile";
    # kui juba on grupis
    return 1 if SHS_user_in_group ($user, $group, $grpfile);

    my $lisatud = 0;
    open (F, "<$grpfile");
    binmode (F, ":utf8");
    while (<F>) {
	chomp;
	if ( /^$group:/ ) { $_ .= " $user"; $lisatud = 1; }
	push @grupid, $_;
    }
    close (F);

    open (F, ">$grpfile");
    binmode (F, ":utf8");
    foreach (@grupid) {
	print F "$_\n";
    }
    print F "$group: $user\n" unless $lisatud;
    close (F);
    return 1;
}

sub SHS_remove_user_from_group($$$) {
    @grupid = ();
    my ($user, $group, $grpfile) = @_;
    return 0 unless -e "$grpfile";
    # kui pole selles grupis
    return 1 if not SHS_user_in_group ($user, $group, $grpfile);

    open (F, "<$grpfile");
    binmode (F, ":utf8");
    while (<F>) {
	$_ =~ s/ $user($| )/$1/ if /^$group: /;
	push @grupid, $_;
    }
    close (F);

    open (F, ">$grpfile") or die "Ei saa kirjutada grupifaili $grpfile";
    binmode (F, ":utf8");
    foreach (@grupid) {
	print F "$_";
    }
    close (F);
    return 1;
}

sub SHS_set_group($$$) {
    my ($users, $group, $grpfile) = @_;
    @grupid = ();
    return 0 unless -e "$grpfile";

    open (F, "<$grpfile");
    binmode (F, ":utf8");
    while (<F>) {
	push @grupid, $_ unless /^$group:/;
    }
    close (F);
    push @grupid, "$group: $users\n";

    open (F, ">$grpfile") or die "Ei saa kirjutada grupifaili $grpfile";
    binmode (F, ":utf8");
    foreach (@grupid) {
	print F "$_";
    }
    close (F);
    return 1;
}

1;

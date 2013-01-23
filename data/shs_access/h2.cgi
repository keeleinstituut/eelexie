#!/usr/bin/perl -w -T
use strict;
use lib qw( ./ );
use SHS_access;
#use lib qw( /var/www/EELex/shs_users );
use SHS;
# use Digest::MD5;
# use HTTPD::UserAdmin();
use Encode;
use Unicode::Normalize;
use CGI qw( -utf8 );

binmode(STDOUT, ":utf8");

my $q = new CGI;
print $q->header ( -charset => "utf-8" );
print $q->start_html(
    -title => 'EELex - kasutajate haldus',
    -style => { 'src' => '/eelex.css' },
);

my $pwdir = '/var/www/EELex/shs_users';
my $shsconfigdir = '/var/www/EELex/data/__shs';

my $usrfile = $pwdir . '/shs_digest_users.txt';
my $ankfile = $pwdir . '/ankeedid.txt';
my $grpfile_too = $pwdir . '/shs_groups.txt';
my $grpfile_test = $pwdir . '/shs_test_groups.txt';
my $lcfile = '/var/www/EELex/data/lexlist.xml';
my $logfile = './halda.log';
my $remoteuser = $q->remote_user();

if ($remoteuser) {
    logi ("...");
} else {
    $remoteuser = 'REMOTE_USER puudub';
}

#my $user = new HTTPD::UserAdmin (
#    DBType => 'Text', 
#    DB => $usrfile,
#    Encrypt => 'none',
#);

my @grupid_too = ();
my @grupid_test = ();
my @kasutajad = ();
my @ankeedid = ();
my %sonastikunimed = ();
my %peatoimetajad = ();

sub init_data {
    loe_ankeedid();
    loe_kasutajad();
    loe_grupid();
}

print "<div class=\"sektsioon\">";
print "<h2>EELexi s&otilde;nastike kasutajate haldus</h2>\n";
print "</div>";

# SISSEJUHATUSEKS LOEME KOIK ANDMED SISSE

loe_sonastikunimed();
init_data();
loe_peatoimetajad();	# ankeedid ja sonastikunimed peavad olema loetud

# UUE KASUTAJA LISAMINE: ANKEET -> SHS_DIGEST_USERS

if ( $q->param('func') eq 'ankadd' ) {
    my $guidtoadd = $q->param('guid');
    loe_ankeedid();
    foreach (@ankeedid) {
	my ($guid, $nn, $mm, $pp) = split ("\t");
	next unless $guid eq $guidtoadd;
	my $kk = nimi_kasutajanimeks ($nn);
	next if SHS_access::SHS_user_exists($kk);
#	$pp = Digest::MD5::md5_hex("$kk:'SHS':$pp");
#	$user->add( "$kk:\'SHS\'", $pp);
	lisa_kasutaja($kk, $pp);
	logi ("ankeet->kasutaja " . $kk);
    }
    init_data();
}

# UUE KASUTAJA KUSTUTAMINE: ANKEET -> ID KUTUKS

my $kasutajameiliaadress =  '';
if ( $q->param('func') eq 'ankdel' ) {
    my $guidtodel = $q->param('guid');
    loe_ankeedid();
    open (F, ">$ankfile");
    binmode (F, ":utf8");
    foreach (@ankeedid) {
	if ( /^$guidtodel\t(.+?)\t(.+?)\t/ ) {
	    &meiliteade ($3, 'Teie ankeet kustutati');
	    logi ("kustutas " . $2 . " ankeedi");
	} else {
	    print F "$_\n";
	}
    }
    close (F);
    init_data();
}

# KUI ME MUUTSIME KASUTAJA LIGIPAASUOIGUSI SONASTIKELE

if ( $q->param('userchg') eq '1' ) {
    my $guidnimi = $q->param('guid');
    my $uuedoigused = "Kasutaja $guidnimi muudetud kasutajaoigused on:\n";
    my $logirida = "muutis $guidnimi oigusi:";

    foreach my $id (sort keys %sonastikunimed) {
	my $butval = $q->param('rad_' . $id . '_too');
	$uuedoigused .= $sonastikunimed{$id} . " - tooversiooni toimetaja\n" if $butval eq 'T';
	$uuedoigused .= $sonastikunimed{$id} . " - tooversiooni vaataja\n" if $butval eq 'V';

	my $dicval = "X";
	if ( SHS_access::SHS_user_in_group ($guidnimi, 'grp_'.$id, $grpfile_too) ) {
	    $dicval = "T";
	}
	elsif ( SHS_access::SHS_user_in_group ($guidnimi, 'quest_'.$id, $grpfile_too) ) {
	    $dicval = "V";
	}
	if ($dicval ne $butval) {
	    $logirida .= " $id: $dicval->$butval";
	    SHS_access::SHS_add_user_to_group ($guidnimi, 'grp_'.$id, $grpfile_too) if $butval eq 'T';
	    SHS_access::SHS_add_user_to_group ($guidnimi, 'quest_'.$id, $grpfile_too) if $butval eq 'V';
	    SHS_access::SHS_remove_user_from_group ($guidnimi, 'grp_'.$id, $grpfile_too) if $butval ne 'T';
	    SHS_access::SHS_remove_user_from_group ($guidnimi, 'quest_'.$id, $grpfile_too) if $butval ne 'V';
	}

	$butval = $q->param('rad_' . $id . '_test');
	$uuedoigused .= $sonastikunimed{$id} . " - testversiooni toimetaja\n" if $butval eq 'T';
	$uuedoigused .= $sonastikunimed{$id} . " - testversiooni vaataja\n" if $butval eq 'V';

	$dicval = "X";
	if ( SHS_access::SHS_user_in_group ($guidnimi, 'grp_'.$id, $grpfile_test) ) {
	    $dicval = "T";
	}
	elsif ( SHS_access::SHS_user_in_group ($guidnimi, 'quest_'.$id, $grpfile_test) ) {
	    $dicval = "V";
	}
	if ($dicval ne $butval) {
	    $logirida .= " $id: $dicval->$butval";
	    SHS_access::SHS_add_user_to_group ($guidnimi, 'grp_'.$id, $grpfile_test) if $butval eq 'T';
	    SHS_access::SHS_add_user_to_group ($guidnimi, 'quest_'.$id, $grpfile_test) if $butval eq 'V';
	    SHS_access::SHS_remove_user_from_group ($guidnimi, 'grp_'.$id, $grpfile_test) if $butval ne 'T';
	    SHS_access::SHS_remove_user_from_group ($guidnimi, 'quest_'.$id, $grpfile_test) if $butval ne 'V';
	}
    }

    foreach $a (@ankeedid) {
	my ($guid, $nn, $mm, $pp) = split ("\t", $a);
	next unless $mm;
	my $kk = nimi_kasutajanimeks ($nn);
	next unless ($kk eq $guidnimi);
	meiliteade ($mm, $uuedoigused);
    }

    logi ($logirida);
    init_data();
}


# KASUTAJA ANDMED KOIGE EES

if ( $q->param('func') eq 'useredit' ) {
    my $guidnimi = $q->param('guid');
    prindikasutajaandmed($guidnimi);
}

# KASUTAJA ANDMED KOIGE EES

if ( $q->param('func') eq 'userdel' ) {
    my $guidnimi = $q->param('guid');
    logi ("kustutas kasutaja " . $guidnimi);
    kustuta_kasutaja($guidnimi);
    init_data();
}

sub nimi_kasutajanimeks {
    my $nn = shift;
    $nn =~ s/\x{00dc}/Y/g;	##  
    $nn =~ s/\x{00fc}/y/g;	##  � = y on ainus erand

    $_ = NFD( $nn );	##  decompose (Unicode Normalization Form D)
    s/\pM//g;			##  strip combining characters
    s/\x{00df}/ss/g;	##  German beta “ß” -> “ss”
    s/\x{00c6}/AE/g;	##  Æ
    s/\x{00e6}/ae/g;	##  æ
    s/\x{0132}/IJ/g;	##  Ĳ
    s/\x{0133}/ij/g;	##  ĳ
    s/\x{0152}/Oe/g;	##  Œ
    s/\x{0153}/oe/g;	##  œ

    tr/\x{00d0}\x{0110}\x{00f0}\x{0111}\x{0126}\x{0127}/DDddHh/; # ÐĐðđĦħ
    tr/\x{0131}\x{0138}\x{013f}\x{0141}\x{0140}\x{0142}/ikLLll/; # ıĸĿŁŀł
    tr/\x{014a}\x{0149}\x{014b}\x{00d8}\x{00f8}\x{017f}/NnnOos/; # ŊŉŋØøſ
    tr/\x{00de}\x{0166}\x{00fe}\x{0167}/TTtt/;                   # ÞŦþŧ

    $_ =~ s/[^a-zA-Z\- ]//g;	# koolonite, tyhikute jm jama valtimiseks

    return (/^\s*(.).* (.)(.+)$/ ? uc($1).uc($2).lc($3) : $_);
}

sub loe_grupid {
    if (-e "$grpfile_too") {
	open (F, "<$grpfile_too");
	binmode (F, ":utf8");
	@grupid_too = (<F>);
	chomp @grupid_too;
	close (F);
    } else {
	open (F, ">$grpfile_too");
	close (F);
    }
    if (-e "$grpfile_test") {
	open (F, "<$grpfile_test");
	binmode (F, ":utf8");
	@grupid_test = (<F>);
	chomp @grupid_test;
	close (F);
    } else {
	open (F, ">$grpfile_test");
	close (F);
    }
}

sub loe_kasutajad {
    if (-e "$usrfile") {
	open (F, "<$usrfile");
	binmode (F, ":utf8");
	@kasutajad = (<F>);
	chomp @kasutajad;
	close (F);
    } else {
	open (F, ">$usrfile");
	close (F);
    }
}

sub loe_ankeedid {
    if (-e "$ankfile") {
	open (F, "<$ankfile");
	binmode (F, ":utf8");
	@ankeedid = (<F>);
	chomp @ankeedid;
	close (F);
    } else {
	open (F, ">$ankfile");
	close (F);
    }
}

sub loe_sonastikunimed {
    exit unless (-e $lcfile);
    my $id = '';
    my ($ll, $lx) = '';
    open (F, "<$lcfile");
    binmode (F, ":utf8");
    while (<F>) {
	chomp;
	$ll .= $_;
    }
    close (F);

    while ( $ll =~ /<lex .+?<\/lex>/ ) {
	$ll = $';
	$lx = $&;
	next unless $lx =~ / id=\"(.+?)\"/; # kui id puudub, ei tee midagi
	$id = $1;
	next unless $lx =~ / l=\"et\">(.+?)</; # kui eestikeelne plk puudub, ei tee ka
	$sonastikunimed{$id} = $1;
    }
}

sub loe_peatoimetajad {
    my %ptd = ();	# iga kord kui siia poordutakse, teeme PTD grupi uuesti
    my ($pt, $ptmail) = '';
    foreach my $id (keys %sonastikunimed) {
	my $dcfile = "$shsconfigdir/shsconfig_$id.xml";
	next unless (-e $dcfile);
	open (F, "<$dcfile");
	binmode (F, ":utf8");
	while (<F>) {
	    next unless /<ptd>(.*?)<\/ptd>/;
	    $pt = $1;
	    $ptmail = '';
	    foreach (split (/;/, $pt)) {
		next unless $_;
		$ptd{$_} = 1;
		$pt = kasutaja_meiliaadress($_);
		next unless $pt;
		$ptmail .= ', ' if $ptmail;
		$ptmail .= $pt;
	    }
	    $peatoimetajad{$id} = $ptmail;
	}
	
	close (F);
    }
    $pt = join (' ', keys %ptd);
    SHS_access::SHS_set_group ($pt, 'grp_PTD', $grpfile_test);
    SHS_access::SHS_set_group ($pt, 'grp_PTD', $grpfile_too);
}

sub lisa_kasutaja {
    my ($user, $pass) = @_;
    exit if SHS_access::SHS_user_exists($user);
    $pass = Digest::MD5::md5_hex("$user:'SHS':$pass");
    open (F, ">>$usrfile");
    print F "$user:'SHS':$pass\n";
    close (F);
    init_data();
}

sub kustuta_kasutaja {
    my ($user) = @_;
    loe_kasutajad;
    open (F, ">$usrfile");
    binmode (F, ":utf8");
    foreach ( @kasutajad ) {
	print F "$_\n" unless /^$user:/;
#	print "Kustutan $_\n" if /^$user:/;
    }
    close (F);
    init_data();
}

sub kasutaja_meiliaadress {
    my $kasutajanimi = shift;
    foreach $a (@ankeedid) {
	my ($guid, $nn, $mm, $pp) = split ("\t", $a);
	my $kk = nimi_kasutajanimeks ($nn);
	next unless $kk eq $kasutajanimi;
	return $mm;
    }
    return '';
}

sub prindiankeedid {
    print "<div id=\"ankeedid\" class=\"sektsioon\">";
    print "<h2>Ootel ankeedid</h2>\n";
    print "<table>\n";
    print "<tr><th>Nimi</th><th>Meiliaadress</th><th>EELexi kasutaja</th><th>Tegevus</th></tr>\n";
    foreach $a (@ankeedid) {
	my ($guid, $nn, $mm, $pp) = split ("\t", $a);
	next unless $pp;
	my $kk = nimi_kasutajanimeks ($nn);
	next if SHS_access::SHS_user_exists($kk);
	print "<tr>";
	print "<td>$nn</td>";
	print "<td>$mm</td>";
	print "<td>$kk</td>";
	print "<td>";
	print "<a href=\"" . $q->script_name() . "?func=ankadd&guid=$guid\">Lisa kasutajaks</a> / ";
	print "<a href=\"" . $q->script_name() . "?func=ankdel&guid=$guid\">Kustuta ankeet</a>";
	print "</td>";
	print "</tr>\n";
    }
    print "</table>\n</div>\n";
}

sub kasutaja_meil {
    my $kasutajanimi = shift;

    foreach $a (@ankeedid) {
	my ($guid, $nn, $mm, $pp) = split ("\t", $a);
	my $kk = nimi_kasutajanimeks ($nn);
	next unless $kk eq $kasutajanimi;
	next unless $mm;

	my $s = '<a href="mailto:' . $mm;
	$s .= '?subject=EELexi konto';
	$s .= '&body=Lugupeetud ' . $nn .'! %0a%0a';
	$s .= 'Teie konto EELexi s&otilde;nastike s&uuml;steemis on aktiveeritud. ';
	$s .= 'Kasutajanimeks sai ' . $kk;
	$s .= '">Kirjuta kasutajale</a>';
	return $s;
    }
    return 'Kirjuta kasutajale';
}

sub knsort {
    my $aa = ( $a =~ /^([A-Z])([A-Z].+)/ ? $2 : $a );
    my $bb = ( $b =~ /^([A-Z])([A-Z].+)/ ? $2 : $b );
    return $aa cmp $bb;
}

sub prindikasutajad {
    loe_kasutajad();
    print "<div id=\"kasutajad\" class=\"sektsioon\">";
    print "<h2>EELexi kasutajad</h2>\n";
    print "<table>\n";
    print "<tr><th>Kasutajanimi</th><th>T&ouml;&ouml;versioon</th><th>Testversioon</th></tr>\n";
    foreach (sort knsort @kasutajad) {
	next unless /^(.+):(.+):(.+)$/;
	my $kk = $1;
#	next if SHS_access::SHS_user_in_group ($kk, 'grp_DEV', $grpfile_too);
#	next if SHS_access::SHS_user_in_group ($kk, 'grp_TEH', $grpfile_too);
	print "<tr>";
	print "<td><a href=\"" . $q->script_name() . "?func=useredit&guid=$kk\">$kk</a></td>";

	print "<td>";
	my @kasutajagrupid = ();
	my ($toimetaja, $vaataja, $muu) = '';
	foreach (@grupid_too) {
	    $_ .= ' ';
	    next unless /^(.+?):.* $kk /;
	    push @kasutajagrupid, $1;
	}
	foreach (@kasutajagrupid) {
	    if ( /^grp_/ ) {
		$toimetaja .= ( $toimetaja ? '' : '<b>Toimetaja:</b> ' );
		$toimetaja .= " $'";
	    }
	    elsif ( /^[qg]uest_/ ) {
		$vaataja .= ( $vaataja ? '' : '<b>Vaataja:</b> ' );
		$vaataja .= " $'";
	    }
	    else {
		$muu .= ( $muu ? '' : '<b>Muu (seda ei tohiks olla):</b> ' );
		$muu .= " $_";
	    }
	}
	$toimetaja .= "<br />" if $toimetaja and $vaataja;
	$toimetaja .= $vaataja if $vaataja;
	$toimetaja .= "<br />$muu" if $muu;
	$toimetaja = 'Arendaja' if SHS_access::SHS_user_in_group ($kk, 'grp_DEV', $grpfile_too);
	$toimetaja = 'Tehniline konto' if SHS_access::SHS_user_in_group ($kk, 'grp_TEH', $grpfile_too);
	print $toimetaja;
	print "</td>";

	print "<td>";
	@kasutajagrupid = ();
	($toimetaja, $vaataja, $muu) = '';
	foreach (@grupid_test) {
	    $_ .= ' ';
	    next unless /^(.+?):.* $kk /;
	    push @kasutajagrupid, $1;
	}
	foreach (@kasutajagrupid) {
	    if ( /^grp_/ ) {
		$toimetaja .= ( $toimetaja ? '' : '<b>Toimetaja:</b> ' );
		$toimetaja .= " $'";
	    }
	    elsif ( /^[qg]uest_/ ) {
		$vaataja .= ( $vaataja ? '' : '<b>Vaataja:</b> ' );
		$vaataja .= " $'";
	    }
	    else {
		$muu .= ( $muu ? '' : '<b>Muu (seda ei tohiks olla):</b> ' );
		$muu .= " $_";
	    }
	}
	$toimetaja .= "<br />" if $toimetaja and $vaataja;
	$toimetaja .= $vaataja if $vaataja;
	$toimetaja .= "<br />$muu" if $muu;
	$toimetaja = 'Arendaja' if SHS_access::SHS_user_in_group ($kk, 'grp_DEV', $grpfile_test);
	$toimetaja = 'Tehniline konto' if SHS_access::SHS_user_in_group ($kk, 'grp_TEH', $grpfile_test);
	print $toimetaja;
	print "</td>";

	print "</tr>\n";
    }
    print "</table>\n</div>\n";
}

sub prindinupud {
    # kasutaja id, sonastiku id ja _too / _test
    my ($kid, $sid, $ver) = @_;
    my $grpfile = ( $ver eq '_too' ? $grpfile_too : $grpfile_test );
    my $toimetaja = SHS_access::SHS_user_in_group ($kid, 'grp_' . $sid, $grpfile);
    my $vaataja = SHS_access::SHS_user_in_group ($kid, 'quest_' . $sid, $grpfile);

    print "<td>";

    print '<input type="radio" name="rad_' . $sid . $ver . '" value="T" align="baseline"';
    print " checked" if $toimetaja;
    print "> toimetaja ";

    print '<input type="radio" name="rad_' . $sid . $ver . '" value="V" align="baseline"';
    print " checked" if $vaataja and not $toimetaja;
    print "> vaataja ";

    print '<input type="radio" name="rad_' . $sid . $ver . '" value="X" align="baseline"';
    print " checked" unless $toimetaja or $vaataja;
    print "> eikeegi";

    print "</td>";
}

sub prindikasutajaandmed {
    my $kasutajanimi = shift;
    print "<div id=\"kasutaja\" class=\"sektsioon\">";
    print "<h2>EELexi kasutaja: $kasutajanimi</h2>\n";
    print "<p>";
    print "<a href=\"" . $q->script_name() . "?func=userdel&guid=$kasutajanimi\">Kustuta see kasutaja</a> &bull; ";
    print kasutaja_meil($kasutajanimi);
    print "</p>";

    print $q->start_form (
	-action => $q->script_name(),
	-method => 'POST',
    );
    print $q->hidden (
	-name => 'guid',
	-value => $kasutajanimi,
    );
    print $q->hidden (
	-name => 'userchg',
	-value => '1',
    );


    print "<table>\n";
    print "<tr><th>ID</th><th>S&otilde;nastiku nimi</th><th>T&ouml;&ouml;versioon</th><th>Testversioon</th></tr>\n";

    foreach my $id (sort keys %sonastikunimed) {
	my $snimi = $sonastikunimed{$id};
	my $on_pt = (on_selle_sonastiku_peatoimetaja ($kasutajanimi, $id) ? ' (<b>PT</b>)' : '' );
	print "<tr>";
	print "<td>$id</td>";
	print "<td>$snimi$on_pt</td>";

	prindinupud ($kasutajanimi, $id, '_too');
	prindinupud ($kasutajanimi, $id, '_test');

	print "</tr>\n";
    }

    print "</table>\n<p />\n";
    print $q->submit ( 'Muudan selle kasutaja andmeid.' );
    print $q->end_form;

    print "</div>\n";
}

init_data();
prindiankeedid();
prindikasutajad();

# print "<p><a href=\"http://eelextest.eki.ee/__shs/temp/psv_msLoend_ALoopmann.txt\" charset=\"ISO-8859-5\" target=\"_blank\">test</a></p>\n";

print $q->end_html;

sub meiliteade {
    my ($kasutajameiliaadress, $teatesisu) = @_;
    my $algneaadress = $kasutajameiliaadress;
    $kasutajameiliaadress = 'kiisu@eki.ee';

    $ENV{PATH} = '/usr/sbin:/sbin:/root/bin:/bin';
    open  (M, "|/usr/sbin/sendmail -t") or die ('Viga meili saatmisel');
    print (M "To: $kasutajameiliaadress\n");
    print (M "From: eelex.admin\@eki.ee\n");
    print (M "Subject: EELex teade/message\n");
    print (M "Content-type: text/plain\n\n");
    print (M $teatesisu . "\n");
    print (M "PS Kirja algne adressaat oli $algneaadress\n");
    close (M);
}

sub logi {
    my $mess = shift;
    my $app = (-e $logfile ? '>>' : '>');
    $app .= $logfile;
#print "$app\n"; sleep (5);
    open (L, $app);
    print L scalar localtime();
    print L " $remoteuser \t$mess\n";
    close (L);
}

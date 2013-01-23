package SHS;

use strict;
use Exporter;
our @ISA = qw( Exporter );

our @EXPORT = qw (
    on_selle_sonastiku_peatoimetaja
    saada_meil
);

our @EXPORT_OK = qw (
    ankeet_uuenda_faili_formaat
);

use Data::UUID;
use Digest::MD5;
use Unicode::Normalize;

my $webroot = '/var/www/EELex';

our $shsconfigdir = $webroot . '/data/__shs';
our $lcfile = $webroot . '/data/lexlist.xml';
our $pwdir = $webroot . '/shs_users';
    $pwdir = $webroot . '/data/shs_access/test';
our $usrfile = $pwdir . '/shs_digest_users.txt';
our $ankfile = $pwdir . '/ankeedid.txt';
our $grpfile_too = $pwdir . '/shs_groups.txt';
our $grpfile_test = $pwdir . '/shs_test_groups.txt';

our @ankeedid = ();

our %sonastikunimed = ();	# pref -> eestikeelne nimetus
our %sid_ptd = ();		# peatoimetajad: ss_ -> " YViks MLangemets ALoopmann "

# --------------------------------------------------

sub on_selle_sonastiku_peatoimetaja {
    my ($kn, $sid) = @_;
    &loe_peatoimetajad() unless scalar(keys %sid_ptd);
    return ( $sid_ptd{$sid} =~ / $kn / ? 1 : 0 );
}

sub loe_peatoimetajad {
    my %ptd = ();	# iga kord kui siia poordutakse, teeme PTD grupi uuesti
    my ($pt, $ptmail) = '';
    sonastikunimed_loe() unless scalar(keys %sonastikunimed);

    foreach my $id (keys %sonastikunimed) {
	my $dcfile = "$shsconfigdir/shsconfig_$id.xml";
	next unless (-e $dcfile);
	open (F, "<$dcfile");
	binmode (F, ":utf8");
	while (<F>) {
	    next unless /<ptd>(.*?)<\/ptd>/;
	    $pt = $1;
	    $pt =~ s/\s*;\s*/ /g;
	    $sid_ptd{$id} = $pt;
	    foreach (split (/ /, $pt)) {
		next unless $_;
		$ptd{$_} = 1;
	    }
	}
	
	close (F);
    }
    $pt = join (' ', keys %ptd);
    set_group ($pt, 'grp_PTD', $grpfile_test);
    set_group ($pt, 'grp_PTD', $grpfile_too);
}

sub sonastikunimed_loe {
    exit unless (-e $lcfile);
    my ($id, $ll, $lx) = '';
    open (F, "<$lcfile");
    binmode (F, ":utf8");

    while (<F>) {
	chomp;
	$ll .= $_;
    }
    close (F);
    %sonastikunimed = ();
    while ( $ll =~ /<lex .+?<\/lex>/ ) {
	$ll = $';
	$lx = $&;
	next unless $lx =~ / id=\"(.+?)\"/; # kui id puudub, ei tee midagi
	$id = $1;
	next unless $lx =~ / l=\"et\">(.+?)</; # kui eestikeelne plk puudub, ei tee ka midagi
	$sonastikunimed{$id} = $1;
    }
}


sub saada_meil {
    my ($kellele, $teema, $sisu) = shift;
    chomp ($sisu);
    return if $kellele !~ /\@/;
    return unless $sisu;
    $teema = 'EELexi teade' unless $teema;

    my $sm = "|/usr/sbin/sendmail -t";
    $sm = '>epost_' . time();

    open  (M, $sm) or die ('Viga meili saatmisel');
    print (M "To: " . $kellele . "\n");
    print (M "From: eelex.admin\@eki.ee\n");
    print (M "Subject: " . $teema . "\n");
    print (M "Content-type: text/plain\n\n");
    print (M "$sisu\n");

    close (M);
}

sub meiliaadress {
    my $kasutajanimi = shift;
    foreach $a (@ankeedid) {
	my ($guid, $nn, $mm, $pp) = split ("\t", $a);
	my $kk = nimi_kasutajanimeks ($nn);
	next unless $kk eq $kasutajanimi;
	return $mm;
    }
    return '';
}

sub meili_peatoimetajatele {
    my ($pn, $sid) = shift;
    sonastikunimed_loe() unless scalar(keys %sonastikunimed);
    my $ptd = $sid_ptd{$sid};
    my $to = 'eelex.admin@eki.ee';

    foreach my $pt (split (/ /, $ptd)) {
	next unless $pt;
	$pt = meiliaadress ($pt);
	next unless $pt =~ /\@/;
	$to .= ", $pt";
    }

    $sid = $sonastikunimed{$sid};
    open  (M, "|/usr/sbin/sendmail -t") or die ('Viga meili saatmisel');

    print (M "To: kiisu\@eki.ee\n");
#    print (M "To: " . $to . "\n");

    print (M "From: eelex.admin\@eki.ee\n");
    print (M "Subject: EELEX: uus kasutaja vajab lisamist\n");
    print (M "Content-type: text/plain\n\n");
    print (M "Kasutaja $pn soovis saada EELexi kasutajaks ja\n");
    print (M "mainis oma seotust sonastikuga $sid.\n");
    print (M "Keda see teade puudutab, palun ajage asi jonksu.\n");
    print (M "Link on http://eelextest.eki.ee/shs_access/halda.cgi\n");
    print (M "PS algne adressaat oli: $to\n");

    close (M);
}





# muutujad, mis vaja mujal kattesaadavaks teha

our %peatoimetajad = ();	# pref -> kasutajanimed; tyhik vahel kui mitu peatoimetajat


our @grupid_too = ();
our @grupid_test = ();
our @kasutajad = ();























sub ankeet_uuenda_faili_formaat {
    open (F, "</www/shs_users/ankeedid.txt");
    binmode (F, ":utf8");
    @ankeedid = (<F>);
    chomp @ankeedid;
    close (F);

    open (F, ">/www/shs_users/ankeedid.uus");
    binmode (F, ":utf8");
    foreach $a (@ankeedid) {
	my ($gg, $pn, $mm, $pw) = split (/\t/, $a);
	ankeet_salvesta ($pn, '', $mm, 'eitea', $pw);
    }
    close (F);
}

sub ankeet_loelist {
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

sub ajatempel {
    my @aeg = localtime(time);
    my $tempel = $aeg[5]+1900;
    $tempel .= '-';
    $tempel .= '0' if $aeg[4] < 9;
    $tempel .= $aeg[4]+1;
    $tempel .= '-';
    $tempel .= '0' if $aeg[3] < 10;
    $tempel .= $aeg[3];
    return $tempel;
}

sub ankeet_salvesta {
    # sisse: parisnimi, kasutajanimi, meiliaadress, soovitudsonastik, parool
    my ($pn, $kn, $mm, $dd, $pw) = @_;
    $kn = nimi_kasutajanimeks ($pn) unless $kn;
    my $uuid = new Data::UUID;
    my $guid = $uuid->create_str();
    my $aeg = ajatempel;
    my $append = (-e "$ankfile" ? '>' : '');
    open (F, ">$append$ankfile");
    binmode (F, ":utf8");
    print F "$guid\t$aeg\t$kn\t$pn\t$mm\t$dd\t$pw\n";
    push @ankeedid, "$guid\t$aeg\t$kn\t$pn\t$mm\t$dd\t$pw";
    close (F);
    &meili_teade;
    print '<script language="javascript" type="text/javascript"> window.setTimeout("window.location=\'../\';", 6000); </script>', "\n";
}

sub ankeet_jubaon {
    my ($oldpn, $oldmm, $oldpw) = @_;
    open (F, "<$ankfile");
    while (<F>) {
	chomp;
	my ($guid, $aa, $kn, $pn, $mm, $dd, $pw) = split (/\t/, $_);
	return 1 if (
	    ($pn eq $oldpn) and ($mm eq $oldmm) and ($pw eq $oldpw)
	);
    }
    close (F);
    return 0;
}

sub ankeet_kustuta {
    my ($guid) = @_;
    ankeet_loelist();
    open (F, ">$ankfile");
    binmode (F, ":utf8");
    foreach (@ankeedid) {
	if ( /^$guid\t(.+?)\t(.+?)\t/ ) {
#	    &meiliteade ($3, 'Teie ankeet kustutati');
	} else {
	    print F "$_\n";
	}
    }
    close (F);
    ankeet_loelist();
}

sub sonastikunimi {
    my $id = shift;
    sonastikunimed_loe unless scalar(keys %sonastikunimed);
    return $sonastikunimed{$id};
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

sub set_group($$$) {
    my ($users, $group, $grpfile) = @_;
    return 0 unless -e "$grpfile";
    my @grupid = ();

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
}

sub meili_teade {
    my ($meiliaadress, $teatesisu) = @_;
my $algneaadress = $meiliaadress;
$meiliaadress = 'kiisu@eki.ee';
    $ENV{PATH} = '/usr/sbin:/sbin:/root/bin:/bin';
    open  (M, "|/usr/sbin/sendmail -t") or die ('Viga meili saatmisel');

    print (M "To: $meiliaadress\n");
    print (M "From: eelex.admin\@eki.ee\n");
    print (M "Subject: EELex teade/message\n");
    print (M "Content-type: text/plain\n\n");
    print (M $teatesisu . "\n");
print (M "PS Kirja algne adressaat oli $algneaadress\n");
    close (M);
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

sub lisa_kasutaja {
    my ($user, $pass) = @_;
    exit if juba_on_selline_kasutaja($user);
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

sub SHS_remove_user_from_group($$$) {
    my @grupid = ();
    my ($user, $group, $grpfile) = @_;
    return 0 unless -e "$grpfile";
    # kui pole selles grupis
    return 1 if not user_in_group ($user, $group, $grpfile);

    open (F, "<$grpfile");
    binmode (F, ":utf8");
    while (<F>) {
	$_ = "$1$3" if /^($group:.*)( $user)(\s.*)/;
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

sub user_exists($) {
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

sub user_in_group($$$) {
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
    my @grupid = ();
    my ($user, $group, $grpfile) = @_;
    return 0 unless -e "$grpfile";
    # kui juba on grupis
    return 1 if user_in_group ($user, $group, $grpfile);

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



1;

#!/usr/bin/perl -T
# use strict;
use Encode 'decode_utf8';
use Data::UUID;
use CGI qw( -utf8 );

binmode(STDOUT, ":utf8");

$ENV{PATH} = '/usr/sbin:/sbin:/root/bin:/bin';
my $pwdir = '/var/www/EELex/shs_users';
my $lcfile = '/var/www/EELex/data/lexlist.xml';
my %sonastikunimed = ();

my $q = new CGI;
$q->charset("utf-8");

my $uuid = new Data::UUID;
my $guid = $uuid->create_str();

my %langen = (
    title => 'EELex - new user',
    chooselang => '<a href="./ankeet.cgi?lang=et"><b>Sama vorm eesti keeles</b></a>',
    entername => 'Please eneter your full name',
    entermail => 'Please eneter your e-mail address',
    enterpw1 => 'Please eneter a password',
    enterpw2 => 'Please repeat the same password',
    enterdict => 'What dictionary workgroup were you invited to?',
    wanttoregister => 'I want to apply for EELex account',
    missingfields => 'Fields marked with * must be filled correctly',
    samedata => 'There is no point in filling more than one form with the same data',
    nowwhat => 'Your form will be passed on to dictionary editor, you will be redirected to EELexi start page',
    back => 'Back to EELex start page',
);
my %langet = (
    title => 'EELex - uus kasutaja',
    chooselang => '<a href="./ankeet.cgi?lang=en"><b>Same form in English</b></a>',
    entername => 'Palun sisestage oma ees- ja perekonnanimi',
    entermail => 'Palun sisestage oma meiliaadress',
    enterpw1 => 'Palun sisestage soovitud parool',
    enterpw2 => 'Palun korrake parooli',
    enterdict => 'Millise s&otilde;naraamatu t&ouml;&ouml;r&uuml;hma teid kutsuti?',
    wanttoregister => 'Soovin hakata EELexi kasutajaks',
    missingfields => 'T&auml;rniga v&auml;ljad on vaja korrektselt t&auml;ita',
    samedata => 'Pole m&otilde;tet t&auml;ita rohkem kui &uuml;ks ankeet samade andmetega',
    nowwhat => 'Ankeet suunatakse edasi s&otilde;nastike peatoimetajale, teid suunatakse EELexi avalehele',
    back => 'Tagasi EELexi avalehele',
);

my %lang = ();

if ( $q->param("lang") eq 'en' ) {
    %lang = %langen;
} else {
    %lang = %langet;
}




print $q->header ( -charset => "utf-8" );
print $q->start_html(
    -title => $lang{'title'},
    -style => { 'src' => '/eelex.css' },
);
print "<div style=\"margin-left:120px; margin-top:30px; width:600px;\"/>\n";

my $txrn = ' <span style="font:bold 24px; color:red">*</span>';
my $nurin_nimi = ($q->param('parisnimi') =~ /. ./ ? '' : $txrn);
my $nurin_meil = ($q->param('meil') =~ /^[a-z._\-]+\@[a-z._\-]+$/i ? '' : $txrn);
my $nurin_pass1 = ($q->param('parool1') =~ /^\s*$/ ? $txrn : '');
my $nurin_pass2 = ($q->param('parool1') eq $q->param('parool2') ? '' : $txrn);

print "<p style=\"text-align:right;\"/>" . $lang{'chooselang'} . "</p>\n";

print $q->start_form (
    -method => 'POST',
);

print "<h2>" . $lang{'entername'} . "$nurin_nimi</h2>\n";
print $q->textfield ( 'parisnimi', '', 60, 80);
print "<h2>" . $lang{'entermail'} . "$nurin_meil</h2>\n";
print $q->textfield ( 'meil', '', 60, 80);
print "<h2>" . $lang{'enterpw1'} . "$nurin_pass1</h2>\n";
print $q->password_field ( 'parool1', '', 30, 80);
print "<h2>" . $lang{'enterpw2'} . "$nurin_pass2</h2>\n";
print $q->password_field ( 'parool2', '', 30, 80);

loe_sonastikunimed();
$sonastikunimed{'eee'} = '?';
print "<h2>" . $lang{'enterdict'} . "</h2>\n";
print $q->popup_menu ( 
    -name => 'sr',
    -values => [sort {$sonastikunimed{$a} cmp $sonastikunimed{$b}} keys %sonastikunimed],
    -labels => \%sonastikunimed
);
print "<p style=\"margin-left:240px;\"/>\n";

print $q->submit ( $lang{'wanttoregister'} );

if ($nurin_nimi . $nurin_meil . $nurin_pass1 . $nurin_pass2) {
    print "<p style=\"margin-left:240px; color:red;\">" . $lang{'missingfields'} . ".</p>\n";
}
elsif ( jubaonsellineankeet() ) {
    print "<h2>" . $lang{'samedata'} . ".</h2>\n";
    print "<h2><a href=\"../\">" . $lang{'back'} . "</a>.</h2>\n";
    print '<script language="javascript" type="text/javascript"> window.setTimeout("window.location=\'../\';", 6000); </script>', "\n";
}
else {
    print "<p>Ankeet suunatakse edasi s&otilde;nastike peatoimetajale, teid suunatakse EELexi avalehele.</p>\n";
    print "<h2><a href=\"../\">" . $lang{'back'} . "</a>.</h2>\n";
    salvestaankeet();
}

print $q->end_form;


if ( $q->param("lang") eq 'en' ) {

print <<PSen;

<hr>
<h2>Additional information</h2>
<ul>
<li> Your chosen password will be saved unencrypted.
Even if only server administrator has the access rights, we still
recommend not to use your 'everyday' password.</li>
<li> To change your password (or mail address), please fill a new
form and let server admin know - mail to eelex\@eki.e&#101;</li>
<li> EKI will not pass your personal data to any third party and
uses it only to resolve work related issues.</li>
</ul>

PSen

} else {

print <<PSet;

<hr>
<h2>Lisateave</h2>
<ul>
<li> Teie valitud parooli säilitatakse krüptimata kujul.
Ligipääs sellele on küll ainult serveri administraatori(te)l, kuid soovitame
siiski mitte kasutada oma 'igapäevast' parooli.</li>
<li> Parooli (aga ka töötava meiliaadressi jm) vahetamiseks täitke
uus ankeet ning andke oma soovist märku serveri haldajale eelex\@eki.e&#101;</li>
<li> EKI ei anna teie isikuandmeid mitte kellelegi edasi ning kasutab neid
ainult tööga vältimatult seotud olukordades.</li>
</ul>

PSet

}
print "</div>\n";
print $q->end_html;

# -------------------------------------------------------------

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
	next unless $lx =~ / type=\"(.+?)\"/; # kui tyyp puudub, ei tee midagi
	$id = $1;
	next unless $id =~ /^(Yks|Mit|Trm)/;
	next unless $lx =~ / id=\"(.+?)\"/; # kui id puudub, ei tee midagi
	$id = $1;
	next unless $lx =~ / l=\"et\">(.+?)</; # kui eestikeelne plk puudub, ei tee ka
	$sonastikunimed{$id} = $1;
    }
}

sub salvestaankeet {
    my $append = (-e "$pwdir/ankeedid.txt" ? '>' : '');
    open (F, ">$append$pwdir/ankeedid.txt");
    binmode (F, ":utf8");
    print F $guid . "\t" . $q->param('parisnimi') . "\t" . $q->param('meil') . "\t" . $q->param('parool1') . "\n";
    close (F);
    &meiliteade;
    print '<script language="javascript" type="text/javascript"> window.setTimeout("window.location=\'../\';", 6000); </script>', "\n";
}

sub jubaonsellineankeet {
    open (F, "<$pwdir/ankeedid.txt");
    while (<F>) {
	my ($guid, $pn, $mm, $pw) = split (/\t/, $_);
	return 1 if (
	    ($pn eq $q->param('parisnimi')) and
	    ($mm eq $q->param('meil')) and
	    ($pw eq $q->param('parool1'))
	);
    }
    close (F);
    return 0;
}

sub meiliteade {
    my $srnimi = $q->param('sr');
    $srnimi = $sonastikunimed{$srnimi};
    open  (M, "|/usr/sbin/sendmail -t") or die ('Viga meili saatmisel');
    print (M "To: eelex.admin\@eki.ee\n");
    print (M "From: eelex.admin\@eki.ee\n");
    print (M "Subject: EELEX: uus kasutaja vajab lisamist\n");
    print (M "Content-type: text/plain\n\n");
    print (M "Kasutaja " . $q->param('parisnimi') . " soovis saada EELexi kasutajaks ja\n");
    print (M "mainis oma seotust sonastikuga $srnimi.\n");
    print (M "Keda see teade puudutab, palun ajage asi jonksu.\n");
    print (M "Link on http://eelextest.eki.ee/shs_access/halda.cgi\n");
    close (M);
}

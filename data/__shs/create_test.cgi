#!/usr/bin/perl

use strict;
use utf8;
use Encode;
use XML::LibXML;
use CGI;
use DBI;

require '/var/www/EELex/shs_config/shs_config.ini';
our ($mysql_ip, $mysql_user, $mysql_pass);

my $inputfrom = ('file', 'cgi', 'mysql')[1];
my $V = '[aeiouäöü]';
my $silu = 0;
my $basedir = '';
my $q = new CGI;

my $dicparser = XML::LibXML->new();
$dicparser->validation(0);
$dicparser->recover(0);
$dicparser->expand_entities(1);
$dicparser->keep_blanks(1);
$dicparser->pedantic_parser(0);
$dicparser->line_numbers(0);
$dicparser->load_ext_dtd(0);
$dicparser->complete_attributes(0);
$dicparser->expand_xinclude(0);
$dicparser->clean_namespaces(1);

if ($silu) {
    open (F, "<xmlarts");
    binmode (F, ":utf8");
    open (O, ">eesliited.txt");
    binmode (O, ":utf8");
    while (<F>) {
	chomp;
	while ( /:liik=\"el\"[^<>]*>(.*?)\-</ ) { print O "$1\n"; $_ = $'; };
    }
    close (O);
    close (F);
}

my $art = '';
if ($inputfrom eq 'cgi') {
    my ($dictid, $art) = split(/\x{e001}/, decode_utf8($q->param('POSTDATA')));
    print "Content-type: text/plain; charset=utf-8\n\n";
    uusmorf ($art);
}
elsif ($inputfrom eq 'mysql') {
    my $lexdbh = DBI->connect("DBI:mysql:database=xml_dicts;host=${mysql_ip}",$mysql_user, $mysql_pass, {'RaiseError' => 1});
    $lexdbh->do ("SET NAMES utf8");
    $lexdbh->{'mysql_enable_utf8'} = 1;
    $q = "SELECT art, G FROM vsl WHERE vol_nr > 0 LIMIT 3";
    my $lexsth = $lexdbh->prepare($q);
    $lexsth->execute();
    while ( my ($art, $gg) = $lexsth->fetchrow_array() ) {
	uusmorf($art);
    }
}
else {
    open (F, "<xmlarts");
    binmode (F, ":utf8");
    for (1..1000) {
	$art = (<F>);
	chomp ($art);
	uusmorf ($art);
    }
    close F;
}

exit;

sub uusmorf {
    my $art = shift;
    $art = "<z:sr xmlns:z='http://www.eki.ee/dict/vsl'>" . $art . "</z:sr>";
#print "SISSE: $art\n\n";
    my $doc = $dicparser->parse_string($art);
    my $mf;

    # vajame seda koigi mg-de jaoks eraldi, alkomeeter alkoholomeeter, 
    foreach my $mgnode ( $doc->documentElement()->findnodes('.//z:mg') ) {
	# mitmuslik
#	if ($doc->documentElement()->findvalue('.//z:vk') =~ /^plt?$/) {
	if ($mgnode->findvalue('.//z:vk') =~ /^plt?$/) {
	    $mf = $mgnode->findvalue('.//z:mvg[@z:vn="SgG"]/z:mvgp/z:mv[1]');
	    $mf = $mgnode->findvalue('.//z:mvg[@z:vn="SgN"]/z:mvgp/z:mv[1]') unless $mf;
	    $mf .= '[d' if $mf;
	}
	else {
	    $mf = $mgnode->findvalue('.//z:mvg[@z:vn="SgN" or @z:vn="Sup" or @z:vn="ID"][1]/z:mvgp/z:mv[1]');
	}

	if ($mgnode->findvalue('.//z:mfp[@z:kl="ls"]')) {
	    my $m = $mgnode->findvalue('.//z:m');
	    $m =~ s/[\']//g;
	    my $mfpuhas = $mf;
	    $mfpuhas =~ s/[\'\[\`]//g; #`
	    print "ERR: liitsona tagumine ots ($m) ei ole sama mis <mf> ($mfpuhas)!\n" unless ($m =~ /(.+?)$mfpuhas$/);
	    my $esiots = $1;
	    $esiots = '' if $esiots eq '-';
	    $esiots = liitsonaanalyys ($esiots);
	    $esiots = valtesta ($esiots);
	    $mf = $esiots . '+' . $mf;
	}
	print "$mf";
    }
}

sub liitsonaanalyys {
    use LWP::Simple;
    my $sona = shift;
    my $ana = get "http://morf.eki.ee/ana.cgi?sone=${sona}trikk&m=1";
#    print "ANAAL: $ana\n";
    if ($ana =~ / >([^ ]+)\+trikk /) { return $1; }
    return $sona;
}

my @eesliited = qw(
a
an
ab
abs
ad
aero
afro
agraar
agro
akro
akr
aktino
akva
al
el
l
allo
amfi
amino
amülo
amül
an
ana
an
anaal
analoog
andro
andr
anemo
angio
anglo
ant
ante
anti
ant
antropo
api
apo
ap
arheo
arhe
arhi
aso
asoto
astro
azo
ato
audio
auto
avio
balneo
baro
barü
bi
biblio
bio
blanko
brahhü
bronhiaal
con
contre
de
deka
demi
dendro
dermato
des
detsi
detsimaal
di
dia
digi
dis
dünamo
düs
e
e
ek
eks
eksa
ekso
ekspress
ekstra
ekvi
elektro
elektron
emeriit
en
endo
entero
ento
entomo
epi
erütro
etno
eu
euro
eurü
farmako
farüngo
femto
ferri
ferro
fibro
filo
fil
finants
finiit
fono
foto
füto
galakto
galvano
gastro
generaal
genitaal
geo
geronto
giga
glük
glüko
glüka
glük
grafo
gün
güne
güneko
güne
güneko
güro
heks
heksa
hekto
helio
hem
hemat
hemato
hemi
hemo
hemato
hem
hemat
hepta
hetero
hiero
hipo
histo
holo
homo
homöo
humanitaar
hüdro
hüdr
hügro
hüper
hüpo
hüpso
hüstero
iatro
ideo
idio
ihtüo
ihtü
il
im
immuno
immuun
in
il
im
ir
indo
infra
inter
intra
intro
ir
iso
kako
kammer
karbo
karbon
kardio
karto
karüo
kata
kefalo
kemo
kennel
kilo
kindral
kiro
klor
kloro
klor
ko
kom
kor
kom
kommerts
kon
kontr
kontra
kopro
kosmo
kranio
kriminaal
kriminaal
krom
kromato
kromo
kromato
krom
kron
krono
kron
krüo
krüpto
krüso
ksanto
kseno
ksero
ksülo
kvaasi
lakto
larüngo
leib
lepto
leuko
lipo
lito
lüs
lüsi
lüso
maha
makro
mega
megalo
mehhano
mela
melo
mero
meso
meta
metallo
meteoro
meteo
mikro
milli
mini
miso
mnemo
molekulaar
molekulaar
mono
morf
morfo
morf
moto
multi
müelo
müko
mükso
müo
nano
narko
naso
nefro
nekro
neo
neur
neuri
neuro
neuri
neuro
nitro
non
nor
normaal
nukleo
nukle
nukl
odonto
okta
okto
oligo
ombro
oo
ovo
oraal
organo
ornito
oro
orto
osteo
oste
oto
paleo
pan
para
par
pato
peda
pedo
peda
penta
pent
per
perfo
peri
peta
petro
pieso
piko
pleo
plei
pneumo
polaar
polari
polaro
polaro
polü
pop
post
prae
pre
premiaal
pro
proto
pseudo
psühho
pter
ptero
ptero
püo
püro
pür
rabdo
radio
re
reaal
reproduktiiv
retro
rino
riso
ris
rodo
roll-on
rota
russo
sapro
seismo
semi
senti
sfero
sidero
sono
son
sotsio
spektro
spektr
steno
stereo
strati
strato
sub
super
supra
sül
süm
sün
sül
süm
sünkroon
zepto
zetta
zoo
tanato
tanat
tehno
tele
tera
termo
tetra
tigmo
tio
toko
toksiko
toksik
tokso
toks
topo
trans
tri
tropo
tsis
tsiviil
tsüto
turbo
tüpo
türeo
ultra
uni
uro
velo
vibro
video
viitse
öko
xero
yocto
yotta
);

sub valtesta {
    use LWP::Simple;
    my $sona = shift;
    return '' unless $sona;
    if ($sona =~ /\+/) { return valtesta($`) . '+' . valtesta($'); }
    foreach (@eesliited) { return "$sona" if $_ eq $sona; }

    my $ana = get "http://morf.eki.ee/ana.cgi?sone=${sona}";
    if ( $ana =~ /<valde>(.*)<\/valde>/ ) {
#	print "ANAAL: $&\n";
	# valtetuvastus annab tyhja kui see tema meelest ei saa sona olla
	$sona = $1 if $1;
	$sona = $` if $sona =~ / /;
    }
    return $sona;
}


1;

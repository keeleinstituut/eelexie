#!/usr/bin/perl

use strict;
use utf8;
use Encode;
use XML::LibXML;
use CGI;
use DBI;

require '/www/shs_config/shs_config.ini';
our ($mysql_ip, $mysql_user, $mysql_pass);

my $inputfrom = ('file', 'cgi', 'mysql')[1];
my $V = '[aeiouäöü]';

my @eesliited = qw(
a
an
ab
a
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

my @omastavad = qw(
ab`ordi
abs`indi
absts`essi
absts`issi
abs`urdi
abt`issi
adj`unkti
adv`endi
adv`erbi
af`ekti
af`iši
ag`endi
aim`aki
ak`ordi
aktr`issi
akts`endi
akts`epti
ak`õnni
al`armi
alr`auni
alt`õnni
al`undi
am`oki
am`ordi
amp`ulli
angl`isti
ant`enni
antr`akti
ap`aši
ap`atši
ap`elli
apl`ausi
apl`ombi
apr`eti
apr`illi
ar`api
ard`enni
ar`esti
arh`ondi
art`elli
art`isti
ar`õki
asb`esti
asp`ekti
astr`oidi
at`aki
atl`andi
at`olli
av`ansi
bakh`andi
bal`ansi
ball`asti
ball`eti
ball`isti
bal`õki
bank`eti
bapt`ismi
bapt`isti
bar`aki
bar`eti
bar`oki
bas`aldi
bask`aki
bass`eini
bass`isti
bat`isti
bats`illi
bat`õrri
bek`arri
bel`utši
bem`olli
ber`ülli
bešm`eti
bil`ansi
biv`aki
blank`eti
boik`oti
bomb`ardi
bord`elli
borž`ommi
brel`oki
brik`eti
brilj`andi
brün`eti
bud`ismi
bud`isti
buk`eti
burdj`uki
burg`undi
burl`aki
burl`eski
bušl`ati
büdž`eti
dam`aski
dam`asti
dar`eigi
deb`ati
def`ekti
dek`okti
del`ikti
dem`arši
dent`isti
dep`eši
dess`andi
dess`erdi
det`aili
diad`ohhi
diagr`ammi
dial`ekti
did`akti
dift`ongi
dis`aini
dis`aini
diskl`ahvi
disk`ursi
disp`aši
disp`etši
dist`antsi
distr`ikti
drog`isti
džig`iti
džins`engi
dual`ismi
dual`isti
dubl`andi
dubl`eti
duell`andi
dug`ongi
düstr`essi
ed`ikti
ef`ekti
eksk`ursi
ekspr`ompti
ekst`erni
ekstr`akti
eksts`erpti
eksts`essi
em`aili
em`aili
ep`ohhi
ers`atsi
esk`arbi
esk`ordi
esk`ordi
ess`entsi
est`ambi
et`api
etr`uski
eun`uhhi
eustr`essi
ev`engi
fag`oti
faj`ansi
fal`angi
fals`eti
fan`ati
fant`asti
fass`ongi
faš`ismi
faš`isti
faun`isti
fel`uki
fenn`ismi
ferm`endi
fibr`illi
fin`antsi
fin`essi
flan`elli
flor`eti
flot`illi
flöt`isti
for`elli
form`andi
fragm`endi
freg`ati
frekv`entsi
freud`ismi
freud`isti
fug`assi
gal`opi
gar`andi
gas`elli
gav`oti
ger`ondi
ger`undi
gig`andi
gilj`oši
girl`andi
grets`ismi
grets`isti
grim`assi
gris`eti
grot`eski
gulj`aši
haid`uki
hak`assi
hal`ati
harf`isti
has`ardi
helm`indi
hib`iski
hol`opi
hop`aki
hot`elli
hüats`indi
hüdr`andi
id`endi
id`ülli
il`angi
in`ertsi
inf`andi
inf`arkti
ing`uši
ins`ekti
inst`alli
inst`antsi
inst`inkti
ins`uldi
int`erni
jarl`õki
jur`isti
kab`ardi
kad`entsi
kad`eti
kadr`illi
kaj`aki
kal`atši
kal`essi
kalm`õki
kal`ossi
kal`õmmi
kam`assi
kaml`oti
kap`elli
kap`oti
karb`assi
karb`ussi
kark`assi
kar`oti
kart`elli
kart`etši
kart`ongi
kart`uši
kas`ahhi
kass`eti
kast`elli
kat`arri
kat`astri
kav`erni
kem`ismi
ken`afi
kent`auri
kinž`alli
kir`urgi
kiss`elli
kišl`aki
kit`arri
klos`eti
koh`ordi
kok`ardi
kok`eti
kok`illi
kok`oti
koll`oidi
kol`onni
kol`ossi
kol`umni
komb`aini
komf`ordi
komm`ersi
komm`ertsi
komp`aundi
kompl`ekti
kompl`oti
komp`osti
komp`oti
komp`unni
koms`orgi
komt`essi
konf`eti
konfl`ikti
kons`ervi
konsp`ekti
kont`akti
kontr`asti
kontr`olli
konts`epti
konts`erni
konv`endi
kor`alli
kor`indi
korj`aki
kors`eti
kor`undi
korv`eti
kot`urni
krav`ati
kret`ongi
krev`eti
krist`alli
kroml`ehhi
kub`ismi
kub`isti
kul`issi
kul`itši
kum`õki
kum`õssi
kup`elli
kup`ongi
kurs`andi
kusk`ussi
kuš`eti
kuuend`iku
kvadr`andi
kvart`eti
kviet`ismi
kviet`isti
kvint`eti
kün`ismi
küpr`essi
kür`assi
küv`eti
laf`eti
lam`elli
lam`endi
lamp`assi
lang`eti
lang`usti
lants`eti
lav`aši
leg`endi
lib`elli
lingv`isti
linkr`usti
lit`auri
lits`entsi
lok`audi
loll`ardi
lomb`ardi
lornj`eti
lun`oidi
lür`ismi
mahh`ismi
mahh`isti
mak`eti
makr`elli
mandr`illi
mang`usti
mans`ardi
mans`eti
mant`issi
mar`asmi
marks`ismi
marks`isti
marr`ismi
mask`oti
mel`anži
mel`assi
mel`issi
merl`angi
met`alli
met`issi
metr`essi
metr`isti
migr`andi
mod`elli
mod`erni
mod`isti
mom`endi
mon`arhi
mon`ismi
mon`isti
monstr`antsi
morf`ismi
mor`iski
mot`elli
mot`eti
mul`ati
must`angi
mut`andi
müok`ardi
müs`eti
naiv`ismi
nap`almi
nark`otsi
narts`issi
nats`ismi
neiul`iku
nobl`essi
nok`audi
nokd`auni
nokt`urni
nom`arhi
norm`anni
nov`elli
nud`ismi
nud`isti
nõial`iku
nüst`agmi
obj`ekti
of`ordi
ofs`aidi
okt`eti
oml`eti
opt`andi
or`anži
org`asmi
pak`eti
pal`eti
pamfl`eti
park`eti
parn`assi
part`orgi
parts`elli
pasj`ansi
paskv`illi
past`elli
past`illi
past`iši
pat`endi
patr`ulli
patš`oki
ped`andi
ped`elli
pek`eši
perf`ekti
perv`erdi
pet`angi
pian`isti
piet`ismi
piet`isti
pigm`endi
pik`andi
pik`eti
pil`afi
pints`eti
pip`eti
pist`ongi
planš`eti
pleon`asmi
pod`esti
poet`essi
pogr`ommi
pohm`elli
poj`engi
pot`entsi
pref`ekti
prepr`indi
pres`endi
pres`ervi
prints`essi
prod`ukti
progr`ammi
progr`essi
proj`ekti
prol`apsi
prom`illi
prosp`ekti
prot`esti
prot`isti
prots`essi
proual`iku
prov`intsi
prud`entsi
puiest`iku
puj`engi
pup`illi
pur`ismi
pur`isti
rab`ati
rad`isti
raiesm`iku
raiest`iku
rak`eti
rak`ursi
rap`ordi
rass`ismi
rass`isti
real`ismi
real`isti
refl`eksi
ref`ormi
reg`ati
reg`endi
regr`essi
rel`apsi
rel`ikti
rem`argi
rem`ondi
ren`eti
repr`indi
res`ervi
resp`ekti
ress`ursi
ret`ordi
rets`epti
ret`uši
rev`anši
rev`oldi
rom`ansi
ros`eti
rot`undi
rul`eti
russ`ismi
russ`isti
sad`ismi
sad`isti
sak`ummi
sal`ongi
sard`elli
sark`asmi
sav`anni
segm`endi
seks`ismi
sekst`andi
sekst`eti
sekt`andi
sekv`entsi
sekv`estri
seldž`uki
sent`entsi
sept`eti
ser`aili
servj`eti
siam`angi
sib`ülli
sion`ismi
sion`isti
skalp`elli
skel`eti
slav`ismi
slav`isti
slov`aki
smar`agdi
snob`ismi
sof`ismi
sof`isti
sol`isti
solv`endi
son`andi
son`eti
spag`eti
spin`eti
spir`andi
stagn`andi
stand`ardi
stat`isti
ster`oidi
stil`eti
stil`isti
stjuard`essi
stoits`ismi
strel`etsi
subj`ekti
subr`eti
subst`antsi
suf`ismi
sum`ahhi
sup`ordi
sün`apsi
šaf`oti
šam`oti
šašl`õki
šen`illi
ševr`eti
šimp`ansi
šrapn`elli
žem`aidi
ženš`enni
žil`eti
žir`afi
žir`andi
žorž`eti
tabl`eti
tabl`eti
tabl`oidi
tadž`iki
tal`endi
tal`ongi
tal`õši
tamt`ammi
tank`eti
tank`isti
tar`oki
tart`üfi
tav`erni
tav`oti
tend`entsi
terr`assi
terts`eti
tetr`arhi
tom`ismi
tons`illi
trag`ismi
trep`aki
trep`angi
tribr`ahhi
trift`ongi
tripl`eti
trop`ismi
trotsk`ismi
trotsk`isti
tsar`ismi
tsem`endi
tsentr`ismi
tsentr`isti
tsist`erni
tšart`ismi
tšart`isti
tšek`isti
tšell`isti
tšerk`essi
tšuv`aši
tual`eti
tur`ismi
tur`isti
täiel`iku
tür`anni
ud`elli
udm`urdi
ugr`isti
ul`ussi
urj`uki
usb`eki
vag`andi
vaiast`iku
vak`antsi
val`ahhi
val`entsi
van`illi
vas`alli
ver`ismi
viad`ukti
viiend`iku
vik`ondi
vinj`eti
viol`eti
vol`angi
);


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

my %ettevalmis = ();
ettevalmista();

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
    $| = 1;
    open (F, "<xmlarts");
    binmode (F, ":utf8");
    binmode (STDOUT, ":utf8");
#    for (1..1000) {
    while ( $art = (<F>) ) {
	chomp ($art);
	uusmorf ($art);
	print "\n";
    }
    close F;
}

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
	if ($mgnode->findvalue('z:vk') =~ /^plt?$/) {
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

sub ettevalmista {
    foreach my $s (@eesliited) {
	$_ = $s;
	s/\`//g; # `
	next if /$V+.+$V+/;	# jatame alles ainult yhesilbilised
	$ettevalmis{$_} = $s;
    }
    foreach my $s (@omastavad) {
	$_ = $s;
	s/\`//g; # `
	$ettevalmis{$_} = $s;
    }
#    foreach (sort keys %ettevalmis) { print "$_\t" . $ettevalmis{$_} . "\n"; }
}

sub valtesta {
    use LWP::Simple;
    my $sona = shift;
    return '' unless $sona;
    if ($sona =~ /\+/) { return valtesta($`) . '+' . valtesta($'); }
    my $s = $sona;
    return $ettevalmis{$s} if $ettevalmis{$s};
    my $s = $sona . 'd';	# mitmus brik`etid
    return $ettevalmis{$s} . 'd' if $ettevalmis{$s};
    my $s = $sona . 'b';	# tema brik`etib
    return $ettevalmis{$s} . 'b' if $ettevalmis{$s};

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

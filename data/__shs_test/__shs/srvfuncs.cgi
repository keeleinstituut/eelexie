#!/usr/bin/perl

# $ENV{PERL_BADFREE} = 0;

use strict;

# Only one case remains where an explicit use utf8 is needed:
# if your Perl script itself is encoded in UTF-8,
# you can use UTF-8 in your identifier names,
# and in string and regular expression literals, by saying use utf8.

use utf8;


# decode_utf8, encode_utf8 ...
use Encode;


# To output UTF-8, use the :utf8 output layer. Prepending
# binmode(STDOUT, ":utf8");
# to this program ensures that the output is completely UTF-8.

# binmode(STDOUT, ":utf8");

my $scriptName = $ENV{SCRIPT_NAME};
#debugimiseks
if (index($scriptName, '/__shs_test/') > -1) {
	# use lib qw( ./shs_lib/ );
	#use SHS_man;
	# use SHS_Carp;
	#$SIG{__WARN__} = \&carp_hwl;
	# $SIG{__DIE__}  = \&carp_hdl;
}

require '/www/shs_config/shs_config.ini';
our ($mysql_ip, $mysql_user, $mysql_pass);


use XML::LibXML;
my $dicparser = XML::LibXML->new();
$dicparser->validation(0);
$dicparser->recover(0);
$dicparser->expand_entities(1);
$dicparser->keep_blanks(0);
$dicparser->pedantic_parser(0);
$dicparser->line_numbers(0);
$dicparser->load_ext_dtd(0);
$dicparser->complete_attributes(0);
$dicparser->expand_xinclude(0);
$dicparser->clean_namespaces(1);


# *****************************************************
# Constants
# *****************************************************

my $lcDom = $dicparser->parse_file('lc.xml');

use CGI;
my $q = new CGI;

# my $pd = decode_utf8($q->param('POSTDATA'));
my $pd = $q->param('POSTDATA');

if ($pd eq '') {
	print "Content-type: text/html; charset=utf-8\n\n"; #header utf-8 -s
	print 'not defined.';
	exit;
}

my $prmDOM = $dicparser->parse_string($pd);

my $APP_LANG = $prmDOM->documentElement()->findvalue('app_lang');
my $DIC_DESC = $prmDOM->documentElement()->findvalue('dic_desc');

my $cmdId = $prmDOM->documentElement()->findvalue('cmd');
my $dicVol = $prmDOM->documentElement()->findvalue('vol'); # "ief1" jne
my $qinfo = $prmDOM->documentElement()->findvalue('nfo');
my $art_xpath = $prmDOM->documentElement()->findvalue('axp');
my $elm_xpath = $prmDOM->documentElement()->findvalue('exp');
my $artG = $prmDOM->documentElement()->findvalue('G');

my $what = $prmDOM->documentElement()->findvalue('w');

my $withCase = $prmDOM->documentElement()->findvalue('wC');
my $withSymbols = $prmDOM->documentElement()->findvalue('wS');
my $evPath = $prmDOM->documentElement()->findvalue('evP');
my $seldQn = $prmDOM->documentElement()->findvalue('qn');
my $seldLn = substr($seldQn, index($seldQn, ':') + 1);
my $seldQn2 = $prmDOM->documentElement()->findvalue('qn2');
my $seldLn2 = substr($seldQn2, index($seldQn2, ':') + 1);

my $sql = $prmDOM->documentElement()->findvalue('sql');

my $fSrchPtrn = $prmDOM->documentElement()->findvalue('fSrP');
# ei saa kõiki sümboleid maha võtta, sest peab saama otsida ka fakultatiivseid osasi märksõnast (tsipake[ne])
my $fSubstPtrn = '&(((em|b|sub|sup|l|cap)(a|l)));'; #ainult kirjastiilid

my $destVol = $prmDOM->documentElement()->findvalue('dV');

my $qryMethod = $prmDOM->documentElement()->findvalue('qM');
my $artMuudatused = $prmDOM->documentElement()->findvalue('artCh');
my $pQrySql = $prmDOM->documentElement()->findvalue('pQrySql');

my $artHasHtml = $prmDOM->documentElement()->findvalue('hasHtml');
my $artHtml;
my $artHtmlNodes = $prmDOM->documentElement()->findnodes('html');
if ($artHtmlNodes->size() == 1) {
	my $artHtmlTextNode = $artHtmlNodes->get_node(1)->firstChild;
	if ($artHtmlTextNode) {
		$artHtml = $artHtmlTextNode->toString;
	}
}
my $artBrVer = $prmDOM->documentElement()->findvalue('brVer');


my $shsconfig = $dicparser->parse_file("shsconfig_${DIC_DESC}.xml");
my $appDesc = $shsconfig->documentElement()->findvalue('appDesc');
my $MAX_LEIUD = $shsconfig->documentElement()->findvalue('max_leiud');
my $MAX_PRINT_ARTS = $shsconfig->documentElement()->findvalue('max_print_arts');
my $DIC_VOLS_COUNT = $shsconfig->documentElement()->findnodes('vols/vol')->size();
my $DICPR = $shsconfig->documentElement()->findvalue('dicpr');
my $DICURI = $shsconfig->documentElement()->findvalue('dicuri');

my $rootLang = $shsconfig->documentElement()->findvalue('rootLang');
unless ($rootLang) {
	$rootLang = 'et';
}

my $msLang = $shsconfig->documentElement()->findvalue('msLang');
my $msAlpha = $shsconfig->documentElement()->findvalue('msAlpha');
unless ($msAlpha) {
	$msAlpha = "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsŠšZzŽžTtUuVvWwÕõÄäÖöÜüXxYy";
}
my $msTranslSrc = $shsconfig->documentElement()->findvalue('msTranslSrc');
my $msTranslDst = $shsconfig->documentElement()->findvalue('msTranslDst');

my $sortType = $shsconfig->documentElement()->findvalue('sortType');
unless ($sortType) {
	$sortType = "text";
}


#'noLetters' sobib sel kujul 'textContent' jaoks: '&amp;' asemel on '&'
# my $noLetters = qr/&((em|b|sub|sup|l)(a|l));|[^\p{L}\s]/;
my $noLetters = qr/(&\w+;)|[^${msAlpha}\s]/;
my $hlPtrn = $prmDOM->documentElement()->findvalue('hlP');

my $fakPtrn = $prmDOM->documentElement()->findvalue('pFakPtrn');

if ($withCase eq '0') { # tõstutundetu
	unless ($fSrchPtrn eq '') {
		$fSrchPtrn = '(?i)' . $fSrchPtrn;
		$hlPtrn = '(?i)' . $hlPtrn;
	}
}
my $isPtrn = 0;
unless ($fSrchPtrn eq '') {
	$fSubstPtrn = qr/$fSubstPtrn/;
	$fSrchPtrn = qr/$fSrchPtrn/;
	$hlPtrn = qr/$hlPtrn/;
	$isPtrn = 1;
}
my $fMySQLPtrn = $prmDOM->documentElement()->findvalue('fMsqlP');

my $FIRST_DEFAULT = $shsconfig->documentElement()->findvalue('first_default'); # algab <A> - st
my $fdArt = substr($FIRST_DEFAULT, index($FIRST_DEFAULT, '/') + 1);
my $DEFAULT_QUERY = $shsconfig->documentElement()->findvalue('default_query'); # algab <A> - st
my $dqArt = substr($DEFAULT_QUERY, index($DEFAULT_QUERY, '/') + 1);
my $qn_ms = substr($DEFAULT_QUERY, rindex($DEFAULT_QUERY, '/') + 1);

my $fakOlemas = $shsconfig->documentElement()->findvalue('fakult');
my $fakOsataPtrn;
if ($fakOlemas) {
	$fakOsataPtrn = '\\' . substr($fakOlemas, 0, 1) . '.*?\\' . substr($fakOlemas, 1, 1);
	$fakOsataPtrn = qr/$fakOsataPtrn/;
}
my $mySqlDataVer = $shsconfig->documentElement()->findvalue('mySqlDataVer');
my $mustBeUnique = $shsconfig->documentElement()->findvalue('mustBeUnique');
if ($mustBeUnique eq '') {
	$mustBeUnique = 1;
}
elsif ($mustBeUnique eq "false") {
	$mustBeUnique = 0;
}


my ($usrName, $nEditAllowed);
$nEditAllowed = 0;
if ($appDesc eq 'EXSA') {
	$usrName = $prmDOM->documentElement()->findvalue('un');
	$nEditAllowed = 1;
}
else {
	$usrName = "$ENV{REMOTE_USER}";
	unless ($usrName eq "vaataja" || $usrName eq "h6beValge" || $usrName eq "xmlStats") {
		$nEditAllowed = 1;
	}
}
if ($usrName eq "") {
	print "Content-type: text/html; charset=utf-8\n\n"; #header utf-8 -s
	print 'not defined.';
	exit;
}

my $usrUnName = "";
for (my $uJnr = 0; $uJnr < length($usrName); $uJnr++) {
	if ($uJnr > 0) {
		$usrUnName .= "_"
	}
	$usrUnName .= ord(substr($usrName, $uJnr, 1));
}

# Viimane parameeter - 0 - määrab, et ainult NS deklaratsioon kirjutatakse.
# Kui 'setNamespace' mitte panna, tuleb viga prmDOM otsingul: undefined prefix jne.
$prmDOM->documentElement()->setNamespace($DICURI, $DICPR, 0);

my $remoteAddress = $ENV{REMOTE_ADDR};


my $queryFileID = "${usrUnName}_${DIC_DESC}";

my $dbh;

# *****************************************************
# Functions
# *****************************************************

sub nrEtSepr {
local $_ = shift;
1 while s/^([-+]?\d+)(\d{3})/$1 $2/;
return $_;
}

# NB! : ka tools.cgi
sub t6lgi {
	my $sisend = shift(@_);
	$sisend =~ s/Æ/AE/g;
	$sisend =~ s/æ/ae/g;
	$sisend =~ s/Ĳ/IJ/g;
	$sisend =~ s/ĳ/ij/g;
	$sisend =~ s/Œ/OE/g;
	$sisend =~ s/œ/oe/g;
	$sisend =~ s/Ǆ/DŽ/g;
	$sisend =~ s/ǅ/Dž/g;
	$sisend =~ s/ǆ/dž/g;
	$sisend =~ s/Ǉ/LJ/g;
	$sisend =~ s/ǈ/Lj/g;
	$sisend =~ s/ǉ/lj/g;
	$sisend =~ s/Ǌ/NJ/g;
	$sisend =~ s/ǋ/Nj/g;
	$sisend =~ s/ǌ/nj/g;
	$sisend =~ s/Ǣ/AE/g;
	$sisend =~ s/ǣ/ae/g;
	$sisend =~ s/Ǳ/DZ/g;
	$sisend =~ s/ǲ/Dz/g;
	$sisend =~ s/ǳ/dz/g;
	$sisend =~ s/Ǽ/AE/g;
	$sisend =~ s/ǽ/ae/g;
	my $v2ljund = "";
	if ($msTranslSrc) {
		for (my $ix = 0; $ix < length($sisend); $ix++) {
			my $tTaht = substr($sisend, $ix, 1);
			my $tIndeks = index($msTranslSrc, $tTaht);
			if ($tIndeks > -1) {
				if ($tIndeks < length($msTranslDst)) {
					$v2ljund .= substr($msTranslDst, $tIndeks, 1);
				}
				# kui 'Src' on pikem kui 'Dst', siis 'tTaht' kustub
			}
			else {
				$v2ljund .= $tTaht;
			}
		}
	}
	else {
		$v2ljund = $sisend;
	}
	return $v2ljund;
}

# NB! : ka tools.cgi
sub teeMs_nosKuju {
	my $ms_nos = shift(@_);
	$ms_nos =~ s/&amp;/&/g; #kuna 'mTekstid' on 'toString', siis on '&amp;ema;' jne
	$ms_nos = t6lgi($ms_nos);
	$ms_nos =~ s/$noLetters//g;
	return $ms_nos;
}

# tavalise XML päringu juures
sub srch {
	my $nodeList = shift(@_);

	# findvalue is exactly equivalent to:
	#	$node->find( $xpath )->to_literal;

	#textContent (Node): this function returns the content of all text nodes in the descendants of the given node as specified in DOM.
	#to_literal (NodeList): Returns the concatenation of all the string-values of all the nodes in the list. This could be used as the equivalent of XSLT's <xsl:value-of select="some_xpath"/>.
	#string_value (NodeList): Returns the string-value of the first node in the list. See the XPath specification for what "string-value" means.
	#toString (Node): It returns a string consisting of XML serialization of the given node and all its descendants ("outerXml", "xml")

	my ($i, $nodeText);
	for ($i = 1; $i <= $nodeList->size(); $i++) {
	
		# kas element (self::node() korral) või tekst (text())
		# textContent: '&amp;' -> '&'
		$nodeText = $nodeList->get_node($i)->textContent;
		
		if ($withSymbols < 1) {
			$nodeText = t6lgi($nodeText);
			if ($fakPtrn) {
				my $fakOsata = $nodeText;
				$fakOsata =~ s/$fakOsataPtrn//g; #sulud ja tema sees olev maha
				$fakOsata =~ s/$noLetters//g;
				if ($fakOsata =~ /$fSrchPtrn/) {
					return 1;
				}
			}
			$nodeText =~ s/$noLetters//g;
		}
		if ($nodeText =~ /$fSrchPtrn/) {
			return 1;
		}
	}
	return 0;
}

# Word väljatrüki XML moodusel, märksõnast märksõnani
sub compMs {
	my $nodeList = shift(@_);
	my $ms1 = decode_utf8(shift(@_));
	my $ms2 = decode_utf8(shift(@_));

	my ($i, $nodeText);
	for ($i = 1; $i <= $nodeList->size(); $i++) {
	
		my $thisNode = $nodeList->get_node($i);

		$nodeText = $thisNode->textContent;
		if ($thisNode->localname eq 'm') { # et saaks ka nt <KL> korral kasutada
			$nodeText = t6lgi($nodeText);
			$nodeText =~ s/$noLetters//g;
			if ($DIC_DESC ne 'evs') {
				$nodeText =~ s/\s//g;
			}
			$nodeText = lc($nodeText);
		}

		# ge, le ei tööta eesti tähestiku puhul ...
		# if ($nodeText ge $ms1 && $nodeText le $ms2) {
		#	return 1;
		# }

		if ((compByLetter($nodeText, $ms1) >= 0) && (compByLetter($nodeText, $ms2) <= 0)) {
			return 1;
		}
	}
	return 0;
}


sub compByLetter {
	my $tekst1 = shift(@_);
	my $tekst2 = shift(@_);

	my $ixCh = 0;
	while (1) {
		if (($ixCh == length($tekst1)) && ($ixCh == length($tekst2))) {
			return 0;
		}
		if ($ixCh == length($tekst1)) {
			return -1;
		}
		if ($ixCh == length($tekst2)) {
			return 1;
		}
		if (index($msAlpha, substr($tekst1, $ixCh, 1)) < index($msAlpha, substr($tekst2, $ixCh, 1))) {
			return -1;
		}
		if (index($msAlpha, substr($tekst1, $ixCh, 1)) > index($msAlpha, substr($tekst2, $ixCh, 1))) {
			return 1;
		}
		$ixCh++;
	}
}


# tavalise XML päringu juures
sub showHL {

	# siia tuleb sisse tekst nood (text()) ...
	
	# textContent: '&amp;' -> '&'
	# textContent: krahvitar, &ema;&la;count&ll;&eml;’i abikaasa v tütar
	# toString: krahvitar, &amp;ema;&amp;la;count&amp;ll;&amp;eml;’i abikaasa v tütar
	# peab jätma "toString", sest on ainuke, mis ei moonuta
	my $tekst = shift(@_)->get_node(1)->textContent;
	if ($isPtrn) {
		if ($withSymbols < 1) {
			# ainult kirjastiilid maha
			$tekst =~ s/$fSubstPtrn//g;
		}
		$tekst =~ s/($fSrchPtrn)/<span class='_hl'>$1<\/span>/g;
	}
	return $tekst;
}

# eraldi otsingufunktsioon, nt atribuudi teksti juures XML tavapäringus
sub srch2 {
	my $attText = shift(@_)->to_literal();
	my $attPtrn = decode_utf8(shift(@_));
	my $attSubst = shift(@_);

	if ($attSubst) {
		$attText =~ s/$attSubst//g;
	}
	if ($attText =~ /$attPtrn/) {
		return 1;
	}

	return 0;

}


my ($viimane_vol_nr, $viimaneArt, $artsCount);

sub teeXMLStr {

	my ($leiuTekst, $leiuTekstOrg, $md, $KL, $TA, $TL, $PTA, $viimaneG, $g, $artLeiuNr);
	my $className = '_bhl';
	my $artsXML = '';

	$artsCount = 0;
	$artLeiuNr = 0;
	$viimaneG = '';

	my $stHandle = shift(@_);
	my $lisand = decode_utf8(shift(@_));
	while (my $ref = $stHandle->fetchrow_hashref()) {

		$leiuTekst = decode_utf8($ref->{'l'});
		$leiuTekstOrg = $leiuTekst;

#		unless ($leiuTekstOrg =~ /&/) {
#			if ($isPtrn) {
#				$leiuTekstOrg =~ s/($hlPtrn)/<span class='${className}'>$1<\/span>/g;
#			}
#		}

		$g = $ref->{'G'};
		if ($g ne $viimaneG) {

			if ($artsCount < $MAX_PRINT_ARTS) {

				$artsCount++;

				if ($viimaneG && $artsXML) {
					$artsXML .= '</t></l></A>';
				}

				$artsXML .= '<A>';

				$viimaneArt = decode_utf8($ref->{'art'});
				$viimane_vol_nr = $ref->{'vol_nr'};

				$artsXML .= "<vf>${DIC_DESC}${viimane_vol_nr}</vf>";
				my $tc = $viimaneArt; # tc - textContent
				$tc =~ s/(<[^>]+>|<\/[\w:]+>)//g;
				$artsXML .= "<s>" . (int(length($tc)/1024) + 1) . "</s>";
				$md = decode_utf8($ref->{'md'});

				$artsXML .= "<md>";
				if ($mySqlDataVer eq '2') {
					my $mSqlCmd = "SELECT elemendid_${DIC_DESC}.val AS m, elemendid_${DIC_DESC}.elG AS elG FROM elemendid_${DIC_DESC} WHERE (elemendid_${DIC_DESC}.G = '${g}' AND (elemendid_${DIC_DESC}.nimi = BINARY '${qn_ms}'))";
					my $sth_m = $dbh->prepare($mSqlCmd);
					my $mdStr = '';
					$sth_m->execute();
					while (my $ref_m = $sth_m->fetchrow_hashref()) {
						if ($mdStr) {
							$mdStr .= ' :: ';
						}
						$mdStr .= decode_utf8($ref_m->{'m'});
						my $mdAttSqlCmd = "SELECT atribuudid_${DIC_DESC}.val AS attVal, atribuudid_${DIC_DESC}.nimi AS attNimi FROM atribuudid_${DIC_DESC} WHERE (atribuudid_${DIC_DESC}.elG = '" . $ref_m->{'elG'} . "')";
						my $sth_mdAtt = $dbh->prepare($mdAttSqlCmd);
						my $mdAttStr = '';
						$sth_mdAtt->execute();
						if ($sth_mdAtt->rows > 0) {
							while (my $ref_mdAtt = $sth_mdAtt->fetchrow_hashref()) {
								my $mdAttNimi = $ref_mdAtt->{'attNimi'};
								$mdAttNimi = substr($mdAttNimi, index($mdAttNimi, ':') + 1);
								if ($mdAttNimi eq 'i' || $mdAttNimi eq 'u') {
									unless ($mdAttStr) {
										$mdAttStr .= ' ';
									}
									my $mdAttVal = decode_utf8($ref_mdAtt->{'attVal'});
									$mdAttStr .= "[▫${mdAttNimi}=\"${mdAttVal}\"]";
								}
							}
						}
						$mdStr .= $mdAttStr;
					}
					$artsXML .= "<t>${mdStr}</t>";
				} else {
					$artsXML .= "<t>${md}</t>";
				}
				$artsXML .= "</md>";

				my @emmid = split(/ :: /, $md);
				# for ($i = 0; $i < scalar(@xmlFiles); $i++)
				my $msNosTing = "";
				foreach my $emm (@emmid) {
					if ($msNosTing) {
						$msNosTing .= " OR ";
					}
					my $m1 = teeMs_nosKuju($emm);
					$msNosTing .= "msid.ms_nos = BINARY '${m1}'";
				}
				unless ($msNosTing) {
					$msNosTing .= "msid.ms_nos = BINARY ''";
				}
				my $ddStr = '';

				# if ($DIC_DESC eq 'xxx') {
				#	goto ilma;
				# }

				my $m1SqlCmd = "SELECT DISTINCT msid.dic_code AS dd FROM msid WHERE ((${msNosTing}) AND msid.dic_code != '${DIC_DESC}' AND msid.vol_nr > 0) ORDER BY msid.dic_code";
				my $sth_m1 = $dbh->prepare($m1SqlCmd);

				# eval { $sth_m1->execute() };
				# if ($@) {
				#	my $valErr = decode_utf8($@);
				#	$valErr =~ s/\s+/ /g; # veateates võib olla reavahetusi, mis logifaili p...e keerab
				#	open(INFO, '>:utf8', "temp/vals.txt");
				#	print(INFO "${valErr}\n");
				#	print(INFO "${m1SqlCmd}\n");
				#	close(INFO);
				#	$artsXML .= "<l><t>";
				#	last;
				# }

				$sth_m1->execute();
				while (my $ref_m1 = $sth_m1->fetchrow_hashref()) {
					if ($ddStr) {
						$ddStr .= ', ';
					}
					$ddStr .= "<span class='_xsmall2'>" . $ref_m1->{'dd'} . "</span>";
				}
#				$sth_m1->finish();

ilma:
				$artsXML .= "<ddStr>${ddStr}</ddStr>";

				$artsXML .= '<tlkn></tlkn>';
				$artsXML .= '<maht></maht>';
				$artsXML .= '<K>' . decode_utf8($ref->{'K'}) . '</K>';
				$KL = $ref->{'KL'};
				if ($KL eq '0000-00-00 00:00:00') { #vähem liiklust
					$KL = '';
				}
				$artsXML .= "<KL>${KL}</KL>";
				$artsXML .= '<T>' . decode_utf8($ref->{'T'} . '</T>');
				$TA = $ref->{'TA'};
				if ($TA eq '0000-00-00 00:00:00') { #vähem liiklust
					$TA = '';
				}
				$artsXML .= "<TA>${TA}</TA>";
				$TL = $ref->{'TL'};
				if ($TL eq '0000-00-00 00:00:00') { #vähem liiklust
					$TL = '';
				}
				$artsXML .= "<TL>${TL}</TL>";
				$artsXML .= '<PT>' . decode_utf8($ref->{'PT'}) . '</PT>';
				$PTA = $ref->{'PTA'};
				if ($PTA eq '0000-00-00 00:00:00') { #vähem liiklust
					$PTA = '';
				}
				$artsXML .= "<PTA>${PTA}</PTA>";
				$artsXML .= "<G>${g}</G>";

				$artsXML .= "<l><t>";
				$artLeiuNr = 0;
			}
			else {
				$artsCount .= '+';
				last;
			}
		}

		if ($artLeiuNr > 0) {
			$artsXML .= ' :: ';
		}
		$artLeiuNr++;

		# $artsXML .= "<span class='_b' nr='${artLeiuNr}'>";
		#	$artsXML .= "${lisand}‹${seldLn}";
		#	if ($ref->{'ms_att_i'}) {
		#		$artsXML .= ' ▫i="' . $ref->{'ms_att_i'} . '"';
		#	}
		#	if ($ref->{'ms_att_liik'}) {
		#		$artsXML .= ' ▫liik="' . $ref->{'ms_att_liik'} . '"';
		#	}
		#	if ($ref->{'ms_att_ps'}) {
		#		$artsXML .= ' ▫ps="' . decode_utf8($ref->{'ms_att_ps'}) . '"';
		#	}
		#	if ($ref->{'ms_att_tyyp'}) {
		#		$artsXML .= ' ▫tyyp="' . $ref->{'ms_att_tyyp'} . '"';
		#	}
		#	if ($ref->{'ms_att_mliik'}) {
		#		$artsXML .= ' ▫mliik="' . $ref->{'ms_att_mliik'} . '"';
		#	}
		#	if ($ref->{'ms_att_k'}) {
		#		$artsXML .= ' ▫k="' . $ref->{'ms_att_k'} . '"';
		#	}
		#	if ($ref->{'ms_att_mm'}) {
		#		$artsXML .= ' ▫mm="' . $ref->{'ms_att_mm'} . '"';
		#	}
		#	if ($ref->{'ms_att_st'}) {
		#		$artsXML .= ' ▫st="' . $ref->{'ms_att_st'} . '"';
		#	}
		#	if ($ref->{'ms_att_vm'}) {
		#		$artsXML .= ' ▫vm="' . $ref->{'ms_att_vm'} . '"';
		#	}
		#	if ($ref->{'ms_att_all'}) {
		#		$artsXML .= ' ▫all="' . $ref->{'ms_att_all'} . '"';
		#	}
		#	if ($ref->{'ms_att_uus'}) {
		#		$artsXML .= ' ▫uus="' . $ref->{'ms_att_uus'} . '"';
		#	}
		#	if ($ref->{'ms_att_zs'}) {
		#		$artsXML .= ' ▫zs="' . $ref->{'ms_att_zs'} . '"';
		#	}
		#	if ($ref->{'ms_att_u'}) {
		#		$artsXML .= ' ▫u="' . $ref->{'ms_att_u'} . '"';
		#	}
		#	if ($ref->{'ms_att_em'}) {
		#		$artsXML .= ' ▫em="' . $ref->{'ms_att_em'} . '"';
		#	}
		#	$artsXML .= "›";
		# $artsXML .= "</span>";
		# $artsXML .= " ▪${leiuTekstOrg}";
		# $artsXML .= "<leid>${leiuTekstOrg}</leid>";

		my $attrsStr = '';
		if ($mySqlDataVer eq '2') {

			if ($ref->{'elG'}) {
				my $elG = $ref->{'elG'};
				my $attrsSqlCmd = "SELECT atribuudid_${DIC_DESC}.nimi AS attrQn, atribuudid_${DIC_DESC}.val AS attrVal FROM atribuudid_${DIC_DESC} WHERE (atribuudid_${DIC_DESC}.elG = '${elG}' AND atribuudid_${DIC_DESC}.nimi = '${DICPR}:i') ORDER BY atribuudid_${DIC_DESC}.nimi";
				my $attrs_sth = $dbh->prepare($attrsSqlCmd);
				$attrs_sth->execute();
				while (my $ref_attr = $attrs_sth->fetchrow_hashref()) {
					my $attrQn = decode_utf8($ref_attr->{'attrQn'});
					$attrQn = substr($attrQn, index($attrQn, ':') + 1);
					my $attrVal = decode_utf8($ref_attr->{'attrVal'});
					$attrsStr .= ' ' . $attrQn . '="' . $attrVal . '"';
				}
#				$attrs_sth->finish();
			}
		}
		unless ($attrsStr) {
			if ($ref->{'ms_att_i'}) {
				$attrsStr .= ' i="' . decode_utf8($ref->{'ms_att_i'}) . '"';
			}
#			if ($ref->{'ms_att_liik'}) {
#				$attrsStr .= ' liik="' . decode_utf8($ref->{'ms_att_liik'}) . '"';
#			}
#			if ($ref->{'ms_att_ps'}) {
#				$attrsStr .= ' ps="' . decode_utf8($ref->{'ms_att_ps'}) . '"';
#			}
#			if ($ref->{'ms_att_u'}) {
#				$attrsStr .= ' u="' . decode_utf8($ref->{'ms_att_u'}) . '"';
#			}
		}

		$artsXML .= '<' . $seldLn . $attrsStr . '>' . $lisand . $leiuTekstOrg . '</' . $seldLn . '>';
		
		$viimaneG = $g;
		
	} # while ($ref = $stHandle->fetchrow_hashref()) {

	if ($viimaneG && $artsXML) {
		$artsXML .= '</t></l></A>';
	}

	return $artsXML;
}


sub ehitaOutDomArtikkel() {

	my $artikkel = shift(@_);
	my $volNr = shift(@_);
	my $leid = decode_utf8(shift(@_));

	my $md = '';
	foreach my $mElem ($artikkel->findnodes($dqArt)) {
		my $mTekstid = '';
		foreach my $mText ($mElem->findnodes('text()')) {
			$mTekstid .= $mText->toString; # nt textContent - '&amp;' -> '&', aga md salvestada XML moodi
		}
		if ($md) {
			$md .= ' :: ';
		}
		$md .= $mTekstid;
	}

	my $K = $artikkel->findvalue("${DICPR}:K");
	my $KL = $artikkel->findvalue("${DICPR}:KL");
	my $T = $artikkel->findvalue("${DICPR}:T");
	my $TA = $artikkel->findvalue("${DICPR}:TA");
	my $TL = $artikkel->findvalue("${DICPR}:TL");
	my $PT = $artikkel->findvalue("${DICPR}:PT");
	my $PTA = $artikkel->findvalue("${DICPR}:PTA");
	my $g = $artikkel->findvalue("${DICPR}:G");

	my $tc = '';
	foreach my $t ($artikkel->findnodes('.//text()')) {
		$tc .= $t;
	}

	my $retStr = '<A>';
		$retStr .= "<vf>${DIC_DESC}${volNr}</vf>";
		$retStr .= "<s>" . (int(length($tc) / 1024) + 1) . "</s>";
		$retStr .= "<md>";
			$retStr .= "<t>" . $md . "</t>";
		$retStr .= "</md>";
		$retStr .= "<ddStr>-</ddStr>";
		$retStr .= "<tlkn></tlkn>";
		$retStr .= "<maht></maht>";
		$retStr .= "<K>" . $K . "</K>";
		$retStr .= "<KL>" . $KL . "</KL>";
		$retStr .= "<T>" . $T . "</T>";
		$retStr .= "<TA>" . $TA . "</TA>";
		$retStr .= "<TL>" . $TL . "</TL>";
		$retStr .= "<PT>" . $PT . "</PT>";
		$retStr .= "<PTA>" . $PTA . "</PTA>";
		$retStr .= "<G>" . $g . "</G>";
		my $viga = $leid;
		$viga =~ s/\{$DICURI\}/${DICPR}:/g;
		$viga =~ s/\{http:\/\/www\.eki\.ee\/dict\/schemas\/${DIC_DESC}_tyybid\}//g;
		$viga =~ s/</&lt;/g;
		$viga =~ s/>/&gt;/g;
		$viga =~ s/&/&amp;/g;
		$retStr .= "<l><t>";
			$retStr .= '<' . $seldLn . '>' . $viga . '</' . $seldLn . '>';
		$retStr .= "</t></l>";
	$retStr .= '</A>';

	return $retStr;

} # ehitaOutDomArtikkel


# NB! : ka tools.cgi
sub teeRada {
	my $elem = shift(@_);

	if ($elem->localname eq 'A') {
		return "self::node()";
	}

	my $rada = '';
	my $mina;

	while ($elem->localname ne 'A') {
		$mina = '/' . $elem->nodeName . '[';
		my $minad = $elem->findnodes("preceding-sibling::" . $elem->nodeName);
		$mina .= ($minad->size() + 1) . ']';
		$rada = $mina . $rada;
		$elem = $elem->parentNode;
	}
	# rada peab algama <A> allelemendist, '/' eest maha
	$rada = substr($rada, 1);

	return $rada;
}


# NB! : ka tools.cgi
sub teeLihtRada {
	my $elem = shift(@_);

	if ($elem->localname eq 'A') {
		return "self::node()";
	}

	my $rada = '';

	while ($elem->localname ne 'A') {
		$rada = '/' . $elem->nodeName . $rada;
		$elem = $elem->parentNode;
	}
	# rada peab algama <A> allelemendist, '/' eest maha
	$rada = substr($rada, 1);

	return $rada;
}


sub paneLisadXml_PSV {
	my $art = shift(@_);
	my $oTekst = $art->findnodes($fdArt)->get_node(1)->getAttribute("${DICPR}:O");
	my $refNode = $art->findnodes("${DICPR}:G")->get_node(1);
	my $oDom = $art->ownerDocument;
	# kuna PSV-s on ainult üks köide, las jääb praegu nii, teiste korral ('ss1') tuleks igast köitest otsida ...
	my $lisad = $oDom->documentElement()->findnodes("${DICPR}:A[.//${qn_ms}[\@${DICPR}:ps = '${oTekst}']]");
	if ($lisad->size() > 0) {
		my $pa = $art->insertBefore($oDom->createElement("${DICPR}:pa"), $refNode);
		for (my $ix = 1; $ix <= $lisad->size(); $ix++) { # artiklid
			my $lisaArt = $lisad->get_node($ix);
			my $G = $lisaArt->findvalue("${DICPR}:G");
			my $lisaMsid = $lisaArt->findnodes(".//${qn_ms}[\@${DICPR}:ps = '${oTekst}']");
			for (my $ix2 = 1; $ix2 <= $lisaMsid->size(); $ix2++) { # märksõnad
				my $p = $pa->appendChild($oDom->createElement("${DICPR}:p"));
				$p->appendTextNode($lisaMsid->get_node($ix2)->textContent);
				$p->setAttribute("${DICPR}:aG", $G);
				$p->setAttribute("${DICPR}:aKF", $dicVol); # "ss1", "ief1" jne
			}
		}
	}
	return $art;
}


sub paneLisadMySql_PSV {
	my $art = shift(@_);
	my $oTekst = $art->findnodes($fdArt)->get_node(1)->getAttribute("${DICPR}:O");
	my $refNode = $art->findnodes("${DICPR}:G")->get_node(1);
	my $oDom = $art->ownerDocument;
	my $volTing;
	if ($DIC_DESC eq 'psv') {
		$volTing = " and msid.vol_nr = " . substr($dicVol, 3, 1);
	}
	else {
		$volTing = " and msid.vol_nr > 0";
	}
	my $lisadSqlCmd = "SELECT msid.ms AS ms, msid.vol_nr AS vol_nr, msid.G AS G FROM msid WHERE msid.dic_code = '${DIC_DESC}'${volTing} and msid.ms_att_ps = '${oTekst}' ORDER BY msid.ms";
	my $sth = $dbh->prepare($lisadSqlCmd);
	$sth->execute();
	if ($sth->rows > 0) {
		my $pa = $art->insertBefore($oDom->createElement("${DICPR}:pa"), $refNode);
		while (my $ref = $sth->fetchrow_hashref()) {
			my $vol_nr = $ref->{'vol_nr'};
			my $G = $ref->{'G'};
			my $p = $pa->appendChild($oDom->createElement("${DICPR}:p"));
			$p->appendTextNode(decode_utf8($ref->{'ms'}));
			$p->setAttribute("${DICPR}:aG", $G);
			$p->setAttribute("${DICPR}:aKF", "${DIC_DESC}${vol_nr}"); # "ss1", "ief1" jne
		}
	}
	$sth->finish();
	return $art;
}


use XML::LibXSLT;
my $xslt = XML::LibXSLT->new();
my $XSLSCRIPTSURI = 'http://www.eo.ee/xml/xsl/perlscripts';
XML::LibXSLT->register_function($XSLSCRIPTSURI, 'rex', \&rex);
XML::LibXSLT->register_function($XSLSCRIPTSURI, 'srch', \&srch);
XML::LibXSLT->register_function($XSLSCRIPTSURI, 'srch2', \&srch2);
XML::LibXSLT->register_function($XSLSCRIPTSURI, 'showHL', \&showHL);
XML::LibXSLT->register_function($XSLSCRIPTSURI, 'compMs', \&compMs);

my $queryXSL = $dicparser->parse_file('xsl/query2.xsl');
$queryXSL->documentElement()->setNamespace($DICURI, 'al', 0);
$queryXSL->documentElement()->setNamespace($DICURI, $DICPR, 0);

my $xslnode;
# $xslnode = $queryXSL->documentElement()->findnodes("xsl:variable[\@name='dic_desc']")->get_node(1);
# $xslnode->firstChild->setData($DIC_DESC);
$xslnode = $queryXSL->documentElement()->findnodes("xsl:template[\@match = 'al:A']/A/xsl:variable[\@name = 'marksonad']/xsl:choose/xsl:otherwise/xsl:for-each[\@select = 'siinTulebAsendada']")->get_node(1);
$xslnode->setAttribute("select", $dqArt);
$xslnode = $queryXSL->documentElement()->findnodes("xsl:template[\@match = 'al:A']/A/md/e/xsl:choose/xsl:otherwise")->get_node(1);
$xslnode->setAttribute("select", $qn_ms);
$xslnode = $queryXSL->documentElement()->findnodes("xsl:template[\@match = 'al:A']/A/O/xsl:value-of[\@select = 'siinTulebVeelAsendada']")->get_node(1);
$xslnode->setAttribute("select", "${fdArt}/\@${DICPR}:O");

my ($i, $j, $k, $sortXSL, $fr_sym, $to_sym);

# NB! : ka tools.cgi
sub valmistaSortXsl {
	unless ($sortXSL) {
		$fr_sym = '^0123456789_%+/|';
		$to_sym = '';
		my ($i, $k, $xslnode);
		for ($i = 0, $k = 0xE001; $i < length($fr_sym); $i++) {
			$to_sym .= chr($k + $i);
		}
		for ($i = 0, $k += length($fr_sym); $i < length($msAlpha); $i++) {
			if (($i % 2) == 0) {
				$to_sym .= (chr($k + $i)) x 2;
			}
		}
		$fr_sym .= $msAlpha . '()[]';
		if ($DIC_DESC ne 'evs') {
			$fr_sym .= ' ';
		}

		$sortXSL = $dicparser->parse_file('xsl/mssvorder.xsl');
		$sortXSL->documentElement()->setNamespace($DICURI, 'al', 0);
		$sortXSL->documentElement()->setNamespace($DICURI, $DICPR, 0);
		$xslnode = $sortXSL->documentElement()->findnodes("xsl:variable[\@name='dic_desc']")->get_node(1);
		$xslnode->firstChild->setData($DIC_DESC);
		$xslnode = $sortXSL->documentElement()->findnodes("xsl:variable[\@name='fr_sym']")->get_node(1);
		$xslnode->firstChild->setData($fr_sym);
		$xslnode = $sortXSL->documentElement()->findnodes("xsl:variable[\@name='to_sym']")->get_node(1);
		$xslnode->firstChild->setData($to_sym);
		$xslnode = $sortXSL->documentElement()->findnodes("xsl:template[\@match = 'al:sr']/xsl:copy/xsl:choose/xsl:otherwise/xsl:apply-templates/xsl:sort[\@select = 'siinTulebAsendada']")->get_node(1);
		if ($sortType eq 'number') {
			# $xslnode->setAttribute("select", "number(${fdArt}/\@${DICPR}:O)");
			$xslnode->setAttribute("select", "${fdArt}/\@${DICPR}:O");
		}
		else {
			$xslnode->setAttribute("select", "translate(${fdArt}/\@${DICPR}:O, \$fr_sym, \$to_sym)");
		}
		$xslnode->setAttribute("data-type", $sortType);
	}
}

# NB! : ka tools.cgi
sub translate_ms_att_O {
	my $o = shift(@_);
	my $oo = $o;
	for (my $ix = 0; $ix < length($o); $ix++){
		my $src = substr($o, $ix, 1);
		my $qmsrc = quotemeta($src);
		if ($oo =~ /$qmsrc/) {
			my $frPos = index($fr_sym, $src);
			if ($frPos > -1) {
				my $dst = '';
				if ($frPos < length($to_sym)) {
					$dst = substr($to_sym, $frPos, 1);
				}
				$oo =~ s/$qmsrc/$dst/g;
			}
		}
	}
	# for (my $ix = 0; $ix < length($fr_sym); $ix++) {
		# if ($ix < length($to_sym)) {
			# my $src = quotemeta(substr($fr_sym, $ix, 1));
			# my $dst = quotemeta(substr($to_sym, $ix, 1));
			# $oo =~ s/$src/$dst/g;
		# }
		# else {
			# my $src = quotemeta(substr($fr_sym, $ix, 1));
			# $oo =~ s/$src//g;
		# }
	# }
	return $oo;
}

my $responseXML = <<"responseXML";
<?xml version="1.0" encoding="utf-8" standalone="no"?>
<rsp xmlns:${DICPR}="${DICURI}">
	<sta />
	<cnt />
	<vol />
	<qM />
</rsp>
responseXML
my $responseDOM = $dicparser->parse_string($responseXML);
my $rsp_status_node = $responseDOM->documentElement()->findnodes('sta')->get_node(1);
my $rsp_count_node = $responseDOM->documentElement()->findnodes('cnt')->get_node(1);
my $rsp_vol_node = $responseDOM->documentElement()->findnodes('vol')->get_node(1);
my $rsp_qM_node = $responseDOM->documentElement()->findnodes('qM')->get_node(1);

if (length($fMySQLPtrn) > 2048) {
	$cmdId = "x";
	$rsp_status_node->appendTextNode('length($fMySQLPtrn) = ' . length($fMySQLPtrn));
}

my $admMsg = $shsconfig->documentElement()->findvalue("msg[\@type = 'stop']");
if ($admMsg) {
	$cmdId = "y";
	$rsp_status_node->appendTextNode($admMsg);
}


my $outXML = <<"outXML";
<?xml version="1.0" encoding="utf-8" standalone="no"?>
<outDOM />
outXML
my $outDOM = $dicparser->parse_string($outXML);

# po siin, so globaalsed teiste suhtes ...
my ($dicDOM, $qryDOM, $printDOM);
my $opMs;
my $opAttrs;


my $nStatus = 0;

use Fcntl ':flock';
my $lockType;
if ($^O eq 'MSWin32') {
	$lockType = LOCK_SH;
}
else {
	$lockType = (LOCK_EX | LOCK_NB);
}

my $eeLexConfDom = $dicparser->parse_file('shsConfig.xml');
my $eeLexQM = $eeLexConfDom->documentElement()->findvalue('qmMySql');
my $qmOrg = 'XML';
if (index($eeLexQM, ";${DIC_DESC};") < 0) {
	$qryMethod = 'XML';
}
else {
	$qmOrg = 'MySql';
}

my $ainultMySql = 0;
my $ainultMySqlOrg = 0;
my $eeLexAinultMySql = $eeLexConfDom->documentElement()->findvalue('ainultMySql');
if (index($eeLexAinultMySql, ";${DIC_DESC};") > -1) {
	if ($qryMethod eq 'MySql') {
		$ainultMySql = 1;
	}
	$ainultMySqlOrg = 1;
}

my $mySqlDbName = 'xml_dicts';
if (index($ENV{SCRIPT_NAME}, '/__shs_test/') > -1) {
	$mySqlDbName = 'xml_dicts_test';
}

$rsp_qM_node->appendTextNode($qryMethod);

my $browseInfoStr = "<r>
	<i n='q'>" . $lcDom->documentElement()->findvalue("itm[\@n = 'QUERY'][\@l = '${APP_LANG}']") . "</i>
	<i n='l'>" . $lcDom->documentElement()->findvalue("itm[\@n = 'MATCHES'][\@l = '${APP_LANG}']") . "</i>
	<i n='e'>" . $lcDom->documentElement()->findvalue("itm[\@n = 'ENTRIES'][\@l = '${APP_LANG}']") . "</i>
	<i n='nr'>" . $lcDom->documentElement()->findvalue("itm[\@n = 'NR'][\@l = '${APP_LANG}']") . "</i>
	<i n='v'>" . $lcDom->documentElement()->findvalue("itm[\@n = 'VOLUME'][\@l = '${APP_LANG}']") . "</i>
	<i n='hw'>" . $lcDom->documentElement()->findvalue("itm[\@n = 'HEADWORDS'][\@l = '${APP_LANG}']") . "</i>
	<i n='contIn'>Sisaldub</i>
	<i n='m'>" . $lcDom->documentElement()->findvalue("itm[\@n = 'MATCH'][\@l = '${APP_LANG}']") . "</i>
	<i n='tr'>" . $lcDom->documentElement()->findvalue("itm[\@n = 'TRANSLATOR'][\@l = '${APP_LANG}']") . "</i>
	<i n='capy'>" . $lcDom->documentElement()->findvalue("itm[\@n = 'CAPACITY'][\@l = '${APP_LANG}']") . "</i>
	<i n='K'>" . $lcDom->documentElement()->findvalue("itm[\@n = 'CREATOR'][\@l = '${APP_LANG}']") . "</i>
	<i n='KL'>" . $lcDom->documentElement()->findvalue("itm[\@n = 'CREATINGENDED'][\@l = '${APP_LANG}']") . "</i>
	<i n='T'>" . $lcDom->documentElement()->findvalue("itm[\@n = 'EDITOR'][\@l = '${APP_LANG}']") . "</i>
	<i n='TA'>" . $lcDom->documentElement()->findvalue("itm[\@n = 'EDITED'][\@l = '${APP_LANG}']") . "</i>
	<i n='TL'>" . $lcDom->documentElement()->findvalue("itm[\@n = 'EDITINGENDED'][\@l = '${APP_LANG}']") . "</i>
	<i n='PT'>" . $lcDom->documentElement()->findvalue("itm[\@n = 'SIGNER'][\@l = '${APP_LANG}']") . "</i>
	<i n='PTA'>" . $lcDom->documentElement()->findvalue("itm[\@n = 'SIGNED'][\@l = '${APP_LANG}']") . "</i>
	<i n='flt'>" . $lcDom->documentElement()->findvalue("itm[\@n = 'FLT'][\@l = '${APP_LANG}']") . "</i>
	<i n='ts'>" . $lcDom->documentElement()->findvalue("itm[\@n = 'SORT'][\@l = '${APP_LANG}']") . "</i>
	<i n='mpa'>" . $lcDom->documentElement()->findvalue("itm[\@n = 'FIRSTTOSHOW'][\@l = '${APP_LANG}']") . ' ' . $MAX_PRINT_ARTS . ' ' . $lcDom->documentElement()->findvalue("itm[\@n = 'ENTRIES'][\@l = '${APP_LANG}']") . "</i>";
if ($qryMethod eq 'MySql') {
	$browseInfoStr .= "<qM>MySQL.ico</qM>";
}
else {
	$browseInfoStr .= "<qM>xml_16-16.ico</qM>";
}
$browseInfoStr .= "<dd>${DIC_DESC}</dd>
			</r>";

my $qrySql;

my $startTime = time();
my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime($startTime);
my $nowdtstr = sprintf("%04d-%02d-%02dT%02d:%02d:%02d", $year + 1900, $mon + 1, $mday, $hour, $min, $sec);
my $logFileName = substr($nowdtstr, 0, 10);

use DBI();

my $dicsParinguLisad = ";psv;ss1;";

use Tie::File;

sub mySqlTimestamp() {
	my @tsData;
	tie(@tsData, 'Tie::File', "__sr/${DIC_DESC}/mySqlTimeStamp.txt");
	my $rida = "${nowdtstr}\t${usrName}";
	if (scalar(@tsData) == 0) {
		unshift(@tsData, $rida);
	}
	else {
		$tsData[0] = $rida;
	}
	untie(@tsData);
}

if ($cmdId eq "BrowseRead") {

	my $artikkel;
	my $artCnt = -1;

	if ($qryMethod eq 'MySql') {

		$dbh = DBI->connect("DBI:mysql:database=${mySqlDbName};mysql_enable_utf8=1;host=${mysql_ip}",
							 $mysql_user, $mysql_pass,
							 {'RaiseError' => 1});
		
		my $vNr = substr($dicVol, 3, 1);
		$qrySql = "SELECT ${DIC_DESC}.art AS art FROM ${DIC_DESC} WHERE ${DIC_DESC}.G = '${artG}' AND ${DIC_DESC}.vol_nr = ${vNr}";
		my $sth = $dbh->prepare($qrySql);
		$sth->execute();
		$artCnt = $sth->rows;
		if ($artCnt == 1) {
			if (my $ref = $sth->fetchrow_hashref()) {
				my $artDom = $dicparser->parse_string(decode_utf8($ref->{'art'}));
				$artikkel = $artDom->documentElement();
				if (index($dicsParinguLisad, ";${DIC_DESC};") > -1) {
					$artikkel = &paneLisadMySql_PSV($artikkel);
				}
			}
		}
		else {
			$rsp_status_node->appendTextNode("Failed on select: '${qrySql}' (${artCnt} tk) (${cmdId})!");
		}
		
		$sth->finish();
		# Disconnect from the database.
		$dbh->disconnect();
	}
	else {
		my $xmlFile = "__sr/${DIC_DESC}/${dicVol}.xml";

		if (open(XMLF, '<:utf8', $xmlFile)) {
	#		if (flock(XMLF, $lockType)) {
				$dicDOM = $dicparser->parse_file($xmlFile);
				my $xPath = "${DICPR}:A[${DICPR}:G = '${artG}']";
				my $nodes = $dicDOM->documentElement()->findnodes($xPath);

				$artCnt = $nodes->size();
				if ($artCnt == 1) {
					$artikkel = $nodes->get_node(1);
					if (index($dicsParinguLisad, ";${DIC_DESC};") > -1) {
						$artikkel = &paneLisadXml_PSV($artikkel);
					}
				}
				else {
					$rsp_status_node->appendTextNode("Failed on 'findnodes(${xPath}) (${artCnt} tk) (${cmdId})!");
				}
	#			flock(XMLF, LOCK_UN);
	#		}
	#		else {
	#			$rsp_status_node->appendTextNode("Failed to flock '${xmlFile}' (${cmdId})!");
	#		}
			close(XMLF);
		}
		else {
			$rsp_status_node->appendTextNode("Failed to open '${xmlFile}' (${cmdId})!");
		}
	}

	$rsp_count_node->appendTextNode($artCnt);
	$rsp_vol_node->appendTextNode($dicVol);
	if ($artikkel) {
		$rsp_status_node->appendTextNode("Success");
		$responseDOM->documentElement()->appendChild($responseDOM->importNode($artikkel));
	}

}
elsif ($cmdId eq "srvXmlValidate") {

	my $vNr = substr($dicVol, 3, 1);

	my ($schema, $valErr);
	eval { $schema = XML::LibXML::Schema->new( location => "xsd/schema_${DIC_DESC}.xsd" ) };

	unless ($schema) {
		$valErr = decode_utf8($@);
		$valErr =~ s/\s+/ /g; # veateates võib olla reavahetusi, mis logifaili p...e keerab
		$rsp_status_node->appendTextNode($valErr);
		$rsp_count_node->appendTextNode('-1');
	}
	elsif ($qryMethod eq 'MySql') {
		$dbh = DBI->connect("DBI:mysql:database=${mySqlDbName};mysql_enable_utf8=1;host=${mysql_ip}",
							 $mysql_user, $mysql_pass,
							 {'RaiseError' => 1});

		$qrySql = "SELECT ${DIC_DESC}.art AS art, ${DIC_DESC}.G AS G FROM ${DIC_DESC} WHERE ${DIC_DESC}.vol_nr = ${vNr} ORDER BY ${DIC_DESC}.ms_att_OO";
		my $sth = $dbh->prepare($qrySql);
		$sth->execute();

		my $invalidArts = 0;
		my $respStr = "<sr>";
		while (my $ref = $sth->fetchrow_hashref()) {
			my $art = decode_utf8($ref->{'art'});
			my $artikliDom = $dicparser->parse_string($art);
			my $artikkel = $artikliDom->documentElement();

			$artikkel->setNamespace($DICURI, $DICPR, 0);
			my $artDom = XML::LibXML::Document->createDocument( "1.0", "UTF-8" );
			$artDom->setDocumentElement($artDom->importNode( $artikkel->cloneNode(1) ));

			eval { $schema->validate($artDom) };
			# die $@ if $@;

			if ($@) {
				$invalidArts++;
				$respStr .= &ehitaOutDomArtikkel($artikkel, $vNr, $@);
			}
			if ($invalidArts >= $MAX_PRINT_ARTS) {
				last;
			}
		}
		$respStr .= "</sr>";
		$sth->finish();
		$dbh->disconnect();

		$rsp_vol_node->appendTextNode($dicVol);
		$rsp_status_node->appendTextNode("Success");
		$rsp_count_node->appendTextNode($invalidArts);

		my $valdDOM = $dicparser->parse_string($respStr);
		$outDOM->documentElement()->appendChild($outDOM->importNode($valdDOM->documentElement()));
		my $brInfoDom = $dicparser->parse_string($browseInfoStr);
		$outDOM->documentElement()->appendChild($outDOM->importNode($brInfoDom->documentElement()));
		$outDOM->documentElement()->setAttribute("qinfo", $qinfo);
		$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));
	}
	else {
		my $xmlFile = "__sr/${DIC_DESC}/${dicVol}.xml";
		if (open(XMLF, '<:utf8', $xmlFile)) {
			# if (flock(XMLF, $lockType)) {
				$dicDOM = $dicparser->parse_file($xmlFile);
				my $invalidArts = 0;
				my $respStr = "<sr>";
				foreach my $artikkel ($dicDOM->documentElement()->findnodes("${DICPR}:A")) {

					$artikkel->setNamespace($DICURI, $DICPR, 0);
					my $artDom = XML::LibXML::Document->createDocument( "1.0", "UTF-8" );
					$artDom->setDocumentElement($artDom->importNode( $artikkel->cloneNode(1) ));

					eval { $schema->validate($artDom) };
					# die $@ if $@;

					if ($@) {
						$invalidArts++;
						$respStr .= &ehitaOutDomArtikkel($artikkel, $vNr, $@);
					}
					if ($invalidArts >= $MAX_PRINT_ARTS) {
						last;
					}
				}
				$respStr .= "</sr>";

				$rsp_vol_node->appendTextNode($dicVol);
				$rsp_status_node->appendTextNode("Success");
				$rsp_count_node->appendTextNode($invalidArts);

				my $valdDOM = $dicparser->parse_string($respStr);
				$outDOM->documentElement()->appendChild($outDOM->importNode($valdDOM->documentElement()));
				my $brInfoDom = $dicparser->parse_string($browseInfoStr);
				$outDOM->documentElement()->appendChild($outDOM->importNode($brInfoDom->documentElement()));
				$outDOM->documentElement()->setAttribute("qinfo", $qinfo);
				$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));
			# }
			# else {
			#	$rsp_status_node->appendTextNode("Failed to flock '${xmlFile}' (${cmdId})!");
			# }
			close(XMLF);
		}
		else {
			$rsp_status_node->appendTextNode("Failed to open '${xmlFile}' (${cmdId})!");
		}
	}
}
elsif ($cmdId eq "prevNextRead") {

	my $vNr = substr($dicVol, 3, 1);

	if ($qryMethod eq 'MySql') {
		$dbh = DBI->connect("DBI:mysql:database=${mySqlDbName};mysql_enable_utf8=1;host=${mysql_ip}",
							 $mysql_user, $mysql_pass,
							 {'RaiseError' => 1});
		my $sisemine = "SELECT ${DIC_DESC}.ms_att_OO AS OO FROM ${DIC_DESC} WHERE ${DIC_DESC}.G = '${artG}'";
		my ($ting, $leitud, $art, $sth);
		if ($elm_xpath eq '-1') { # eelmine
			$ting = "WHERE ms_att_OO <= (${sisemine}) AND vol_nr = ${vNr} ORDER BY ms_att_OO DESC LIMIT 20";
			$qrySql = "SELECT ${DIC_DESC}.art AS art, ${DIC_DESC}.G AS G FROM ${DIC_DESC} $ting";
			$sth = $dbh->prepare($qrySql);
			$sth->execute();
			while (my $ref = $sth->fetchrow_hashref()) {
				if ($leitud) {
					$art = $ref->{'art'};
					last;
				}
				else {
					if ($ref->{'G'} eq $artG) {
						$leitud = 1;
					}
				}
			}
		}
		elsif ($elm_xpath eq '1') { # järgmine
			$ting = "WHERE ms_att_OO >= (${sisemine}) AND vol_nr = ${vNr} ORDER BY ms_att_OO ASC LIMIT 20";
			$qrySql = "SELECT ${DIC_DESC}.art AS art, ${DIC_DESC}.G AS G FROM ${DIC_DESC} $ting";
			$sth = $dbh->prepare($qrySql);
			$sth->execute();
			while (my $ref = $sth->fetchrow_hashref()) {
				if ($leitud) {
					$art = $ref->{'art'};
					last;
				}
				else {
					if ($ref->{'G'} eq $artG) {
						$leitud = 1;
					}
				}
			}
		}
		elsif ($elm_xpath eq '0') { # esimene
			$ting = "WHERE vol_nr = ${vNr} ORDER BY ms_att_OO ASC LIMIT 1";
			$qrySql = "SELECT ${DIC_DESC}.art AS art, ${DIC_DESC}.G AS G FROM ${DIC_DESC} $ting";
			#warn $qrySql;
			$sth = $dbh->prepare($qrySql);
			$sth->execute();
			if (my $ref = $sth->fetchrow_hashref()) {
				$art = $ref->{'art'};
			}
		}
		elsif ($elm_xpath eq '1000000') { # viimane
			$ting = "WHERE vol_nr = ${vNr} ORDER BY ms_att_OO DESC LIMIT 1";
			$qrySql = "SELECT ${DIC_DESC}.art AS art, ${DIC_DESC}.G AS G FROM ${DIC_DESC} $ting";
			$sth = $dbh->prepare($qrySql);
			$sth->execute();
			if (my $ref = $sth->fetchrow_hashref()) {
				$art = $ref->{'art'};
			}
		}
		$sth->finish();
		$dbh->disconnect();
		
		$rsp_vol_node->appendTextNode($dicVol);
		$rsp_status_node->appendTextNode("Success");
		if ($art) {
			my $artDom = $dicparser->parse_string(decode_utf8($art));
			$rsp_count_node->appendTextNode(1);
			$responseDOM->documentElement()->appendChild($responseDOM->importNode($artDom->documentElement()));
		}
		else {
			$rsp_count_node->appendTextNode(0);
		}
	}
	else {
		my $xmlFile = "__sr/${DIC_DESC}/${dicVol}.xml";
		if (open(XMLF, '<:utf8', $xmlFile)) {
	#		if (flock(XMLF, $lockType)) {
				$dicDOM = $dicparser->parse_file($xmlFile);
				my $nodes = $dicDOM->documentElement()->findnodes($art_xpath);
				$rsp_vol_node->appendTextNode($dicVol);
				$rsp_status_node->appendTextNode("Success");
				$rsp_count_node->appendTextNode($nodes->size());
				if ($nodes->size() == 1) {
					$responseDOM->documentElement()->appendChild($responseDOM->importNode($nodes->get_node(1)));
				}
	#		}
	#		else {
	#			$rsp_status_node->appendTextNode("Failed to flock '${xmlFile}' (${cmdId})!");
	#		}
			close(XMLF);
		}
		else {
			$rsp_status_node->appendTextNode("Failed to open '${xmlFile}' (${cmdId})!");
		}
	}
}
elsif ($cmdId eq "tyhjadViited") {
	if ($qryMethod eq 'MySql') {
		my ($viitedXSL, $viiteXslNode);

		$viitedXSL = $dicparser->parse_file('xsl/viited.xsl');
		$viitedXSL->documentElement()->setNamespace($DICURI, 'al', 0);
		$viitedXSL->documentElement()->setNamespace($DICURI, $DICPR, 0);

		my $viiteQn = $seldQn;
		my $viiteLn = substr($viiteQn, index($viiteQn, ':') + 1);
        
        #Märksõna element
		my $qn_ms_el = substr($qn_ms , index($qn_ms , ':') + 1);
		#võrreldav element
     	my $qn2_ms_el = substr($seldQn2, index($seldQn2, ':') + 1);
     	
				
		$viiteXslNode = $viitedXSL->documentElement()->findnodes("xsl:template[\@match = 'al:A']/A/xsl:variable[\@name = 'marksonad']/xsl:for-each[\@select = 'siinTulebAsendada']")->get_node(1);
		$viiteXslNode->setAttribute("select", $dqArt);
		$viiteXslNode = $viitedXSL->documentElement()->findnodes("xsl:template[\@match = 'al:A']/A/md/e")->get_node(1);
		$viiteXslNode->setAttribute("select", $qn_ms);

		$elm_xpath = ".//${viiteQn}";
		$art_xpath = "${DICPR}:A[${elm_xpath}]";
		$viiteXslNode = $viitedXSL->documentElement()->findnodes("xsl:template[\@match = 'al:sr']/sr/xsl:apply-templates")->get_node(1);
		$viiteXslNode->setAttribute("select", $art_xpath);

		$viiteXslNode = $viitedXSL->documentElement()->findnodes("xsl:template[\@match = 'al:A']/A/l/xsl:for-each")->get_node(1);
		$viiteXslNode->setAttribute("select", $elm_xpath);


		my $ss = $xslt->parse_stylesheet($viitedXSL);


		if ($dicVol eq "${DIC_DESC}All") {
			$i = 1;
			$j = $DIC_VOLS_COUNT;
		}
		else {
			$i = substr($dicVol, 3, 1);
			$j = $i;
		}

		my $qrycount = 0;
		my $puuduvaidViiteid = 0;
		my $lastG = '';
		my $lastVol = '';

		$dbh = DBI->connect("DBI:mysql:database=${mySqlDbName};mysql_enable_utf8=1;host=${mysql_ip}",
							 $mysql_user, $mysql_pass,
							 {'RaiseError' => 0, AutoCommit => 0});

		my $artLeiuNr;
		my $respStr = "<sr>";
        
        my $whClause;
        my $sth2;
        
        if($qn_ms_el ne $qn2_ms_el){
          $whClause = "SELECT msid.ms AS ms, msid.ms_att_i AS ms_att_i FROM msid WHERE msid.G=(select elemendid_${DIC_DESC}.G from elemendid_${DIC_DESC} where elemendid_${DIC_DESC}.nimi='${DICPR}:${qn2_ms_el}' and elemendid_${DIC_DESC}.val = binary ? and (SELECT if(count(val)=1,true ,false) as atti FROM atribuudid_${DIC_DESC} where atribuudid_${DIC_DESC}.elG = elemendid_${DIC_DESC}.elG  and atribuudid_${DIC_DESC}.nimi = '${DICPR}:i' and atribuudid_${DIC_DESC}.val = ?) limit 1) and msid.dic_code = '${DIC_DESC}' AND msid.vol_nr > 0;";
  		  $sth2 = $dbh->prepare($whClause);
        }else{

         $whClause = "msid.dic_code = '${DIC_DESC}' AND msid.vol_nr > 0 AND msid.ms = BINARY ? AND IFNULL(msid.ms_att_i, -1) = ?";
		 $sth2 = $dbh->prepare("SELECT msid.ms AS ms, msid.ms_att_i AS ms_att_i FROM msid WHERE ${whClause}");
        }
	
warn $whClause.',,'.$viiteLn;
		for ($i; $i <= $j; $i++) {
			my $xmlFile = "__sr/${DIC_DESC}/${DIC_DESC}${i}.xml";

			if (open(XMLF, '<:utf8', $xmlFile)) {
				$dicDOM = $dicparser->parse_file($xmlFile);
				$qryDOM = $ss->transform($dicDOM, vf => "'${DIC_DESC}${i}'");
				$nStatus = 1;
				close(XMLF);
			}
			else {
				$nStatus = 0;
			}
			if ($nStatus == 1) {
				foreach my $vArt ($qryDOM->documentElement()->childNodes) {
					my $md = $vArt->findvalue("md/t");
					my $K = $vArt->findvalue("K");
					my $T = $vArt->findvalue("T");
					my $TA = $vArt->findvalue("TA");
					my $PT = $vArt->findvalue("PT");
					my $g = $vArt->findvalue("G");
					my $vol_nr = $i;

					$lastG = $g;
					$lastVol = $vol_nr;

					$artLeiuNr = 0;

					my $viitedList = $vArt->findnodes("l/${viiteQn}");
					for (my $ixViide = 1; $ixViide <= $viitedList->size(); $ixViide++) {
						my $viiteNode = $viitedList->get_node($ixViide);
						my $vXml = '';
						foreach my $vText ($viiteNode->findnodes('text()')) {
							$vXml .= $vText->toString; #nt textContent - '&amp;' -> '&', aga md salvestada XML moodi
						}
						# '<mvt>  -viide märksõnale; <lvt> - SP-s viide pereliikmele
						my $homNrVal = $viiteNode->getAttribute("${DICPR}:iv");
						unless ($homNrVal) {
							$homNrVal = $viiteNode->findvalue("${DICPR}:vhom");
						}
						unless ($homNrVal) {
							#	'sõnaperedes ja SS1-s <mvt> küljes
							$homNrVal = $viiteNode->getAttribute("${DICPR}:i");
						}
						my $ms_att_i = -1;
						if ($homNrVal) {
							$ms_att_i = $homNrVal;
						}

						my $iCnt = $sth2->execute($vXml, $ms_att_i);

						# järelkontroll "COLLATE=utf8_estonian_ci" pärast ..., (a = A ning tagatühikud puhuvad pilli)
						# LIKE BINARY v BINARY str tulemus sõltub kontekstist, vahel indeksit kasutada ei saa;
						# antud juhul peab BINARY olema argumendi, mitte msid.ms ees
#						my $eiLeitud = 1;
#						if ($iCnt > 0) {
#							while (my $ref = $sth2->fetchrow_hashref()) {
#								my $ms = decode_utf8($ref->{'ms'});
#								if ($ms eq $vXml) {
#									$eiLeitud = 0;
#									last;
#								}
#							}
#						}

						if ($iCnt < 1) {
							$artLeiuNr++;
							$puuduvaidViiteid++;
							$respStr .= '<A>';
								$respStr .= "<vf>${DIC_DESC}" . $vol_nr . "</vf>";
								$respStr .= "<md>";
									$respStr .= "<t>" . $md . "</t>";
								$respStr .= "</md>";
								$respStr .= "<K>" . $K . "</K>";
								$respStr .= "<T>" . $T . "</T>";
								$respStr .= "<TA>" . $TA . "</TA>";
								$respStr .= "<PT>" . $PT . "</PT>";
								$respStr .= "<G>" . $g . "</G>";
								$respStr .= "<l><t>";
									$respStr .= "<span class='_b' nr='${artLeiuNr}'>‹${viiteLn}";
										foreach my $attNode ($viiteNode->attributes()) {
											unless ($attNode->nodeName eq "${DICPR}:O" || $attNode->nodeName eq "xml:lang") {
												$respStr .= ' ▫' . $attNode->localname . '="' . $attNode->textContent . '"';
											}
										}
										$respStr .= "›</span>";
									$respStr .= " ▪${vXml}";
								$respStr .= '</t></l>';
							$respStr .= '</A>';
						}
					} # for $ixViide
					if ($artLeiuNr) {
						$qrycount++;
					}
				} # foreach my $vArt
			} # if $nStatus
			unless ($nStatus == 1) {
				last;
			}
		} # for $i
		$sth2->finish();
		$respStr .= "</sr>";

		$rsp_count_node->appendTextNode($qrycount);
		$rsp_status_node->appendTextNode("Success");

		# $outDOM->documentElement()->setAttribute("qfID", $queryFileID);
		$outDOM->documentElement()->setAttribute("qinfo", $qinfo);
		$outDOM->documentElement()->setAttribute("leide", $puuduvaidViiteid);

		if ($qrycount == 1) {
			$qrySql = "SELECT ${DIC_DESC}.art AS art FROM ${DIC_DESC} WHERE ${DIC_DESC}.G = '${lastG}' AND ${DIC_DESC}.vol_nr = ${lastVol}";
			my $sth = $dbh->prepare($qrySql);
			my $artCnt = $sth->execute();
			if ($artCnt == 1) {
				if (my $ref = $sth->fetchrow_hashref()) {
					my $artDom = $dicparser->parse_string(decode_utf8($ref->{'art'}));
					$dicVol = "${DIC_DESC}${lastVol}"; # selle järgi sätitakse ka köidete loend vastavale köitele
					$rsp_vol_node->appendTextNode($dicVol);
					$responseDOM->documentElement()->appendChild($responseDOM->importNode($artDom->documentElement()));
				}
			}
		}
		elsif ($qrycount > 1) {
			$qryDOM = $dicparser->parse_string($respStr);
			$outDOM->documentElement()->appendChild($outDOM->importNode($qryDOM->documentElement()));
			my $brInfoDom = $dicparser->parse_string($browseInfoStr);
			$outDOM->documentElement()->appendChild($outDOM->importNode($brInfoDom->documentElement()));
			# $outDOM->toFile("temp/${queryFileID}.xml", 0);
			$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));
		}

		$dbh->disconnect();

	} # if 'MySql'
	else {
		$rsp_count_node->appendTextNode(-1);
		$rsp_status_node->appendTextNode("Success");
	}
}
elsif ($cmdId eq "msSarnased") {
	if ($qryMethod eq 'MySql') {

		$dbh = DBI->connect("DBI:mysql:database=${mySqlDbName};mysql_enable_utf8=1;host=${mysql_ip}",
							 $mysql_user, $mysql_pass,
							 {'RaiseError' => 1});

		my $volCond = '= ' . substr($dicVol, 3, 1);
		if ($dicVol eq "${DIC_DESC}All") {
			$volCond = '> 0';
		}
		
		my $sth;
		my $leide = 0;
		my $respStr = "<sr>";
		
		my $msNosCount = $dbh->do("CREATE TEMPORARY TABLE tt (SELECT * FROM msid WHERE (msid.dic_code = '${DIC_DESC}' AND msid.vol_nr ${volCond}) GROUP BY ms_nos HAVING COUNT(msid.ms_nos) > 1)");

		$qrySql = "SELECT 
			${DIC_DESC}.md AS md, 
			msid.ms AS l, 
			msid.ms_att_i AS ms_att_i, 
			msid.ms_att_liik AS ms_att_liik, 
			msid.ms_att_ps AS ms_att_ps, 
			msid.ms_att_tyyp AS ms_att_tyyp, 
			msid.ms_att_mliik AS ms_att_mliik, 
			msid.ms_att_k AS ms_att_k, 
			msid.ms_att_mm AS ms_att_mm, 
			msid.ms_att_st AS ms_att_st, 
			msid.ms_att_vm AS ms_att_vm, 
			msid.ms_att_all AS ms_att_all, 
			msid.ms_att_uus AS ms_att_uus, 
			msid.ms_att_zs AS ms_att_zs, 
			msid.ms_att_u AS ms_att_u, 
			msid.ms_att_em AS ms_att_em, 
			${DIC_DESC}.G AS G, 
			${DIC_DESC}.art AS art, 
			${DIC_DESC}.K AS K, 
			${DIC_DESC}.T AS T, 
			${DIC_DESC}.TA AS TA, 
			${DIC_DESC}.PT AS PT, 
			${DIC_DESC}.vol_nr AS vol_nr 
			FROM msid, ${DIC_DESC}, tt 
			WHERE ( ${DIC_DESC}.G = msid.G 
				AND msid.dic_code = '${DIC_DESC}' 
				AND msid.ms_nos = tt.ms_nos
				AND msid.vol_nr ${volCond} ) 
			ORDER BY msid.ms_nos";

		$qrySql =~ s/\s+/ /g;
		$sth = $dbh->prepare($qrySql);
		$sth->execute();
		$leide = $sth->rows; # $qrycount on tegelikult leidude arv, kui küsitakse märksõnu
		$respStr .= teeXMLStr($sth, '');

		$respStr .= "</sr>";
		
		$sth->finish();
		$dbh->disconnect();

		$rsp_count_node->appendTextNode($artsCount);
		$rsp_status_node->appendTextNode("Success");

		# $outDOM->documentElement()->setAttribute("qfID", $queryFileID);
		$outDOM->documentElement()->setAttribute("qinfo", $qinfo);
		$outDOM->documentElement()->setAttribute("leide", $leide);

		if ($artsCount == 1) {
			my $artDom = $dicparser->parse_string($viimaneArt);
			$dicVol = "${DIC_DESC}${viimane_vol_nr}"; # selle järgi sätitakse ka köidete loend vastavale köitele
			$rsp_vol_node->appendTextNode($dicVol);
			$responseDOM->documentElement()->appendChild($responseDOM->importNode($artDom->documentElement()));
		}
		else {
			$qryDOM = $dicparser->parse_string($respStr);
			$outDOM->documentElement()->appendChild($outDOM->importNode($qryDOM->documentElement()));
			my $brInfoDom = $dicparser->parse_string($browseInfoStr);
			$outDOM->documentElement()->appendChild($outDOM->importNode($brInfoDom->documentElement()));
			# $outDOM->toFile("temp/${queryFileID}.xml", 0);
			$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));
		}
	}
	else {
		$rsp_count_node->appendTextNode(-1);
		$rsp_status_node->appendTextNode("Success");
	}
}
elsif ($cmdId eq "ClientRead") {

	if ($qryMethod eq 'MySql') {

		$dbh = DBI->connect("DBI:mysql:database=${mySqlDbName};mysql_enable_utf8=1;host=${mysql_ip}",
							 $mysql_user, $mysql_pass,
							 {'RaiseError' => 1});

		my $sth;
		my $leide = 0;

		my $qrySym = '';
		if ($pQrySql =~ /extractvalue\(/i) {
			$qrySym = 'Σ = ';
		}

		my $SQLCLIENT_OUT_OF_MEMORY = 40000;

		$qrySql = $pQrySql;
		$qrySql =~ s/\s+/ /g;
		$qrySql =~ s/^SELECT /SELECT SQL_CALC_FOUND_ROWS /g;
if ($qrySql =~ / LIMIT (\d+)/) {
$SQLCLIENT_OUT_OF_MEMORY = $1;
} else {
		$qrySql .= " LIMIT ${SQLCLIENT_OUT_OF_MEMORY}";
}
		$sth = $dbh->prepare($qrySql);
eval {
		$sth->execute();
};
die ("Vigane SQL: $qrySql") if $@;

		$leide = $sth->rows; # tegelikult leidude arv, kui pole 'ExtractValue'
		if ($leide == $SQLCLIENT_OUT_OF_MEMORY) {
			my $sth2 = $dbh->prepare("SELECT FOUND_ROWS() AS fullCnt");
			$sth2->execute();
			if (my $ref2 = $sth2->fetchrow_hashref()) {
				$leide = $ref2->{'fullCnt'};
			}
		}

		my $respStr = "<sr>";
		$respStr .= teeXMLStr($sth, $qrySym);
		$respStr .= "</sr>";

		# $artsCount = nrEtSepr($artsCount);
		# $leide = nrEtSepr($leide);

		if ($qrySql =~ /extractvalue\(/i) {
			my $temp = $artsCount;
			$artsCount = $leide;
			$leide = $temp;
		} else {
			if ($leide > $SQLCLIENT_OUT_OF_MEMORY) {
				$artsCount .= '+?';
			}
		}
		
		$sth->finish();
		$dbh->disconnect();

		$rsp_count_node->appendTextNode($artsCount);
		$rsp_status_node->appendTextNode("Success");

		# $outDOM->documentElement()->setAttribute("qfID", $queryFileID);
		$outDOM->documentElement()->setAttribute("qinfo", $qinfo);
		$outDOM->documentElement()->setAttribute("leide", $leide);

		if ($artsCount == 1) {
			my $artDom = $dicparser->parse_string($viimaneArt);
			my $artikkel = $artDom->documentElement();
			$dicVol = "${DIC_DESC}${viimane_vol_nr}"; # selle järgi sätitakse ka köidete loend vastavale köitele
			$rsp_vol_node->appendTextNode($dicVol);
			if (index($dicsParinguLisad, ";${DIC_DESC};") > -1) {
				$artikkel = &paneLisadMySql_PSV($artikkel);
			}
			$responseDOM->documentElement()->appendChild($responseDOM->importNode($artikkel));
		}
		else {
			$qryDOM = $dicparser->parse_string($respStr);
			$outDOM->documentElement()->appendChild($outDOM->importNode($qryDOM->documentElement()));
			my $brInfoDom = $dicparser->parse_string($browseInfoStr);
			$outDOM->documentElement()->appendChild($outDOM->importNode($brInfoDom->documentElement()));
#			$outDOM->toFile("temp/${queryFileID}.xml", 0);
			$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));
		}
	}
	else { # 'ClientRead': qM eq 'XML'

		$xslnode = $queryXSL->documentElement()->findnodes("xsl:template[\@match = 'al:sr']/sr/xsl:apply-templates")->get_node(1);
		$xslnode->setAttribute("select", $art_xpath);

		$xslnode = $queryXSL->documentElement()->findnodes("xsl:template[\@match = 'al:A']/A/l/t/xsl:for-each")->get_node(1);
		$xslnode->setAttribute("select", $elm_xpath);

		my $ss = $xslt->parse_stylesheet($queryXSL);
	    
		# artikleid
		my $qrycount = 0;
		# leide
		my $leide = 0;
		my $qryguid;
		my $qryart;
		my $xmlFile;

		# 19. apr 2012
		# siia nüüd XML kirjutamise kontroll (kas mitte MySql-is on muudatusi, mida XML-is pole)
		# ei lase seda praegu käiku: nt 'ss1' peale läheb ca 15 sek
		# automaatne XML-ide tegemine sai käima iga veerandtund koos timestamp arvestusega
		if ($ainultMySqlOrg == 17) {
			my $xmlAeg = (stat("__sr/${DIC_DESC}/${DIC_DESC}1.xml"))[9];
			my $tsFile = "__sr/${DIC_DESC}/mySqlTimeStamp.txt";
			# kui timestamp puudub, siis polegi MySql muudatusi toimunud
			if (-e $tsFile) {
				my $mtime = (stat($tsFile))[9];
				if ($xmlAeg < $mtime) {

					$dbh = DBI->connect("DBI:mysql:database=${mySqlDbName};mysql_enable_utf8=1;host=${mysql_ip}",
											$mysql_user, $mysql_pass,
											{'RaiseError' => 1});

					for (my $vol_Nr = 0; $vol_Nr <= $DIC_VOLS_COUNT; $vol_Nr++) {
						my $xmlFile = "__sr/${DIC_DESC}/${DIC_DESC}${vol_Nr}.xml";
						if (open(XMLF, '>:utf8', $xmlFile)) {
							my $exportCmd = "SELECT ${DIC_DESC}.art AS art FROM ${DIC_DESC} WHERE ${DIC_DESC}.vol_nr = ${vol_Nr} ORDER BY ${DIC_DESC}.ms_att_OO";
							my $sth = $dbh->prepare($exportCmd);
							$sth->execute();
							my $artCnt = $sth->rows;

							print(XMLF "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n");
							print(XMLF "<${DICPR}:sr xml:lang=\"${rootLang}\" xmlns:${DICPR}=\"${DICURI}\">\n");

							while (my $ref = $sth->fetchrow_hashref()) {
								my $artStr = decode_utf8($ref->{'art'});
								$artStr =~ s/ xmlns:$DICPR="$DICURI">/>/;
								print(XMLF "${artStr}\n");
							}

							print(XMLF "</${DICPR}:sr>\n");
							close(XMLF);

							$sth->finish();
						}
						else {
							print("Failed to open '${xmlFile}' for writing, (${cmdId})!\n");
						}
					} # for (my $vol_Nr = 0; $vol_Nr <= $DIC_VOLS_COUNT; $vol_Nr++) {

					$dbh->disconnect();

				}
			}
		}
		
		if ($dicVol eq "${DIC_DESC}All") {
			$i = 1;
			$j = $DIC_VOLS_COUNT;
		}
		else {
			$i = substr($dicVol, 3, 1);
			$j = $i;
		}

		my $lisatud = 0;

		for ($i; $i <= $j; $i++) {
		
			$xmlFile = "__sr/${DIC_DESC}/${DIC_DESC}${i}.xml";

			if (open(XMLF, '<:utf8', $xmlFile)) {
	#			if (flock(XMLF, $lockType)) {
					$dicDOM = $dicparser->parse_file($xmlFile);
					$qryDOM = $ss->transform($dicDOM, vf => "'${DIC_DESC}${i}'");
	#				flock(XMLF, LOCK_UN);
					$nStatus = 1;
	#			}
				close(XMLF);
			}
			if ($nStatus) {
				$artsCount = $qryDOM->documentElement()->childNodes->size(); # <A> - de hulk (sr/A)
				$qrycount += $artsCount;
				$leide += $qryDOM->documentElement()->findnodes("A/l/t/*")->size();

				if ($artsCount > 0) {
					if ($artsCount == 1) {
						$dicVol = "${DIC_DESC}${i}"; # selle järgi sätitakse ka köidete loend vastavale köitele
						$qryguid = $qryDOM->documentElement()->childNodes->get_node(1)->findvalue('G');
						$qryart = $dicDOM->documentElement()->findnodes("${DICPR}:A[${DICPR}:G = '${qryguid}']")->get_node(1);
					}
					if ($lisatud < $MAX_PRINT_ARTS) {
						my $vahe = $artsCount;
						if ($artsCount + $lisatud > $MAX_PRINT_ARTS) {
							my $maxQryArtsXSLDom = $dicparser->parse_file('xsl/maxQryArts.xsl');
							my $ssMaxQryArts = $xslt->parse_stylesheet($maxQryArtsXSLDom);
							my $vahe = ($MAX_PRINT_ARTS - $lisatud);
							$qryDOM = $ssMaxQryArts->transform($qryDOM, maxNr => "'${vahe}'");
						}
						# outDOM/sr/A
						# mitu sr - i, $qryDOM - i mitte puutuda
						$outDOM->documentElement()->appendChild($outDOM->importNode($qryDOM->documentElement()));
						$lisatud += $vahe;
					}
				}
			}
			else {
				last;
			}
		} # for ($i; $i <= $j; $i++) {
		
		if ($nStatus) {
			# $qrycount = nrEtSepr($qrycount);
			# $leide = nrEtSepr($leide);

			$rsp_count_node->appendTextNode($qrycount);
			$rsp_status_node->appendTextNode("Success");

			# $outDOM->documentElement()->setAttribute("qfID", $queryFileID);
			$outDOM->documentElement()->setAttribute("qinfo", $qinfo);
			$outDOM->documentElement()->setAttribute("leide", $leide);

			if ($qrycount == 1) {
				$rsp_vol_node->appendTextNode($dicVol); # selle järgi sätitakse ka köidete loend vastavale köitele
				if (index($dicsParinguLisad, ";${DIC_DESC};") > -1) {
					$qryart = &paneLisadXml_PSV($qryart);
				}
				$responseDOM->documentElement()->appendChild($responseDOM->importNode($qryart));
			}
			elsif ($qrycount > 1) {
				# 4. veeb 12: senine query.xsl
				# ety: mansi keeleplokid - 83 KB
				# query2.xsl (alla tuleb xml, mitte html) - 79 KB
				# $outDOM->toFile("temp/${queryFileID}.xml", 0);
				my $brInfoDom = $dicparser->parse_string($browseInfoStr);
				$outDOM->documentElement()->appendChild($brInfoDom->documentElement());
				$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));
			}
		}
		else {
	#		$rsp_status_node->appendTextNode("Failed to open/flock '${xmlFile}' (${cmdId})!");
			$rsp_status_node->appendTextNode("Failed to open '${xmlFile}' (${cmdId})!");
		}
	}
}
elsif (($cmdId eq "ClientWrite") && $nEditAllowed) {

	my $srLang = $rootLang;
	my ($vNr, $vanaA);
	my ($fh, $xmlFile, $backupFile);

	$vNr = substr($dicVol, 3, 1);

	my ($vanaT, $vanaTA, $vanaO, $uusA, $uusT, $uusTA, $uusO);

	$uusA = $prmDOM->documentElement()->findnodes("${DICPR}:A")->get_node(1);
	$uusA->setNamespace($DICURI, $DICPR, 0);
	my $artDom = XML::LibXML::Document->createDocument( "1.0", "UTF-8" );
	$artDom->setDocumentElement($artDom->importNode( $uusA->cloneNode(1) ));

# LibXML schema ja validate annavad ka siis vea, kui @xml:lang='mhr' (mari) !!
# goto ClientWrite_alustus;

	my ($schema, $valErr);
	eval { $schema = XML::LibXML::Schema->new( location => "xsd/schema_${DIC_DESC}.xsd" ) };
	if ($schema) {
		eval { $schema->validate($artDom) };
		# die $@ if $@;

		if ($@) {
			$rsp_count_node->appendTextNode('0');
			$valErr = decode_utf8($@);
			# veateates võib olla reavahetusi, mis logifaili p...e keerab
			$valErr =~ s/\s+/ /g;
			$rsp_status_node->appendTextNode($valErr);
			goto saveXmlValidateError;
		}
	}
	else {
		$rsp_count_node->appendTextNode('0');
		$valErr = decode_utf8($@);
		# veateates võib olla reavahetusi, mis logifaili p...e keerab
		$valErr =~ s/\s+/ /g;
		$rsp_status_node->appendTextNode($valErr);
		goto saveXmlValidateError;
	}

# ClientWrite_alustus:
# - algus
	if ($qryMethod eq 'MySql') {
		$dbh = DBI->connect("DBI:mysql:database=${mySqlDbName};mysql_enable_utf8=1;host=${mysql_ip}",
							 $mysql_user, $mysql_pass,
							 {'RaiseError' => 0, AutoCommit => 1});
		my $sth = $dbh->prepare("SELECT ${DIC_DESC}.art AS art FROM ${DIC_DESC} WHERE ${DIC_DESC}.G = '${artG}'");
		$sth->execute();
		my $artCnt = $sth->rows;
		if ($artCnt == 1) {
			if (my $ref = $sth->fetchrow_hashref()) {
				$vanaA = $dicparser->parse_string($ref->{'art'})->documentElement();
				if ($ainultMySql) {
					$nStatus = 2;
				}
				else {
					$nStatus = 1;
				}
			}
		}
		else {
			$rsp_status_node->appendTextNode("Failed on select ... where G = '${artG}' (${artCnt} tk) (${cmdId})!");
		}
		$sth->finish();
	}
	else {
		$nStatus = 1;
	}
	
	if ($nStatus == 1) {
		$xmlFile = "__sr/${DIC_DESC}/${dicVol}.xml";
		$backupFile = "backup/${dicVol}.xml";
		my $nodes;
		if (open($fh, '+<:utf8', $xmlFile)) {
			if (flock($fh, $lockType)) {
				$dicDOM = $dicparser->parse_file($xmlFile);
				$nodes = $dicDOM->documentElement()->findnodes("${DICPR}:A[${DICPR}:G = '${artG}']");
				if ($nodes->size() == 1) {
					$vanaA = $nodes->get_node(1);
					$nStatus = 2;
				}
				else {
					$rsp_status_node->appendTextNode("Failed on 'findnodes(G = ${artG})' (" . $nodes->size() . " tk) (${cmdId})!");
				}
			}
			else {
				$rsp_status_node->appendTextNode("Failed to flock '${xmlFile}' (${cmdId})!");
			}
		}
		else {
			$rsp_status_node->appendTextNode("Failed to open '${xmlFile}' (${cmdId})!");
		}
	}


	#vanaA on nüüd käes
	if ($nStatus == 2) {

		$vanaT = $vanaA->findvalue("${DICPR}:T");
		$vanaTA = $vanaA->findvalue("${DICPR}:TA");
		$vanaO = $vanaA->findvalue("${fdArt}/\@${DICPR}:O");

		$uusA = $prmDOM->documentElement()->findnodes("${DICPR}:A")->get_node(1);
		$uusT = $uusA->findvalue("${DICPR}:T");
		$uusTA = $uusA->findvalue("${DICPR}:TA");
		$uusO = $uusA->findvalue("${fdArt}/\@${DICPR}:O");
		
		if ($uusTA eq $vanaTA) {
			$nStatus = 3;
		}
		else { #nt 'Undo' korral ei ole ajad võrdsed
			if ($uusT eq $vanaT) {
				$nStatus = 3;
			}
			else {
				$rsp_status_node->appendTextNode("Serveris on artiklist olemas juba uuem versioon (${cmdId})!");
			}
		}
	}

	#võib nüüd salvestada - kui vaja, andmed käes ja ei ole vahepeal keegi üle kirjutanud
	my $sth;
	if ($nStatus == 3) {

		my $m1Elem = $uusA->findnodes("${fdArt}")->get_node(1);
		$opMs = $m1Elem->textContent;
		foreach my $attNode ($m1Elem->attributes()) {
			if ($attNode->localname ne 'O') {
				$opAttrs .= " \@" . $attNode->nodeName . "='" . $attNode->textContent . "'";
			}
		}
		$opAttrs = substr($opAttrs, 1);

		my $refNode;
		my $toimetajaNode = $uusA->findnodes("${DICPR}:T")->get_node(1);
		unless ($toimetajaNode) {
			$refNode = $uusA->findnodes("${DICPR}:TA | ${DICPR}:TL | ${DICPR}:PT | ${DICPR}:PTA | ${DICPR}:X | ${DICPR}:XA")->get_node(1);
			$toimetajaNode = $uusA->insertBefore($prmDOM->createElement("${DICPR}:T"), $refNode);
			$toimetajaNode->appendTextNode('-');
		}
		$toimetajaNode->firstChild->setData($usrName);
		my $tkpNode = $uusA->findnodes("${DICPR}:TA")->get_node(1);
		unless ($tkpNode) {
			$refNode = $uusA->findnodes("${DICPR}:TL | ${DICPR}:PT | ${DICPR}:PTA | ${DICPR}:X | ${DICPR}:XA")->get_node(1);
			$tkpNode = $uusA->insertBefore($prmDOM->createElement("${DICPR}:TA"), $refNode);
			$tkpNode->appendTextNode('-');
		}
		$tkpNode->firstChild->setData($nowdtstr);

		&valmistaSortXsl();

		my $notUniqueNodesCnt = 0;

		if ($qryMethod eq 'MySql') {

			# elemendid/atribuudid tabelid
			use Data::GUID;

			my ($md, $mTekstid, $TA, $ms_lang, $ms_nos, $rcnt, $ms_att_OO);
			$md = '';

			if ($uusO ne $vanaO) {
				if ($mustBeUnique) {
					#  AND ${DIC_DESC}.G != '${artG}'
					$sth = $dbh->prepare("SELECT * FROM ${DIC_DESC} WHERE ${DIC_DESC}.vol_nr = ${vNr} AND ${DIC_DESC}.ms_att_O = BINARY '${uusO}' AND ${DIC_DESC}.G != '${artG}'");
					$sth->execute();
					$notUniqueNodesCnt = $sth->rows;
					$sth->finish();
				}
				if ($notUniqueNodesCnt > 0) {
					goto salvestamiselMitteUnikaalne;
				}
			}
			
			$dbh->begin_work; #AutoCommit
			
			my $delCmd = "DELETE FROM msid WHERE dic_code = '${DIC_DESC}' AND G = '${artG}'";
			$sth = $dbh->prepare($delCmd);
			$rcnt = $sth->execute();
			if ($rcnt > 0) {
				# märksõnad globaalselt; VSL-is on nt märksõnad ka nn allartiklis <AA>
				foreach my $mElem ($uusA->findnodes(".//${qn_ms}")) {
					$mTekstid = '';
					foreach my $mText ($mElem->findnodes('text()')) {
						$mTekstid .= $mText->toString; #nt textContent - '&amp;' -> '&', aga md salvestada XML moodi
					}
					$ms_lang = $mElem->getAttribute('xml:lang');
					unless ($ms_lang) {
						$ms_lang = $srLang;
					}
					
					my $insCmd = "INSERT INTO MSID SET ";
					foreach my $attNode ($mElem->attributes()) {
						unless ($attNode->nodeName eq 'xml:lang') {
							#NB: siin 'textContent'
							$insCmd .= "ms_att_" . $attNode->localname . " = '" . $attNode->textContent . "', ";
						}
					}
					if ($fakOlemas) {
						if (index($mTekstid, substr($fakOlemas, 0, 1)) > -1 && index($mTekstid, substr($fakOlemas, 1, 1)) > -1) {
							my $fakOsata = $mTekstid;
							$fakOsata =~ s/$fakOsataPtrn//g; #sulud ja tema sees olev maha
							# &amp; , muutujad + mittetähed , tõlkimine
							$fakOsata = teeMs_nosKuju($fakOsata);
							$insCmd .= "ms_nos_alt = '${fakOsata}', ";
						}
					}
					$ms_att_OO = translate_ms_att_O($mElem->getAttribute("${DICPR}:O"));
					# &amp; , muutujad + mittetähed , tõlkimine
					$ms_nos = teeMs_nosKuju($mTekstid);
					$insCmd .= "ms_att_OO = '${ms_att_OO}', 
								ms_lang = '${ms_lang}', 
								dic_code = '${DIC_DESC}', 
								vol_nr = ${vNr}, 
								ms = " . $dbh->quote($mTekstid) . " , 
								ms_nos = '${ms_nos}', 
								G = '${artG}'";
					$insCmd =~ s/\s+/ /g;
					$sth = $dbh->prepare($insCmd);
					$rcnt = $sth->execute();
					unless ($rcnt == 1) {
						$rsp_status_node->appendTextNode($sth->errstr . ' :: ' . $insCmd);
						$dbh->rollback;
						last;
					}
					if ($md) {
						$md .= ' :: ';
					}
					$md .= $mTekstid;
				}
				
				if ($rcnt == 1) {
					$TA = $nowdtstr;
					$TA =~ s/T/ /g;

					# 'uusO' on artikli esimese märksõna 'O'
					$ms_att_OO = translate_ms_att_O($uusO);

					my $updCmd = "UPDATE ${DIC_DESC} SET md = " . $dbh->quote($md) . ", ms_att_O = '${uusO}', ms_att_OO = '${ms_att_OO}'";

					# koostamise lõpu märkimise juures muutub ka koostaja <K>
					my $K = $uusA->findvalue("${DICPR}:K");
					if ($K) {
						$updCmd .= ", K = '${K}'";
					}
					else {
						$updCmd .= ", K = NULL";
					}
					my $KL = $uusA->findvalue("${DICPR}:KL");
					if ($KL) {
						$KL =~ s/T/ /g;
						$updCmd .= ", KL = '${KL}'";
					}
					else {
						$updCmd .= ", KL = NULL";
					}
					$updCmd .= ", T = '${usrName}', TA = '${TA}'";
					my $TL = $uusA->findvalue("${DICPR}:TL");
					if ($TL) {
						$TL =~ s/T/ /g;
						$updCmd .= ", TL = '${TL}'";
					}
					else {
						$updCmd .= ", TL = NULL";
					}
					my $PT = $uusA->findvalue("${DICPR}:PT");
					if ($PT) {
						$updCmd .= ", PT = '${PT}'";
					}
					else {
						$updCmd .= ", PT = NULL";
					}
					my $PTA = $uusA->findvalue("${DICPR}:PTA");
					if ($PTA) {
						$PTA =~ s/T/ /g;
						$updCmd .= ", PTA = '${PTA}'";
					}
					else {
						$updCmd .= ", PTA = NULL";
					}
					if ($ainultMySql) {
						$updCmd .= ", toXml = 1";
					}
					my $uusXml = $uusA->toString;
					my $artKoopiaDom = XML::LibXML::Document->createDocument( "1.0", "UTF-8" );
					$artKoopiaDom->setDocumentElement($artKoopiaDom->importNode( $uusA->cloneNode(1) ));
					my $uusAKoopia = $artKoopiaDom->documentElement();
					foreach my $tekst ($uusAKoopia->findnodes(".//text()")) {
						my $juhhei = $tekst->toString;
						# &amp; , muutujad + mittetähed , tõlkimine
						$juhhei = teeMs_nosKuju($juhhei);
						$tekst->setData($juhhei);
					}
					my $uusAltXml = $uusAKoopia->toString;
					$updCmd .= ", art = " . $dbh->quote($uusXml) . ", art_alt = " . $dbh->quote($uusAltXml);

					my $sthColInfo = $dbh->prepare("SHOW FULL COLUMNS FROM ${DIC_DESC} WHERE field = 'hasHtml'");
					my $colInfoCount = $sthColInfo->execute();
					if ($colInfoCount == 1) {
						$updCmd .= ", hasHtml = ${artHasHtml}, brVer = " . $dbh->quote($artBrVer);
						if ($artHasHtml eq '1') {
							if ($artHtml) {
								$updCmd .= ", art_html = " . $dbh->quote($artHtml);
							}
						}
					}

					$updCmd .= " WHERE ${DIC_DESC}.G = '${artG}'";
					$updCmd =~ s/\s+/ /g;
					
					$sth = $dbh->prepare($updCmd);
					$rcnt = $sth->execute();

					if ($rcnt == 1) {

						my $lisaViga = 0;

						if ($mySqlDataVer eq '2') {
							$delCmd = "DELETE FROM elemendid_${DIC_DESC} WHERE G = '${artG}'";
							$sth = $dbh->prepare($delCmd);
							$rcnt = $sth->execute();

# järgnevat pole vaja seetõttu, et võibolla on osadel sõnastikel 'elemendid/atribuudid' tabelid täitmata
#							if ($rcnt > 0) {
								$delCmd = "DELETE FROM atribuudid_${DIC_DESC} WHERE G = '${artG}'";
								$sth = $dbh->prepare($delCmd);
								$rcnt = $sth->execute();

#								if ($rcnt > 0) {
									my $bulkElCmd = '';
									my $bulkAttCmd = '';

									my $mitteElemendid = "õ";
									foreach my $el ($uusA->findnodes("descendant::*[text()]")) {
										unless ((';' . $el->localname . ';') =~ /$mitteElemendid/) {
											my $val = '';
											foreach my $elText ($el->findnodes('text()')) {
												$val .= $elText->toString; #nt textContent: '&amp;' -> '&', aga salvestada kõik XML kujul
											}
											my $val_nos = teeMs_nosKuju($val);
											my $rada = teeLihtRada($el);
											my $nimi = $el->nodeName;
											my $elG = Data::GUID->new();

											$bulkElCmd .= ',(' . $dbh->quote($elG) . ',' . $dbh->quote($nimi) . ',' . $dbh->quote($rada) . ',' . $dbh->quote($val) . ',' . $dbh->quote($val_nos) . ',' . $dbh->quote($artG) . ')';

											foreach my $elAtt ($el->attributes()) {
												unless ($elAtt->prefix eq 'xmlns' || $elAtt->localname eq 'O') {
													# siin "textContent", atribuudid on enamasti valikuga ja neis pole nt HTML muutujaid
													my $elAttVal = $elAtt->textContent; # atribuutide korral annab toString: p:i="1", aga ka raha märk '¤' läheb &xA4;
													my $elAttVal_nos = teeMs_nosKuju($elAttVal);
													my $elAttNimi = $elAtt->nodeName;

													$bulkAttCmd .= ',(' . $dbh->quote($elG) . ',' . $dbh->quote($elAttNimi) . ',' . $dbh->quote($nimi) . ',' . $dbh->quote($elAttVal) . ',' . $dbh->quote($elAttVal_nos) . ',' . $dbh->quote($artG) . ')';
												}
											}
										}
									} # foreach el
#									$dbh->do("SET unique_checks = 0");

									$bulkElCmd = "INSERT INTO elemendid_${DIC_DESC} (elG, nimi, rada, val, val_nos, G) VALUES " . substr($bulkElCmd, 1);
									$rcnt = $dbh->do($bulkElCmd);
									if ($rcnt < 1) {
										$rsp_status_node->appendTextNode($dbh->errstr . ' :: ' . substr($bulkElCmd, 0, 1024) . ' ...');
										$lisaViga = 5;
									}

									if ($bulkAttCmd) {
										$bulkAttCmd = "INSERT INTO atribuudid_${DIC_DESC} (elG, nimi, elNimi, val, val_nos, G) VALUES " . substr($bulkAttCmd, 1);
										$rcnt = $dbh->do($bulkAttCmd);
										if ($rcnt < 1) {
											$rsp_status_node->appendTextNode($dbh->errstr . ' :: ' . substr($bulkAttCmd, 0, 1024) . ' ...');
											$lisaViga = 6;
										}
									}
#									$dbh->do("SET unique_checks = 1");
#								}
#								else {
#									$rsp_status_node->appendTextNode($sth->errstr . ' :: ' . $delCmd);
#									$lisaViga = 2;
#								}
#							}
#							else {
#								$rsp_status_node->appendTextNode($sth->errstr . ' :: ' . $delCmd);
#								$lisaViga = 1;
#							}
						}
						if ($lisaViga == 0) {
							$dbh->commit;
							&mySqlTimestamp();
							$nStatus = 4;
						}
						else {
							$dbh->rollback;
						}
					}
					else {
						$rsp_status_node->appendTextNode($sth->errstr . ' :: ' . $updCmd);
						$dbh->rollback;
					}
				}
			}
			else {
				$rsp_status_node->appendTextNode($sth->errstr . ' :: ' . $delCmd);
				$dbh->rollback;
			}
		} # if ($qryMethod eq 'MySql') {
		else {
			# aga XML puhul on veel unikaalsus kindlaks tegemata
			if ($vanaO ne $uusO) {
				if ($mustBeUnique) {
					# kui märksõnad tõstetakse lihtsalt ümber (eelistermin sünonüümiks v vastupidi), siis mis muutub?
					$notUniqueNodesCnt = $dicDOM->documentElement()->findnodes("${DICPR}:A[${dqArt}/\@${DICPR}:O[. = '${uusO}']][${DICPR}:G != '${artG}']")->size();
				}
				if ($notUniqueNodesCnt == 0) {
					$nStatus = 4;
				}
				else {

salvestamiselMitteUnikaalne:
					$rsp_status_node->appendTextNode($lcDom->documentElement()->findvalue("itm[\@n = 'HW_HOM_COMBINATION'][\@l = '${APP_LANG}']") . " (${fSrchPtrn}) (${cmdId})!");
				}
			}
			else {
				$nStatus = 4;
			}
		}

		#'dic_code' tabelis on 'ms_att_O' unikaalne, XML failis on 'O' unikaalne
		if ($nStatus == 4) {
			if ($ainultMySql) {
				$nStatus = 5;
			}
			else {
				# XML-i tuleb salvestada paralleelselt MySql-iga ...
				$dicDOM->documentElement()->replaceChild($dicDOM->importNode($uusA), $vanaA);
				if ($vanaO ne $uusO) {
					my $ss = $xslt->parse_stylesheet($sortXSL);
					$dicDOM = $ss->transform($dicDOM);
				}
	#			if ($dicDOM->toFile($backupFile, 0)) {
	# Win32 all on iga thread omaette protsess, seepärast lock vabastada LibXML-le, muidu ei pääse ligi
					if ($^O eq 'MSWin32') {
						flock($fh, LOCK_UN);
					}
					if ($dicDOM->toFile($xmlFile, 0)) {
						$nStatus = 5;
					}
					else {
						$rsp_status_node->appendTextNode("Server error writing '${xmlFile}' file (${cmdId})! See admin!");
					}
	#			}
	#			else {
	#				$rsp_status_node->appendTextNode("Server error writing backup '${backupFile}' file (${cmdId})! Try again!");
	#			}
			}
		}
	}

	#nüüd võib lõpetada. Kõik on salvestatud
	my $leide;
	if ($nStatus == 5) {
		if ($art_xpath) { #homonüümsed
			if ($qryMethod eq 'MySql') {
				$sth = $dbh->prepare($sql);
				$sth->execute();

				my $respStr = '<sr>';
				$leide = $sth->rows;
				$respStr .= teeXMLStr($sth, '');
				$respStr .= "</sr>";
				$qryDOM = $dicparser->parse_string($respStr);
				# artsCount tuleb 'teeXMLStr'
			}
			else {
				# art_xpath - "homonüümsete kontroll":  DICPR & ":A[" & elm_xpath & "]"
				# elm_xpath - "arttingimus": m[ sOrgMarkSona (or sMarkSona)]
				$xslnode = $queryXSL->documentElement()->findnodes("xsl:template[\@match = 'al:sr']/sr/xsl:apply-templates")->get_node(1);
				$xslnode->setAttribute("select", $art_xpath);
				$xslnode = $queryXSL->documentElement()->findnodes("xsl:template[\@match = 'al:A']/A/l/t/xsl:for-each")->get_node(1);
				$xslnode->setAttribute("select", $elm_xpath);
				my $ss = $xslt->parse_stylesheet($queryXSL);
				$qryDOM = $ss->transform($dicDOM, vf => "'${dicVol}'");
				$artsCount = $qryDOM->documentElement()->childNodes->size();
				$leide = $qryDOM->documentElement()->findnodes("A/l/t/span[\@class = '_b'][\@nr]")->size();
			}
		}
		else {
			$artsCount = 1;
		}
	}

	if ($fh) {
		flock($fh, LOCK_UN);
		close($fh);
	}

	$rsp_vol_node->appendTextNode($dicVol);
	if ($nStatus == 5) {

		$rsp_count_node->appendTextNode($artsCount);
		$rsp_status_node->appendTextNode("Success");

		if ($artsCount == 1) {
			$responseDOM->documentElement()->appendChild($responseDOM->importNode($uusA));
		}
		# hom-de kontrollil läks midagi metsa
		elsif ($artsCount == 0) {
			$responseDOM->documentElement()->appendChild($responseDOM->importNode($uusA));
		}
		else {
			# $outDOM->documentElement()->setAttribute("qfID", $queryFileID);
			$outDOM->documentElement()->setAttribute("qinfo", $lcDom->documentElement()->findvalue("itm[\@n = 'CHECK_HOMS'][\@l = '${APP_LANG}']") . ": '${opMs}'");
			$outDOM->documentElement()->setAttribute("leide", $leide);
			$outDOM->documentElement()->appendChild($outDOM->importNode($qryDOM->documentElement()));
			my $brInfoDom = $dicparser->parse_string($browseInfoStr);
			$outDOM->documentElement()->appendChild($outDOM->importNode($brInfoDom->documentElement()));
			# $outDOM->toFile("temp/${queryFileID}.xml", 0);
			$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));
		}
	}
	else {
		$rsp_count_node->appendTextNode('0');
	}

# - lõpetamine
	if ($qryMethod eq 'MySql') {
		$dbh->disconnect();
	}

saveXmlValidateError:

}
elsif (($cmdId eq "ClientAdd") && $nEditAllowed) {

	my ($fh, $xmlFile, $backupFile);
	my $xmlFile = "__sr/${DIC_DESC}/${dicVol}.xml";
	my $backupFile = "backup/${dicVol}.xml";

	my $srLang = $rootLang;
	my $sth;

	if ($qryMethod eq 'MySql') {
		$dbh = DBI->connect("DBI:mysql:database=${mySqlDbName};mysql_enable_utf8=1;host=${mysql_ip}",
							 $mysql_user, $mysql_pass,
							 {'RaiseError' => 0, AutoCommit => 1});
		if ($dbh) {
			if ($ainultMySql) {
				$nStatus = 3;
			}
			else {
				$nStatus = 1;
			}
		}
		else {
			$rsp_status_node->appendTextNode($DBI::errstr . " :: Failed to connect to '${mySqlDbName}' (${cmdId})");
		}
	}
	else {
		$nStatus = 1;
	}

	if ($nStatus == 1) {
		if (open($fh, '+<:utf8', $xmlFile)) {
			if (flock($fh, $lockType)) {
				$dicDOM = $dicparser->parse_file($xmlFile);
				$srLang = $dicDOM->documentElement()->getAttribute('xml:lang');
				$nStatus = 3;
			}
			else {
				$rsp_status_node->appendTextNode("Failed to flock '${xmlFile}' (${cmdId})!");
			}
		}
		else {
			$rsp_status_node->appendTextNode("Failed to open '${xmlFile}' (${cmdId})!");
		}
	}

# - algus
	#võib nüüd salvestada - kui vaja

	my ($uusA, $uusT, $uusTA, $uusO, $vNr);

	$vNr = substr($dicVol, 3, 1);

	if ($nStatus == 3) {
		use Data::GUID;
		my $newGuid = Data::GUID->new();

		$uusA = $prmDOM->documentElement()->findnodes("${DICPR}:A")->get_node(1);
		$uusT = $uusA->findvalue("${DICPR}:T");
		$uusTA = $uusA->findvalue("${DICPR}:TA");
		$uusO = $uusA->findvalue("${fdArt}/\@${DICPR}:O");

		my $m1Elem = $uusA->findnodes("${fdArt}")->get_node(1);
		$opMs = $m1Elem->textContent;
		foreach my $attNode ($m1Elem->attributes()) {
			if ($attNode->localname ne 'O') {
				$opAttrs .= " \@" . $attNode->nodeName . "='" . $attNode->textContent . "'";
			}
		}
		$opAttrs = substr($opAttrs, 1);

		my $guidNode = $uusA->findnodes("${DICPR}:G")->get_node(1);
		$guidNode->firstChild->setData($newGuid);
		my $autornode = $uusA->findnodes("${DICPR}:K")->get_node(1);
		$autornode->firstChild->setData($usrName);
		my $akpnode = $uusA->findnodes("${DICPR}:KA")->get_node(1);
		$akpnode->firstChild->setData($nowdtstr);
		my $toimetajanode = $uusA->findnodes("${DICPR}:T")->get_node(1);
		$toimetajanode->firstChild->setData($usrName);
		my $tkpnode = $uusA->findnodes("${DICPR}:TA")->get_node(1);
		$tkpnode->firstChild->setData($nowdtstr);

		&valmistaSortXsl();

		my $notUniqueNodesCnt = 0;

		if ($qryMethod eq 'MySql') {
			my ($md, $mTekstid, $TA, $ms_lang, $ms_nos, $rcnt, $ms_att_OO);
			$md = '';

			if ($mustBeUnique) {
				$sth = $dbh->prepare("SELECT * FROM ${DIC_DESC} WHERE ${DIC_DESC}.vol_nr = ${vNr} AND ${DIC_DESC}.ms_att_O = BINARY '${uusO}'");
				$sth->execute();
				$notUniqueNodesCnt = $sth->rows;
				$sth->finish();
			}
			if ($notUniqueNodesCnt > 0) {
				goto lisamiselMitteUnikaalne;
			}

			$dbh->begin_work; # autocommit == 0
			
			# märksõnad globaalselt; VSL-is on nt märksõnad ka nn allartiklis <AA>
			foreach my $mElem ($uusA->findnodes(".//${qn_ms}")) {
				$mTekstid = '';
				foreach my $mText ($mElem->findnodes('text()')) {
					$mTekstid .= $mText->toString;
				}
				$ms_lang = $mElem->getAttribute('xml:lang');
				unless ($ms_lang) {
					$ms_lang = $srLang;
				}

				my $insCmd = "INSERT INTO MSID SET ";
				foreach my $attNode ($mElem->attributes()) {
					unless ($attNode->nodeName eq 'xml:lang') {
						#NB: siin 'textContent'
						$insCmd .= "ms_att_" . $attNode->localname . " = '" . $attNode->textContent . "', ";
					}
				}
				if ($fakOlemas) {
					if (index($mTekstid, substr($fakOlemas, 0, 1)) > -1 && index($mTekstid, substr($fakOlemas, 1, 1)) > -1) {
						my $fakOsata = $mTekstid;
						$fakOsata =~ s/$fakOsataPtrn//g; #sulud ja tema sees olev maha
						# &amp; , mittetähed , tõlkimine
						$fakOsata = teeMs_nosKuju($fakOsata);
						$insCmd .= "ms_nos_alt = '${fakOsata}', ";
					}
				}
				$ms_att_OO = translate_ms_att_O($mElem->getAttribute("${DICPR}:O"));
				# &amp; , mittetähed , tõlkimine
				$ms_nos = teeMs_nosKuju($mTekstid);
				$insCmd .= "ms_att_OO = '${ms_att_OO}', 
							ms_lang = '${ms_lang}', 
							dic_code = '${DIC_DESC}', 
							vol_nr = ${vNr}, 
							ms = " . $dbh->quote($mTekstid) . " , 
							ms_nos = '${ms_nos}', 
							G = '${newGuid}'";
				$insCmd =~ s/\s+/ /g;
				$sth = $dbh->prepare($insCmd);
				$rcnt = $sth->execute();
				unless ($rcnt == 1) {
					$rsp_status_node->appendTextNode($sth->errstr . ' :: ' . $insCmd);
					$dbh->rollback;
					last;
				}
				if ($md) {
					$md .= ' :: ';
				}
				$md .= $mTekstid;
			} #foreach my $mElem
			
			if ($rcnt == 1) {
				$TA = $nowdtstr;
				$TA =~ s/T/ /g;

				$ms_att_OO = &translate_ms_att_O($uusO);
				my $uusXml = $uusA->toString;
				my $artKoopiaDom = XML::LibXML::Document->createDocument( "1.0", "UTF-8" );
				$artKoopiaDom->setDocumentElement($artKoopiaDom->importNode( $uusA->cloneNode(1) ));
				my $uusAKoopia = $artKoopiaDom->documentElement();
				foreach my $tekst ($uusAKoopia->findnodes(".//text()")) {
					my $juhhei = $tekst->toString;
					$juhhei = teeMs_nosKuju($juhhei);
					$tekst->setData($juhhei);
				}
				my $uusAltXml = $uusAKoopia->toString;

				my $ins2Cmd = "INSERT INTO ${DIC_DESC} SET md = " . $dbh->quote($md) . ", 
													ms_att_O = '${uusO}', 
													ms_att_OO = '${ms_att_OO}', 
													K = '${usrName}', 
													KA = '${TA}', 
													T = '${usrName}', 
													TA = '${TA}', 
													art = " . $dbh->quote($uusXml) . ", 
													art_alt = " . $dbh->quote($uusAltXml) . ", 
													vol_nr = ${vNr}, 
													G = '${newGuid}'";

				if ($ainultMySql) {
					$ins2Cmd .= ", toXml = 1";
				}

				my $sthColInfo = $dbh->prepare("SHOW FULL COLUMNS FROM ${DIC_DESC} WHERE field = 'hasHtml'");
				my $colInfoCount = $sthColInfo->execute();
				if ($colInfoCount == 1) {
					$ins2Cmd .= ", hasHtml = ${artHasHtml}, brVer = " . $dbh->quote($artBrVer);
					if ($artHasHtml eq '1') {
						if ($artHtml) {
							$ins2Cmd .= ", art_html = " . $dbh->quote($artHtml);
						}
					}
				}

				$ins2Cmd =~ s/\s+/ /g;

				$sth = $dbh->prepare($ins2Cmd);
				$rcnt = $sth->execute();
				if ($rcnt == 1) {
					$dbh->commit;
					&mySqlTimestamp();
					$nStatus = 4;
				}
				else {
					$rsp_status_node->appendTextNode($sth->errstr . ' :: ' . $ins2Cmd);
					$dbh->rollback;
				}
			} #if ($rcnt == 1) {
		} #if ($qryMethod eq 'MySql') {
		else {
			# aga XML puhul on veel unikaalsus kindlaks tegemata
			if ($mustBeUnique) {
				$notUniqueNodesCnt = $dicDOM->documentElement()->findnodes("${DICPR}:A[${dqArt}/\@${DICPR}:O[. = '${uusO}']]")->size();
			}
			if ($notUniqueNodesCnt == 0) {
				$nStatus = 4;
			}
			else {

lisamiselMitteUnikaalne:
				$rsp_status_node->appendTextNode($lcDom->documentElement()->findvalue("itm[\@n = 'HW_HOM_COMBINATION'][\@l = '${APP_LANG}']") . " (${fSrchPtrn}) (${cmdId})!");
			}
		}
		#'dic_code' tabelis on 'ms_att_O' unikaalne, XML failis on 'O' unikaalne
		if ($nStatus == 4) {
			if ($ainultMySql) {
				$nStatus = 5;
			}
			else {
				# XML-i tuleb salvestada paralleelselt MySql-iga ...
				$dicDOM->documentElement()->appendChild($dicDOM->importNode($uusA));
				my $ss = $xslt->parse_stylesheet($sortXSL);
				$dicDOM = $ss->transform($dicDOM);
#				if ($dicDOM->toFile($backupFile, 0)) {
	# Win32 all on iga thread omaette protsess, seepärast lock vabastada LibXML-le, muidu ei pääse ligi
					if ($^O eq 'MSWin32') {
						flock($fh, LOCK_UN);
					}
					if ($dicDOM->toFile($xmlFile, 0)) {
						$nStatus = 5;
					}
					else {
						$rsp_status_node->appendTextNode("Server error writing '${xmlFile}' file (${cmdId})! See admin!");
					}
#				}
#				else {
#					$rsp_status_node->appendTextNode("Server error writing backup '${backupFile}' file (${cmdId})! Try again!");
#				}
			}
		}
	} #if ($nStatus == 3) {

	#nüüd võib lõpetada. Kõik on salvestatud
	my $leide;
	if ($nStatus == 5) {
		if ($art_xpath) { #homonüümsed
			if ($qryMethod eq 'MySql') {
				$sth = $dbh->prepare($sql);
				$sth->execute();

				my $respStr = '<sr>';
				$leide = $sth->rows;
				$respStr .= teeXMLStr($sth, '');
				$respStr .= "</sr>";
				$qryDOM = $dicparser->parse_string($respStr);
			}
			else {
				# art_xpath - "homonüümsete kontroll":  DICPR & ":A[" & elm_xpath & "]"
				# elm_xpath - "arttingimus": m[ sOrgMarkSona (or sMarkSona)]
				$xslnode = $queryXSL->documentElement()->findnodes("xsl:template[\@match = 'al:sr']/sr/xsl:apply-templates")->get_node(1);
				$xslnode->setAttribute("select", $art_xpath);
				$xslnode = $queryXSL->documentElement()->findnodes("xsl:template[\@match = 'al:A']/A/l/t/xsl:for-each")->get_node(1);
				$xslnode->setAttribute("select", $elm_xpath);
				my $ss = $xslt->parse_stylesheet($queryXSL);
				$qryDOM = $ss->transform($dicDOM, vf => "'${dicVol}'");
				$artsCount = $qryDOM->documentElement()->childNodes->size();
				$leide = $qryDOM->documentElement()->findnodes("A/l/t/span[\@class = '_b'][\@nr]")->size();
			}
		}
		else {
			$artsCount = 1;
		}
	}

	if ($fh) {
		flock($fh, LOCK_UN);
		close($fh);
	}

	$rsp_vol_node->appendTextNode($dicVol);
	if ($nStatus == 5) {

		$rsp_count_node->appendTextNode($artsCount);
		$rsp_status_node->appendTextNode("Success");

		if ($artsCount == 1) {
			$responseDOM->documentElement()->appendChild($responseDOM->importNode($uusA));
		}
		else {
			# $outDOM->documentElement()->setAttribute("qfID", $queryFileID);
			$outDOM->documentElement()->setAttribute("qinfo", $lcDom->documentElement()->findvalue("itm[\@n = 'CHECK_HOMS'][\@l = '${APP_LANG}']") . ": '${opMs}'");
			$outDOM->documentElement()->setAttribute("leide", $leide);
			$outDOM->documentElement()->appendChild($outDOM->importNode($qryDOM->documentElement()));
			my $brInfoDom = $dicparser->parse_string($browseInfoStr);
			$outDOM->documentElement()->appendChild($outDOM->importNode($brInfoDom->documentElement()));
			# $outDOM->toFile("temp/${queryFileID}.xml", 0);
			$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));
		}
	}
	else {
		$rsp_count_node->appendTextNode('0');
	}

# - lõpetamine
	if ($qryMethod eq 'MySql') {
		$dbh->disconnect();
	}

}
elsif (($cmdId eq "ClientDelete") && $nEditAllowed) {

	my $sth;
	my $vanaA;
	my ($fh, $destFh, $xmlFile, $xmlBackupFile, $destFile, $destBackupFile, $destDOM);

# - algus
	if ($qryMethod eq 'MySql') {
		$dbh = DBI->connect("DBI:mysql:database=${mySqlDbName};mysql_enable_utf8=1;host=${mysql_ip}",
							 $mysql_user, $mysql_pass,
							 {'RaiseError' => 0, AutoCommit => 1});
		$sth = $dbh->prepare("SELECT ${DIC_DESC}.art AS art FROM ${DIC_DESC} WHERE ${DIC_DESC}.G = '${artG}'");
		$sth->execute();
		my $artCnt = $sth->rows;
		if ($artCnt == 1) {
			if (my $ref = $sth->fetchrow_hashref()) {
				$vanaA = $dicparser->parse_string(decode_utf8($ref->{'art'}))->documentElement();
				if ($ainultMySql) {
					$nStatus = 2;
				}
				else {
					$nStatus = 1;
				}
			}
		}
		else {
			$rsp_status_node->appendTextNode("Failed on select ... where G = '${artG}' (${artCnt} tk) (${cmdId})!");
		}
		$sth->finish();
	}
	else {
		$nStatus = 1;
	}

	if ($nStatus == 1) {

		$xmlFile = "__sr/${DIC_DESC}/${dicVol}.xml";
		$xmlBackupFile = "backup/${dicVol}.xml";
		if (open($fh, '+<:utf8', $xmlFile)) {
			if (flock($fh, $lockType)) {
				$dicDOM = $dicparser->parse_file($xmlFile);
				my $nodes = $dicDOM->documentElement()->findnodes("${DICPR}:A[${DICPR}:G = '${artG}']");
				if ($nodes->size() == 1) {
					$vanaA = $nodes->get_node(1);
					$destFile = "__sr/${DIC_DESC}/${destVol}.xml";
					$destBackupFile = "backup/${destVol}.xml";
					if (open($destFh, '+<:utf8', $destFile)) {
						if (flock($destFh, $lockType)) {
							$destDOM = $dicparser->parse_file($destFile);
							$nStatus = 2;
						}
						else {
							$rsp_status_node->appendTextNode("Failed to flock '${destFile}' ('destFile') (${cmdId})!");
						}
					}
					else {
						$rsp_status_node->appendTextNode("Failed to open '${destFile}' ('destFile') (${cmdId})!");
					}
				}
				else {
					$rsp_status_node->appendTextNode("Failed on 'findnodes(G = ${artG})' (" . $nodes->size() . " tk) (${cmdId})!");
				}
			}
			else {
				$rsp_status_node->appendTextNode("Failed to flock '${xmlFile}' ('xmlFile') (${cmdId})!");
			}
		}
		else {
			$rsp_status_node->appendTextNode("Failed to open '${xmlFile}' ('xmlFile') (${cmdId})!");
		}
	}
	
	#vanaA on nüüd käes
	my ($vanaT, $vanaTA, $vanaO);
	if ($nStatus == 2) {

		$vanaT = $vanaA->findvalue("${DICPR}:T");
		$vanaTA = $vanaA->findvalue("${DICPR}:TA");
		$vanaO = $vanaA->findvalue("${fdArt}/\@${DICPR}:O");

		$nStatus = 3;
	}
	
	my $dvNr = substr($destVol, 3, 1);

	#võib nüüd salvestada - kui vaja
	if ($nStatus == 3) {

		my $m1Elem = $vanaA->findnodes("${fdArt}")->get_node(1);
		$opMs = $m1Elem->textContent;
		foreach my $attNode ($m1Elem->attributes()) {
			if ($attNode->localname ne 'O') {
				$opAttrs .= " \@" . $attNode->nodeName . "='" . $attNode->textContent . "'";
			}
		}
		$opAttrs = substr($opAttrs, 1);

		my $refNode;
		my $xNode = $vanaA->findnodes("${DICPR}:X")->get_node(1);
		unless ($xNode) {
			$refNode = $vanaA->findnodes("${DICPR}:XA")->get_node(1);
			$xNode = $vanaA->insertBefore($prmDOM->createElement("${DICPR}:X"), $refNode);
			$xNode->appendTextNode('-');
		}
		$xNode->firstChild->setData($usrName);
		my $xaNode = $vanaA->findnodes("${DICPR}:XA")->get_node(1);
		unless ($xaNode) {
			# alati viimane element skeemis ...
			$xaNode = $vanaA->appendChild($prmDOM->createElement("${DICPR}:XA"));
			$xaNode->appendTextNode('-');
		}
		$xaNode->firstChild->setData($nowdtstr);
		$vanaA->setAttributeNS($DICURI, 'KF', $dicVol);

		&valmistaSortXsl();

		if ($qryMethod eq 'MySql') {
			my ($rcnt, $TA);
			$dbh->begin_work;
			my $updCmd = "UPDATE msid SET vol_nr = ${dvNr} WHERE dic_code = '${DIC_DESC}' AND G = '${artG}'";
			$sth = $dbh->prepare($updCmd);
			$rcnt = $sth->execute();
			if ($rcnt > 0) {
				$TA = $nowdtstr;
				$TA =~ s/T/ /g;

				# et MySql - i ikka korrenktne XML salvestuks
				$vanaA->setNamespace($DICURI, $DICPR, 0);
				my $vanaXml = $vanaA->toString;

				my $artKoopiaDom = XML::LibXML::Document->createDocument( "1.0", "UTF-8" );
				$artKoopiaDom->setDocumentElement($artKoopiaDom->importNode( $vanaA->cloneNode(1) ));
				my $vanaAKoopia = $artKoopiaDom->documentElement();
				foreach my $tekst ($vanaAKoopia->findnodes(".//text()")) {
					my $juhhei = $tekst->toString;
					# &amp; , muutujad + mittetähed , tõlkimine
					$juhhei = teeMs_nosKuju($juhhei);
					$tekst->setData($juhhei);
				}
				my $vanaAltXml = $vanaAKoopia->toString;

				$updCmd = "UPDATE ${DIC_DESC} SET vol_nr = ${dvNr}, X = '${usrName}', XA = '${TA}', art = " . $dbh->quote($vanaXml) . ", art_alt = " . $dbh->quote($vanaAltXml);
				if ($ainultMySql) {
					$updCmd .= ", toXml = 1";
				}
				$updCmd .= " WHERE ${DIC_DESC}.G = '${artG}'";
				$updCmd =~ s/\s+/ /g;
				
				$sth = $dbh->prepare($updCmd);
				$rcnt = $sth->execute();
				if ($rcnt == 1) {
					$dbh->commit;
					&mySqlTimestamp();
					$nStatus = 4;
				}
				else {
					$rsp_status_node->appendTextNode($sth->errstr . ' :: ' . $updCmd);
					$dbh->rollback;
				}
			}
			else {
				$rsp_status_node->appendTextNode($sth->errstr . ' :: ' . $updCmd);
				$dbh->rollback;
			}
		}
		else {
			# XML-i tuleb salvestada paralleelselt MySql-iga ...
			$nStatus = 4;
		}
		if ($nStatus == 4) {
			if ($ainultMySql) {
				$nStatus = 5;
			}
			else {
				$destDOM->documentElement()->appendChild($vanaA);
				my $ss = $xslt->parse_stylesheet($sortXSL);
				$destDOM = $ss->transform($destDOM);
	#			if ($dicDOM->toFile($xmlBackupFile, 0) && $destDOM->toFile($destBackupFile, 0)) {
	# Win32 all on iga thread omaette protsess, seepärast lock vabastada LibXML-le, muidu ei pääse ligi
					if ($^O eq 'MSWin32') {
						flock($fh, LOCK_UN);
						flock($destFh, LOCK_UN);
					}
					if ($dicDOM->toFile($xmlFile, 0)) {
						if ($destDOM->toFile($destFile, 0)) {
							$nStatus = 5;
						}
						else {
							$rsp_status_node->appendTextNode("Server error writing '${destFile}' file (${cmdId})! See admin!");
						}
					}
					else {
						$rsp_status_node->appendTextNode("Server error writing '${xmlFile}' file (${cmdId})! See admin!");
					}
	#			}
	#			else {
	#				$rsp_status_node->firstChild->setData("Server error writing backup files (${cmdId})! Try again!");
	#			}
			}
		}
	}

	#nüüd võib lõpetada. Kõik on salvestatud
	my $leide;
	if ($nStatus == 5) {
		if ($art_xpath) { #homonüümsed
			if ($qryMethod eq 'MySql') {
				$sth = $dbh->prepare($sql);
				$sth->execute();

				my $respStr = '<sr>';
				$leide = $sth->rows;
				$respStr .= teeXMLStr($sth, '');
				$respStr .= "</sr>";
				$qryDOM = $dicparser->parse_string($respStr);
			}
			else {
				# art_xpath - "homonüümsete kontroll":  DICPR & ":A[" & elm_xpath & "]"
				# elm_xpath - "arttingimus": m[ sOrgMarkSona (or sMarkSona)]
				$xslnode = $queryXSL->documentElement()->findnodes("xsl:template[\@match = 'al:sr']/sr/xsl:apply-templates")->get_node(1);
				$xslnode->setAttribute("select", $art_xpath);
				$xslnode = $queryXSL->documentElement()->findnodes("xsl:template[\@match = 'al:A']/A/l/t/xsl:for-each")->get_node(1);
				$xslnode->setAttribute("select", $elm_xpath);
				my $ss = $xslt->parse_stylesheet($queryXSL);
				$qryDOM = $ss->transform($dicDOM, vf => "'${dicVol}'");
				$artsCount = $qryDOM->documentElement()->childNodes->size();
				$leide = $qryDOM->documentElement()->findnodes("A/l/t/span[\@class = '_b'][\@nr]")->size();
			}
		}
		else {
			$artsCount = 0; # kustutamise korral, "midagi ei jäänud alles"
		}
	}

	if ($fh) {
		flock($fh, LOCK_UN);
		close($fh);
		if ($destFh) {
			flock($destFh, LOCK_UN);
			close($destFh);
		}
	}

	$rsp_vol_node->appendTextNode($dicVol);
	if ($nStatus == 5) {

		$rsp_count_node->appendTextNode($artsCount);
		$rsp_status_node->appendTextNode("Success");

		if ($artsCount > 0) {
			# $outDOM->documentElement()->setAttribute("qfID", $queryFileID);
			$outDOM->documentElement()->setAttribute("qinfo", $lcDom->documentElement()->findvalue("itm[\@n = 'CHECK_HOMS'][\@l = '${APP_LANG}']") . ": '${opMs}'");
			$outDOM->documentElement()->setAttribute("leide", $leide);
			$outDOM->documentElement()->appendChild($outDOM->importNode($qryDOM->documentElement()));
			my $brInfoDom = $dicparser->parse_string($browseInfoStr);
			$outDOM->documentElement()->appendChild($outDOM->importNode($brInfoDom->documentElement()));
			# $outDOM->toFile("temp/${queryFileID}.xml", 0);
			$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));
		}
	}
	else {
		$rsp_count_node->appendTextNode('-1');
	}

# - lõpetamine
	if ($qryMethod eq 'MySql') {
		$dbh->disconnect();
	}
}
elsif (($cmdId eq "ClientRestore") && $nEditAllowed) {

	my $sth;
	my $vanaA;
	my ($fh, $destFh, $xmlFile, $xmlBackupFile, $destFile, $destBackupFile, $destDOM);

# - algus
	if ($qryMethod eq 'MySql') {
		$dbh = DBI->connect("DBI:mysql:database=${mySqlDbName};mysql_enable_utf8=1;host=${mysql_ip}",
							 $mysql_user, $mysql_pass,
							 {'RaiseError' => 0, AutoCommit => 1});
		$sth = $dbh->prepare("SELECT ${DIC_DESC}.art AS art FROM ${DIC_DESC} WHERE ${DIC_DESC}.G = '${artG}'");
		$sth->execute();
		my $artCnt = $sth->rows;
		if ($artCnt == 1) {
			if (my $ref = $sth->fetchrow_hashref()) {
				$vanaA = $dicparser->parse_string($ref->{'art'})->documentElement();
				if ($ainultMySql) {
					$nStatus = 2;
				}
				else {
					$nStatus = 1;
				}
			}
		}
		else {
			$rsp_status_node->appendTextNode("Failed on select ... where G = '${artG}' (${artCnt} tk) (${cmdId})!");
		}
		$sth->finish();
	}
	else {
		$nStatus = 1;
	}
	
	if ($nStatus == 1) {

		$xmlFile = "__sr/${DIC_DESC}/${dicVol}.xml";
		$xmlBackupFile = "backup/${dicVol}.xml";
		if (open($fh, '+<:utf8', $xmlFile)) {
			if (flock($fh, $lockType)) {
				$dicDOM = $dicparser->parse_file($xmlFile);
				my $nodes = $dicDOM->documentElement()->findnodes("${DICPR}:A[${DICPR}:G = '${artG}']");
				if ($nodes->size() == 1) {
					$vanaA = $nodes->get_node(1);
					$destFile = "__sr/${DIC_DESC}/${destVol}.xml";
					$destBackupFile = "backup/${destVol}.xml";
					if (open($destFh, '+<:utf8', $destFile)) {
						if (flock($destFh, $lockType)) {
							$destDOM = $dicparser->parse_file($destFile);
							$nStatus = 2;
						}
						else {
							$rsp_status_node->appendTextNode("Failed to flock '${destFile}' (${cmdId})!");
						}
					}
					else {
						$rsp_status_node->appendTextNode("Failed to open '${destFile}' (${cmdId})!");
					}
				}
				else {
					$rsp_status_node->appendTextNode("Failed on 'findnodes(G = ${artG})' (" . $nodes->size() . " tk) (${cmdId})!");
				}
			}
			else {
				$rsp_status_node->appendTextNode("Failed to flock '${xmlFile}' (${cmdId})!");
			}
		}
		else {
			$rsp_status_node->appendTextNode("Failed to open '${xmlFile}' (${cmdId})!");
		}
	}
	
	#vanaA on nüüd käes
	my ($vanaT, $vanaTA, $vanaO);
	if ($nStatus == 2) {

		$vanaT = $vanaA->findvalue("${DICPR}:T");
		$vanaTA = $vanaA->findvalue("${DICPR}:TA");
		$vanaO = $vanaA->findvalue("${fdArt}/\@${DICPR}:O");

		$nStatus = 3;
	}

	my $vNr = substr($dicVol, 3, 1);
	my $dvNr = substr($destVol, 3, 1);

	#võib nüüd salvestada - kui vaja
	if ($nStatus == 3) {

		my $m1Elem = $vanaA->findnodes("${fdArt}")->get_node(1);
		$opMs = $m1Elem->textContent;
		foreach my $attNode ($m1Elem->attributes()) {
			if ($attNode->localname ne 'O') {
				$opAttrs .= " \@" . $attNode->nodeName . "='" . $attNode->textContent . "'";
			}
		}
		$opAttrs = substr($opAttrs, 1);

		&valmistaSortXsl();

		if ($qryMethod eq 'MySql') {
			my ($rcnt, $TA);
			$dbh->begin_work;
			my $updCmd = "UPDATE msid SET vol_nr = ${dvNr} WHERE dic_code = '${DIC_DESC}' AND G = '${artG}'";
			$sth = $dbh->prepare($updCmd);
			$rcnt = $sth->execute();
			if ($rcnt > 0) {
				$updCmd = "UPDATE ${DIC_DESC} SET vol_nr = ${dvNr}";
				if ($ainultMySql) {
					$updCmd .= ", toXml = 1";
				}
				$updCmd .= " WHERE ${DIC_DESC}.G = '${artG}'";
				$updCmd =~ s/\s+/ /g;
				$sth = $dbh->prepare($updCmd);
				$rcnt = $sth->execute();
				if ($rcnt == 1) {
					$dbh->commit;
					&mySqlTimestamp();
					$nStatus = 4;
				}
				else {
					$rsp_status_node->appendTextNode($sth->errstr . ' :: ' . $updCmd);
					$dbh->rollback;
				}
			}
			else {
				$rsp_status_node->appendTextNode($sth->errstr . ' :: ' . $updCmd);
				$dbh->rollback;
			}
		}
		else {
			# XML-i tuleb salvestada paralleelselt MySql-iga ...
			$nStatus = 4;
		}
		if ($nStatus == 4) {
			if ($ainultMySql) {
				$nStatus = 5;
			}
			else {
				$destDOM->documentElement()->appendChild($vanaA);
				my $ss = $xslt->parse_stylesheet($sortXSL);
				$destDOM = $ss->transform($destDOM);
#				if ($dicDOM->toFile($xmlBackupFile, 0) && $destDOM->toFile($destBackupFile, 0)) {
	# Win32 all on iga thread omaette protsess, seepärast lock vabastada LibXML-le, muidu ei pääse ligi
					if ($^O eq 'MSWin32') {
						flock($fh, LOCK_UN);
						flock($destFh, LOCK_UN);
					}
					if ($dicDOM->toFile($xmlFile, 0)) {
						if ($destDOM->toFile($destFile, 0)) {
							$nStatus = 5;
						}
						else {
							$rsp_status_node->appendTextNode("Server error writing '${destFile}' file (${cmdId})! See admin!");
						}
					}
					else {
						$rsp_status_node->appendTextNode("Server error writing '${xmlFile}' file (${cmdId})! See admin!");
					}
#				}
#				else {
#					$rsp_status_node->firstChild->setData("Server error writing backup files (${cmdId})! Try again!");
#				}
			}
		}
	}

	#nüüd võib lõpetada. Kõik on salvestatud
	my $leide;
	if ($nStatus == 5) {
		if ($art_xpath) { #homonüümsed
			if ($qryMethod eq 'MySql') {
				$sth = $dbh->prepare($sql);
				$sth->execute();

				my $respStr = '<sr>';
				$leide = $sth->rows;
				$respStr .= teeXMLStr($sth, '');
				$respStr .= "</sr>";
				$qryDOM = $dicparser->parse_string($respStr);
			}
			else {
				# art_xpath - "homonüümsete kontroll":  DICPR & ":A[" & elm_xpath & "]"
				# elm_xpath - "arttingimus": m[ sOrgMarkSona (or sMarkSona)]
				$xslnode = $queryXSL->documentElement()->findnodes("xsl:template[\@match = 'al:sr']/sr/xsl:apply-templates")->get_node(1);
				$xslnode->setAttribute("select", $art_xpath);
				$xslnode = $queryXSL->documentElement()->findnodes("xsl:template[\@match = 'al:A']/A/l/t/xsl:for-each")->get_node(1);
				$xslnode->setAttribute("select", $elm_xpath);
				my $ss = $xslt->parse_stylesheet($queryXSL);
				$qryDOM = $ss->transform($dicDOM, vf => "'${dicVol}'");
				$artsCount = $qryDOM->documentElement()->childNodes->size();
				$leide = $qryDOM->documentElement()->findnodes("A/l/t/span[\@class = '_b'][\@nr]")->size();
			}
		}
		else {
			$artsCount = 1; # taastamise korral, "vähemalt üks on"
		}
	}

	if ($fh) {
		flock($fh, LOCK_UN);
		close($fh);
		flock($destFh, LOCK_UN);
		close($destFh);
	}

	$rsp_vol_node->appendTextNode($dicVol);
	if ($nStatus == 5) {

		$rsp_count_node->appendTextNode($artsCount);
		$rsp_status_node->appendTextNode("Success");

		if ($artsCount > 1) {
			# $outDOM->documentElement()->setAttribute("qfID", $queryFileID);
			$outDOM->documentElement()->setAttribute("qinfo", $lcDom->documentElement()->findvalue("itm[\@n = 'CHECK_HOMS'][\@l = '${APP_LANG}']") . ": '${opMs}'");
			$outDOM->documentElement()->setAttribute("leide", $leide);
			$outDOM->documentElement()->appendChild($outDOM->importNode($qryDOM->documentElement()));
			my $brInfoDom = $dicparser->parse_string($browseInfoStr);
			$outDOM->documentElement()->appendChild($outDOM->importNode($brInfoDom->documentElement()));
			# $outDOM->toFile("temp/${queryFileID}.xml", 0);
			$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));
		}
	}
	else {
		$rsp_count_node->appendTextNode('-1');
	}

# - lõpetamine
	if ($qryMethod eq 'MySql') {
		$dbh->disconnect();
	}
}
elsif ($cmdId eq "ImportRead") {
	my $impDicDesc = substr($dicVol, 0, 3);
	# ../__shs(_test)/__sr
	my $pathBase = $art_xpath;

	my $impShsConf = $dicparser->parse_file("shsconfig_${impDicDesc}.xml");
	my $impDicPr = $impShsConf->documentElement()->findvalue('dicpr');
	my $impDicUri = $impShsConf->documentElement()->findvalue('dicuri');

	my $xsldom = $dicparser->parse_file('xsl/import_i.xsl');

	$xsldom->documentElement()->setNamespace($impDicUri, 'al', 0); #sr jaoks
	$xsldom->documentElement()->setNamespace($impDicUri, $impDicPr, 0); #käivitatava päringu jaoks
	$xsldom->documentElement()->setNamespace($DICURI, $DICPR, 0); #väljastatavate elementide jaoks
	$xslnode = $xsldom->documentElement()->findnodes("xsl:template[\@match = 'al:sr']/xsl:element/xsl:apply-templates[\@select='thisQuery']")->get_node(1);
	$xslnode->setAttribute("select", "${impDicPr}:A[${impDicPr}:G = '${artG}']");
	my $ss = $xslt->parse_stylesheet($xsldom);

	my $xmlFile = "${pathBase}/${impDicDesc}/${dicVol}.xml";

	if (open(XMLF, '<:utf8', $xmlFile)) {
		# if (flock(XMLF, $lockType)) {
			$dicDOM = $dicparser->parse_file($xmlFile);
			$qryDOM = $ss->transform($dicDOM, pr => "'${DICPR}'", uri => "'${DICURI}'", dic_desc => "'${impDicDesc}'");
			$artsCount = $qryDOM->documentElement()->childNodes->size();
			my $artikkel = $qryDOM->documentElement()->childNodes->get_node(1);

			$rsp_count_node->appendTextNode($artsCount);

			if ($artsCount == 1 && $artikkel->localname eq 'A') {
				$rsp_status_node->appendTextNode("Success");
#				$rsp_vol_node->appendTextNode($dicVol);
				$responseDOM->documentElement()->appendChild($responseDOM->importNode($artikkel));
			}
			else {
				$rsp_status_node->appendTextNode("Failed on 'findnodes(${xmlFile} - ${artG}) (${cmdId})!");
			}
			flock(XMLF, LOCK_UN);
		# }
		# else {
		#	$rsp_status_node->appendTextNode("Failed to flock '${xmlFile}' (${cmdId})!");
		# }
		close(XMLF);
	}
	else {
		$rsp_status_node->appendTextNode("Failed to open '${xmlFile}' (${cmdId})!");
	}
}
elsif ($cmdId eq "SaveList") {
	my $xsldom = $dicparser->parse_file('xsl/gethwdschunk.xsl');
	my $ss = $xslt->parse_stylesheet($xsldom);
	my $poss1 = 1;
	my $poss2 = 1000000;

	my $xmlFile = "temp/${art_xpath}.xml";
	if (open(XMLF, '<:utf8', $xmlFile)) {
		if (flock(XMLF, $lockType)) {
			$dicDOM = $dicparser->parse_file($xmlFile);
			$qryDOM = $ss->transform($dicDOM, pos1 => "'${poss1}'", pos2 => "'${poss2}'");
			flock(XMLF, LOCK_UN);
			$nStatus = 1;
		}
		close(XMLF);
	}
	if ($nStatus) {
		$artsCount = $qryDOM->documentElement()->childNodes->size();

		# ja cloneNode peab vist olema, muidu ei oska ta enam atribuuti kirjutada outDOM - le
		$outDOM->documentElement()->appendChild($outDOM->importNode($qryDOM->documentElement()));

		$rsp_status_node->appendTextNode("Success");
		$rsp_count_node->appendTextNode($artsCount);

		$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));
	}
	else {
		$rsp_status_node->appendTextNode("Failed to open/flock '${xmlFile}' (${cmdId})!");
	}
}
elsif (($cmdId eq "ClientPrint") && $nEditAllowed) {

	if ($qryMethod eq 'MySql') {

		$dbh = DBI->connect("DBI:mysql:database=${mySqlDbName};mysql_enable_utf8=1;host=${mysql_ip}",
							 $mysql_user, $mysql_pass,
							 {'RaiseError' => 1});

		$qrySql = $pQrySql . " LIMIT ${MAX_PRINT_ARTS}";
		$qrySql =~ s/\s+/ /g;
		my $sth = $dbh->prepare($qrySql);
		$sth->execute();
		$artsCount = $sth->rows; # print korral on lisatud 'group by G'

		my $respStr = "<${DICPR}:sr xmlns:${DICPR}=\"${DICURI}\" xml:lang=\"et\">";
		my $artikkel;
		while (my $ref = $sth->fetchrow_hashref()) {
			$artikkel = decode_utf8($ref->{'art'});
			$respStr .= $artikkel;
		}
		$respStr .= "</${DICPR}:sr>";
		
		$sth->finish();
		$dbh->disconnect();

		$rsp_count_node->appendTextNode($artsCount);
		$rsp_status_node->appendTextNode("Success");

		$printDOM = $dicparser->parse_string($respStr);
		$outDOM->documentElement()->appendChild($outDOM->importNode($printDOM->documentElement()));
		$outDOM->documentElement()->childNodes->get_node(1)->setAttribute("qinfo", $qinfo);
		$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));
	}
	else { # 'XML'

		my $xsldom = $dicparser->parse_file('xsl/print.xsl');
		$xsldom->documentElement()->setNamespace($DICURI, 'al', 0);
		$xsldom->documentElement()->setNamespace($DICURI, $DICPR, 0);

		$xslnode = $xsldom->documentElement()->findnodes("xsl:template[\@match = 'al:sr']/xsl:copy/xsl:apply-templates")->get_node(1);
		$xslnode->setAttribute("select", $art_xpath);

		$xslnode = $xsldom->documentElement()->findnodes("xsl:variable[\@name = 'dic_desc']")->get_node(1);
		$xslnode->firstChild->setData($DIC_DESC);

		my $ss = $xslt->parse_stylesheet($xsldom);

		my $qrycount = 0;
		my $xmlFile;
	
		if ($dicVol eq "${DIC_DESC}All") {
			$i = 1;
			$j = $DIC_VOLS_COUNT;
		}
		else {
			$i = substr($dicVol, 3, 1);
			$j = $i;
		}
	
		for ($i; $i <= $j; $i++) {
	
			$xmlFile = "__sr/${DIC_DESC}/${DIC_DESC}${i}.xml";

			if (open(XMLF, '<:utf8', $xmlFile)) {
				$dicDOM = $dicparser->parse_file($xmlFile);
				$qryDOM = $ss->transform($dicDOM);
				$nStatus = 1;
				close(XMLF);
			}
			if ($nStatus) {
				$artsCount = $qryDOM->documentElement()->childNodes->size();
				$qrycount += $artsCount;

				if ($qrycount > $MAX_PRINT_ARTS) {
					last;
				}

				if ($artsCount > 0) {
					# qryDOM: <sr> juurikas
					if ($outDOM->documentElement()->childNodes->size() == 0) {
						$outDOM->documentElement()->appendChild($outDOM->importNode($qryDOM->documentElement()));
					}
					else {
						for ($k = 1; $k <= $artsCount; $k++) {
							$outDOM->documentElement()->childNodes->get_node(1)->appendChild($outDOM->importNode( $qryDOM->documentElement()->childNodes->get_node($k) ));
						}
					}
				}
			}
			else {
				last;
			}
		}
	
		if ($nStatus) {

			# sünonüümterminite jaoks eri artiklite "tulistamine"
			if ($DIC_DESC eq 'har') {
				&valmistaSortXsl();
				my $ss = $xslt->parse_stylesheet($sortXSL);
				$outDOM = $ss->transform($outDOM);
			}

			$rsp_count_node->appendTextNode($qrycount);

			if ($qrycount > $MAX_PRINT_ARTS) {
				$rsp_status_node->appendTextNode("ClientPrint_TOOMANY");
			}
			else {
				$rsp_status_node->appendTextNode("Success");
				if ($qrycount > 0) {
					$outDOM->documentElement()->childNodes->get_node(1)->setAttribute("qinfo", $qinfo);
				}
				$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));
			}
			# $responseDOM->toFile("temp/print.xml", 0);
		}
		else {
			$rsp_status_node->appendTextNode("Failed to open '${xmlFile}' (${cmdId})!");
		}
	}
}


$nowdtstr =~ s/T/\t/g;
my $elTime = (time() - $startTime);
my $logSta = $rsp_status_node->firstChild->toString(0);
unless ($rsp_count_node->firstChild) {
	$rsp_count_node->appendTextNode('-1');
}
my $logCnt = $rsp_count_node->firstChild->toString(0);

$qrySql =~ s/\s+/ /g;

my @logLines;
tie(@logLines, 'Tie::File', "logs/${DIC_DESC}/${logFileName}.log");

### Kui siin midagi muudad, siis sama teha ka 'tools.cgi' - s !
my $logLine = "${nowdtstr}\t${usrName}\t\"${remoteAddress}\"\t${cmdId}\t${dicVol}\t${elTime}s.\t${logSta}\t${logCnt}\t${qinfo}\t${art_xpath}\tsrchPtrn: '${fSrchPtrn}'\t${artMuudatused}\t${opMs}\t${opAttrs}\t${qryMethod}\t${qrySql}";

unshift(@logLines, encode_utf8($logLine));
untie(@logLines);

print "Content-type: text/xml; charset=utf-8\n\n";
print $responseDOM->toString(0);


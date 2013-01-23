#!/usr/bin/perl

use strict;
use utf8; # skripti ja tema sees olla võivate utf-8 muutujate (nimed, väärtused) tõttu
# decode_utf8, encode_utf8 ...
use Encode;
# et print laseks kõik utf-8 -s välja (kui on välja kommitud, siis iga 'print' po 'encode_utf8',
# VÄLJA ARVATUD 'DOM->toString' korral, sest on ise juba UTF-8
# Seega: kõik 'funcs' sarnased cgi-d po ILMA 'binmode' -ta.
# binmode(STDOUT, ":utf8");


# *****************************************************
# Constants
# *****************************************************
my $REG_LETT_LA = "aàáâãåāăąǎǡǻȁȃḁạảấầẩẫậắằẳẵặbƃƅḃḅḇcçćĉċčƈḉdðďđƌḋḍḏḑḓeèéêëēĕėęěȅȇḕḗḙḛḝẹẻẽếềểễệfƒḟgĝğġģǥǧǵḡhĥħḣḥḧḩḫiìíîïĩīĭįıǐȉȋḭḯỉịjĵkķƙǩḱḳḵlĺļľŀłḷḹḻḽmḿṁṃnñńņňŋṅṇṉṋoòóôøōŏőơǒǫǭǿȍȏṑṓọỏốồổỗộớờởỡợpƥṕṗqrŕŗřȑȓṙṛṝṟsśŝşṡṣṥṩšṧzźżƶẑẓẕžtţťŧƭṫṭṯṱuùúûũūŭůűųưǔȕȗṳṵṷṹṻụủứừửữựvṽṿwŵẁẃẅẇẉõṍṏäǟöüǖǘǚǜxẋẍyýŷÿƴẏỳỵỷỹ";
my $REG_LETT_RU = "абвгдеёжзийклмнопрстуфхцчшщъыьэюя";

#my $mysql_ip = '192.168.60.65';
require '/www/shs_config/shs_config.ini';
our ($mysql_ip, $mysql_user, $mysql_pass);

my $scriptName = $ENV{SCRIPT_NAME};
#debugimiseks
if (index($scriptName, '/__shs_test/') > -1) {
	# use lib qw( ./shs_lib/ );
	#use SHS_man;
	# use SHS_Carp;
	#$SIG{__WARN__} = \&carp_hwl;
	# $SIG{__DIE__}  = \&carp_hdl;
}

# *****************************************************
# CGI parameters
# *****************************************************

use CGI;
my $q = new CGI;
my @parms = split(/\x{e001}/, decode_utf8($q->param('POSTDATA')));
my $cmdId = $parms[0];
my $DIC_DESC = $parms[1];
my $usrName = $parms[2];

if ($cmdId eq '' || $DIC_DESC eq '' || $usrName eq '') {
	print "Content-type: text/html; charset=utf-8\n\n"; #header utf-8 -s
	print 'not defined.';
	exit;
}

my $exsaAdminLoginName = 'EKI_EELex_EXSA';
my $exsaAdminDisplayName = 'exsaAdmin';
# siinset vaja 'sqnastikud.cgi' - st logimisel
if ($usrName eq $exsaAdminLoginName) {
	$usrName = $exsaAdminDisplayName;
}

# *****************************************************
# LibXML
# *****************************************************

use XML::LibXML;
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

my ($shsconfig, $DIC_VOLS_COUNT, $DICPR, $DICURI, $MAX_PRINT_ARTS);
$shsconfig = $dicparser->parse_file("shsconfig_${DIC_DESC}.xml");
$DIC_VOLS_COUNT = $shsconfig->documentElement()->findnodes('vols/vol')->size();
$DICPR = $shsconfig->documentElement()->findvalue('dicpr');
$DICURI = $shsconfig->documentElement()->findvalue('dicuri');
$MAX_PRINT_ARTS = $shsconfig->documentElement()->findvalue('max_print_arts');

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


my $FIRST_DEFAULT = $shsconfig->documentElement()->findvalue('first_default');
my $fdArt = substr($FIRST_DEFAULT, index($FIRST_DEFAULT, '/') + 1);
my $DEFAULT_QUERY = $shsconfig->documentElement()->findvalue('default_query');
my $dqArt = substr($DEFAULT_QUERY, index($DEFAULT_QUERY, '/') + 1);
my $qn_ms = substr($DEFAULT_QUERY, rindex($DEFAULT_QUERY, '/') + 1);

my $fakOlemas = $shsconfig->documentElement()->findvalue('fakult');
my $fakOsataPtrn;
if ($fakOlemas) {
	$fakOsataPtrn = '\\' . substr($fakOlemas, 0, 1) . '.*?\\' . substr($fakOlemas, 1, 1);
	$fakOsataPtrn = qr/$fakOsataPtrn/;
}
my $mySqlDataVer = $shsconfig->documentElement()->findvalue('mySqlDataVer');

my ($sortXSL, $fr_sym, $to_sym);

# NB! : ka srvfuncs.cgi
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

# NB! : ka srvfuncs.cgi
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


my $remoteAddress = $ENV{REMOTE_ADDR};

my $rspXML = <<"rspXML";
<?xml version="1.0" encoding="utf-8"?>
<rsp xmlns:${DICPR}="${DICURI}">
	<sta />
	<cnt />
	<cmd />
	<errs />
</rsp>
rspXML
my $responseDOM = $dicparser->parse_string($rspXML);
my $rsp_status_node = $responseDOM->documentElement()->findnodes('sta')->get_node(1);
my $rsp_count_node = $responseDOM->documentElement()->findnodes('cnt')->get_node(1);
my $rsp_cmd_node = $responseDOM->documentElement()->findnodes('cmd')->get_node(1);
$rsp_cmd_node->appendTextNode($cmdId);
my $rsp_errs_node = $responseDOM->documentElement()->findnodes('errs')->get_node(1);
$rsp_errs_node->appendTextNode('-');

my $outXML = <<"outXML";
<?xml version="1.0" encoding="utf-8"?>
<outDOM />
outXML
my $outDOM = $dicparser->parse_string($outXML);

my $fSrchPtrn;
my $fSubstPtrn;

# tavalise päringu juures
sub srch {
	my $nodeList = shift(@_);

	my ($i, $nodeText);
	for ($i = 1; $i <= $nodeList->size(); $i++) {
		$nodeText = $nodeList->get_node($i)->textContent;
		
		if ($fSubstPtrn) {
			$nodeText =~ s/$fSubstPtrn//og;
		}

		if ($nodeText =~ /$fSrchPtrn/) {
			return 1;
		}
	}
	return 0;
}


# my $noLetters = qr/&(amp|lt|gt|((em|b|sub|sup|l)(a|l)));|[^\p{L}\s]/;
# my $noLetters = qr/(&\w+;)|[^\p{L}\s]/;
my $noLetters = qr/(&\w+;)|[^${msAlpha}\s]/;

# eraldi otsingufunktsioon
sub xmlRex {
	my $nodeText = shift(@_)->to_literal();
	my $rexPtrn = decode_utf8(shift(@_));
	my $substBoolean = shift(@_);

	if ($substBoolean eq '1') {
		$nodeText = teeMs_nosKuju($nodeText);
	}
	if ($nodeText =~ /$rexPtrn/) {
		return 1;
	}
	return 0;
}

# NB! : ka srvfuncs.cgi
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
} # t6lgi

# NB! : ka srvfuncs.cgi
sub teeMs_nosKuju {
	my $ms_nos = shift(@_);
	$ms_nos =~ s/&amp;/&/g; #kuna 'mTekstid' on 'toString', siis on '&amp;ema;' jne
	$ms_nos = t6lgi($ms_nos);
	$ms_nos =~ s/$noLetters//g;
	return $ms_nos;
}

sub unNameCgi {
	my $inpStr = shift(@_);
    my $unStr = $inpStr;
	$unStr =~ s/:/-/;
	for (my $i = 0; $i < length($inpStr); $i++) {
		$unStr .= '_' . ord(substr($inpStr, $i, 1));
	}
    return $unStr;
}


my $xpc = XML::LibXML::XPathContext->new();
$xpc->registerFunction('xmlRegex', \&srch);
$xpc->registerFunction('xmlXpcRex', \&xmlRex);

# NB! : ka srvfuncs.cgi
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


# NB! : ka srvfuncs.cgi
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


my $artsCount = 0;

sub teeHulgiAsjad {

	my ($md, $g);
	my $artsXML = '';

	$artsCount = 0;

	my $stHandle = shift(@_);
	my $elm_xpath = shift(@_);

	my $maxArtikleid = 300;

	while (my $ref = $stHandle->fetchrow_hashref()) {

		if ($artsCount < $maxArtikleid) {

			$artsCount++;

			$g = $ref->{'G'};
			my $viimane_vol_nr = $ref->{'vol_nr'};

			$artsXML .= '<A>';

			$artsXML .= "<vf>${DIC_DESC}${viimane_vol_nr}.xml</vf>";

			$md = decode_utf8($ref->{'md'});
			$artsXML .= "<md>${md}</md>";

			$artsXML .= "<G>${g}</G>";

			my $viimaneArt = decode_utf8($ref->{'art'});

			my $artDom = $dicparser->parse_string($viimaneArt);

			foreach my $leid ($xpc->findnodes($elm_xpath, $artDom->documentElement())) {
				$artsXML .= "<l>";

				$artsXML .= "<e>" . $leid->nodeName . "</e>";
				my $tTekstid = '';
				foreach my $tText ($leid->findnodes('.//text()')) {
					$tTekstid .= $tText->toString; #nt textContent - '&amp;' -> '&'
				}
				$artsXML .= "<t>${tTekstid}</t>";

				# hom nr ka, et samasugustel vahet teha; 21. august 2011
				$artsXML .= "<i>" . $leid->getAttribute("${DICPR}:i") . "</i>";

				$artsXML .= "<r>";
				if ($DIC_DESC eq 'sp_') {
					# $artsXML .= $leid->parentNode->parentNode->nodeName . '/' . $leid->parentNode->nodeName;
					$artsXML .= teeRada($leid);
				}
				else {
					$artsXML .= teeRada($leid);
				}
				$artsXML .= "</r>";

				$artsXML .= "<gf>";
				if ($DIC_DESC eq 'sp_') {
					my $mgEsiVanem = $leid->findnodes("ancestor::${DICPR}:mg[1]")->get_node(1);
					if ($mgEsiVanem) {
						$artsXML .= $mgEsiVanem->toString;
					}
					elsif ($leid->parentNode->nodeName eq "${DICPR}:t") {
						my $esiVanem = $leid->parentNode;
						my $evQn = $esiVanem->nodeName;
						$artsXML .= "<${evQn}";
							foreach my $attNode ($esiVanem->attributes()) {
								$artsXML .= ' ' . $attNode->toString;
							}
						$artsXML .= ">";
						foreach my $alam ($esiVanem->findnodes("*[not(name() = '{$evQn}')]")) {
							$artsXML .= $alam->toString;
						}
						$artsXML .= "</${evQn}>";
					}
					else {
						my $esiVanem = $leid->parentNode->parentNode;
						my $evQn = $esiVanem->nodeName;
						$artsXML .= "<${evQn}";
							foreach my $attNode ($esiVanem->attributes()) {
								$artsXML .= ' ' . $attNode->toString;
							}
						$artsXML .= ">";
						foreach my $alam ($esiVanem->findnodes("*[not(name() = '${evQn}')]")) {
							$artsXML .= $alam->toString;
						}
						$artsXML .= "</${evQn}>";
					}
				}
				else {
					if ($leid->nodeName eq "${DICPR}:A") {
						$artsXML .= $leid->toString;
					}
					# <P>, <S> ..., valitakse <P>, <S>
					elsif ($leid->parentNode->nodeName eq "${DICPR}:A") {
						$artsXML .= $leid->toString;
					}
					# <mg>, valitakse <P>
					elsif ($leid->parentNode->parentNode->nodeName eq "${DICPR}:A") {
						$artsXML .= $leid->parentNode->toString;
					}
					else {
						$artsXML .= $leid->parentNode->parentNode->toString;
					}
				}
				$artsXML .= "</gf>";

				$artsXML .= "</l>";
			}
			$artsXML .= '</A>';
		} # if ($artsCount <= $MAX_PRINT_ARTS) {
		else {
			last;
		}
	} # while ($ref = $stHandle->fetchrow_hashref()) {
	
	return $artsXML;

} # teeHulgiAsjad


my $qryMethod = 'MySql';
my $eeLexConfDom = $dicparser->parse_file('shsConfig.xml');
my $eeLexQM = $eeLexConfDom->documentElement()->findvalue('qmMySql');
if (index($eeLexQM, ";${DIC_DESC};") < 0) {
	$qryMethod = 'XML';
}

my $ainultMySql = 0;
my $eeLexAMS = $eeLexConfDom->documentElement()->findvalue('ainultMySql');
if (index($eeLexAMS, ";${DIC_DESC};") > -1 && $qryMethod eq 'MySql') {
	$ainultMySql = 1;
}

my $mySqlDbName = 'xml_dicts';
if (index($ENV{SCRIPT_NAME}, '/__shs_test/') > -1) {
	$mySqlDbName = 'xml_dicts_test';
}

my $qrySql;


my $startTime = time();
my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime($startTime);
my $nowdtstr = sprintf("%04d-%02d-%02dT%02d:%02d:%02d", $year + 1900, $mon + 1, $mday, $hour, $min, $sec);
my $logFileName = substr($nowdtstr, 0, 10);


# po siin, so globaalsed teiste suhtes ...
my ($dicDOM, $qryDOM);
my ($i, $j, $k);
my $nStatus = 0;
my $hwdsChunkSize = 2000;
my $art_xpath;

use XML::LibXSLT;
my $xslt = XML::LibXSLT->new();
my $XSLSCRIPTSURI = 'http://www.eo.ee/xml/xsl/perlscripts';
XML::LibXSLT->register_function($XSLSCRIPTSURI, 'srch', \&srch);
XML::LibXSLT->register_function($XSLSCRIPTSURI, 'xmlRex', \&xmlRex);

use Tie::File;


# file lock constants
use Fcntl ':flock';
my $lockType;
if ($^O eq 'MSWin32') {
	$lockType = LOCK_SH;
}
else {
	$lockType = LOCK_EX;
}


my $dictsConfFile = "../exsas/sqnastikud.xml";
my $copyConfFile = "../exsas/sqnFailid.txt";

## 'tools.cgi' asendused 'srvfuncs' muutujate jaoks:
my $dicVol = $DIC_DESC;
my $qinfo = "'qinfo'";
my $opAttrs = "'opAttrs'";

my $opMs = '';
my $artMuudatused = '';


my $admMsg = $shsconfig->documentElement()->findvalue("msg[\@type = 'stop']");
if ($admMsg) {
	# osa käske (lukusta) peab läbi pääsema
	unless ($cmdId eq 'exsaSetField' || $cmdId eq 'xmlCopy' || $cmdId eq 'saveGendXSD') {
		$cmdId = "y";
		$rsp_status_node->appendTextNode($admMsg);
		$rsp_count_node->appendTextNode('0');
	}
}

use DBI();

my ($dbh, $sth, $rcnt, $TA);

if ($qryMethod eq 'MySql') {

# srvfuncs - is on "AutoCommit == 0" ainult 'tyhjadviited' korral ..., kas kontrollida?
	$dbh = DBI->connect("DBI:mysql:database=${mySqlDbName};mysql_enable_utf8=1;host=${mysql_ip}",
						 $mysql_user, $mysql_pass,
						 {'RaiseError' => 1, AutoCommit => 1});
}



if ($cmdId eq "readArtByGuid") {
	my $volName = $parms[3];
	my $xmlFile = "__sr/${DIC_DESC}/${volName}.xml";
	my $artG = $parms[4];

	if ($qryMethod eq 'MySql') {
		$sth = $dbh->prepare("SELECT ${DIC_DESC}.art AS art FROM ${DIC_DESC} WHERE ${DIC_DESC}.G = '${artG}'");
		$sth->execute();
		my $artCnt = $sth->rows;
		$rsp_count_node->appendTextNode($artCnt);
		if ($artCnt == 1) {
			if (my $ref = $sth->fetchrow_hashref()) {
				my $artDom = $dicparser->parse_string(decode_utf8($ref->{'art'}));
				$rsp_status_node->appendTextNode("Success");
				$responseDOM->documentElement()->appendChild($responseDOM->importNode($artDom->documentElement()));
			}
		}
		else {
			$rsp_status_node->appendTextNode("Failed on select ... where G = '${artG}' (${artCnt} tk) (${cmdId})!");
		}
		$sth->finish();
	}
	else {
		if (open(XMLF, '<:utf8', $xmlFile)) {
			$dicDOM = $dicparser->parse_file($xmlFile);
			$art_xpath = "${DICPR}:A[${DICPR}:G = '${artG}']";
			my $nodes = $dicDOM->documentElement()->findnodes($art_xpath);
			my $artCnt = $nodes->size();
			$rsp_count_node->appendTextNode($artCnt);
			if ($artCnt == 1) {
				$rsp_status_node->appendTextNode("Success");
				$responseDOM->documentElement()->appendChild($responseDOM->importNode($nodes->get_node(1)));
			}
			else {
				$rsp_status_node->appendTextNode("Failed on 'findnodes(${art_xpath}) (${artCnt} tk) (${cmdId})!");
			}
			close(XMLF);
		}
		else {
			$rsp_status_node->appendTextNode("Failed to open '${xmlFile}' (${cmdId})!");
		}
	}
}
elsif ($cmdId eq "readXMLg") {
	my $xmlFile = $parms[3];
	my $xPath = $parms[4];
	my $sql = $parms[5];
	my ($a, $m, $g, $t, $artCnt);

	if ($qryMethod eq 'MySql') {
		# sql = "SELECT msid.ms AS ms, msid.G AS G FROM msid WHERE ms LIKE '" & comboTekst & "%' AND dic_code = '" & dic_desc & "' AND vol_nr = " & volNr
		$sth = $dbh->prepare($sql);
		$sth->execute();
		$artCnt = $sth->rows;
		while (my $ref = $sth->fetchrow_hashref()) {
			$a = $outDOM->documentElement()->appendChild($outDOM->createElement("A"));
			$m = $a->appendChild($outDOM->createElement("m"));
			$m->appendTextNode($ref->{'ms'});
			$g = $a->appendChild($outDOM->createElement("g"));
			$g->appendTextNode($ref->{'G'});
		}
		$sth->finish();
	}
	else {
		my $xmlDom = $dicparser->parse_file($xmlFile);
		my $nodes = $xmlDom->documentElement()->findnodes($xPath);
		$artCnt = $nodes->size();
		for ($i = 1; $i <= $nodes->size(); $i++) {
			$a = $outDOM->documentElement()->appendChild($outDOM->createElement("A"));
			$m = $a->appendChild($outDOM->createElement("m"));
			$t = '';
			foreach my $mText ($nodes->get_node($i)->findnodes('text()')) {
				$t .= $mText->toString;
			}
			$m->appendTextNode($t);
			$g = $a->appendChild($outDOM->createElement("g"));
			$g->appendTextNode($nodes->get_node($i)->findvalue("ancestor::${DICPR}:A/${DICPR}:G"));
		}
	}
	$rsp_status_node->appendTextNode("Success");
	$rsp_count_node->appendTextNode($artCnt);
	$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));
}
elsif ($cmdId eq "hulgi_Otsi_MySQL") {
	$qrySql = $parms[4];
	my $elm_xpath = $parms[5];

	my $respStr = '';
	if ($qryMethod eq 'MySql') {
		$sth = $dbh->prepare($qrySql);
		$sth->execute();
		my $artikleid = $sth->rows;

		$respStr = "<sr xmlns:${DICPR}=\"${DICURI}\">";
		$respStr .= teeHulgiAsjad($sth, $elm_xpath);
		$respStr .= "</sr>";
		$sth->finish();

		if ($artsCount < $artikleid) {
			$artsCount .= '+';
		}

		$qryDOM = $dicparser->parse_string($respStr);
		$outDOM->documentElement()->appendChild($outDOM->importNode($qryDOM->documentElement()));
		$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));
	}

	$rsp_status_node->appendTextNode("Success");
	$rsp_count_node->appendTextNode($artsCount);
}
elsif ($cmdId eq "hulgi_Otsi_XML") {
	my $volsStr = $parms[3];
	$art_xpath = $parms[4];
	my $elm_xpath = $parms[5];

	my $xsldom = $dicparser->parse_file('xsl/hulgi_Otsi.xsl');
	$xsldom->documentElement()->setNamespace($DICURI, 'al', 0);
	$xsldom->documentElement()->setNamespace($DICURI, $DICPR, 0);

	my $xslnode = $xsldom->documentElement()->findnodes("xsl:template[\@match = 'al:sr']/sr/xsl:apply-templates")->get_node(1);
	$xslnode->setAttribute("select", $art_xpath);
	$xslnode = $xsldom->documentElement()->findnodes("xsl:template[\@match = 'al:A']/A/xsl:for-each")->get_node(1);
	$xslnode->setAttribute("select", $elm_xpath);
	
	my $ss = $xslt->parse_stylesheet($xsldom);
	
	my $pathBase;
	my $xmlFile;
	my $artCount = 0;
	my $qryCount = 0;

	$pathBase = "__sr/${DIC_DESC}";

	my @xmlFiles = split(/\|/, $volsStr);
	my ($xmlFile, $fn);
	for ($i = 0; $i < scalar(@xmlFiles); $i++) {
		$fn = $xmlFiles[$i] . '.xml';
		$xmlFile = "${pathBase}/${fn}";

		if (open(XMLF, '<:utf8', $xmlFile)) {
			if (flock(XMLF, $lockType)) {
				$dicDOM = $dicparser->parse_file($xmlFile);
				$qryDOM = $ss->transform($dicDOM, dic_desc => "'${DIC_DESC}'", volFile => "'${fn}'");
				flock(XMLF, LOCK_UN);
				$nStatus = 1;
			}
			close(XMLF);
		}
		if ($nStatus == 1) {
			$artCount = $qryDOM->documentElement()->childNodes->size();
			$qryCount += $artCount;
			
			# Kogu päringu tegemise aeg on siiski ca sama mis muidu EELex-ist pärimisel

			if ($artCount > 0) {
				my $artsMax = 500;
				if ($qryCount < $artsMax) {
					$outDOM->documentElement()->appendChild($outDOM->importNode($qryDOM->documentElement()));
				}
				else {
					my $artikleid = $outDOM->documentElement()->findnodes('sr/A')->size();
					my $uusSr = $outDOM->documentElement()->appendChild($qryDOM->documentElement()->cloneNode(0));
					for (my $ixArt = 0; $ixArt < ($artsMax - $artikleid); $ixArt++) {
						$uusSr->appendChild($qryDOM->documentElement()->childNodes->get_node(1));
					}
					$qryCount .= "+ (väljastati ${artsMax} artiklit)";
					last;
				}
			}
		}
		else {
			last;
		}
	}
	
	$rsp_status_node->appendTextNode("Success");
	$rsp_count_node->appendTextNode($qryCount);
	$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));
}
elsif ($cmdId eq "hulgi_Käivita") {

	my $cmdsDom = $dicparser->parse_string($parms[3]);
	my $opType = $cmdsDom->documentElement()->getAttribute('a'); # action
	
	my $seldNames = '';
	my $tehted = '';
	
	my $vfn;
	my $lastVfn = '';
	my $fileUpdated = 0;

	my $updatedArtCount = 0;
	$rsp_count_node->appendTextNode('0');
	$rsp_status_node->appendTextNode('-');
	
	my $isError = 0;
	my $isOpen = 0;

	my $pathBase = "__sr/${DIC_DESC}";
	my ($xmlFile, $backupFile);

	my ($g, $elm_xpath);
	
	my ($deldDom, $deldFile, $backupDeldFile);
	$deldFile = "__sr/${DIC_DESC}/${DIC_DESC}0.xml";
	$backupDeldFile = "backup/${DIC_DESC}0.xml";
	
	my $srLang = $rootLang;
	my ($vNr, $dvNr);
	
	$dvNr = 0;

	my $artKoopiaDom = XML::LibXML::Document->createDocument( "1.0", "UTF-8" );

	use File::Copy;
	my $aeg = $nowdtstr;
	$aeg =~ s/T/_/g;
	$aeg =~ s/:/\-/g;

	&valmistaSortXsl();

	foreach my $cANode ($cmdsDom->documentElement()->findnodes('cA')) {
		$vfn = $cANode->getAttribute('vf');
		$vNr = substr($vfn, 3, 1);
		$g = $cANode->getAttribute('g');

		# XML jaoks uue köitefaili avamine
		unless ($ainultMySql) {
			if ($vfn ne $lastVfn) {
				if ($isOpen) {
					if ($fileUpdated) {
						copy( $xmlFile, "backup/hulgi/" . substr($vfn, 0, 4) . "_${aeg}_${usrName}.xml" ) or die "Copy failed: $!";

						if ($dicDOM->toFile($backupFile, 0)) {
	# Win32 all on iga thread omaette protsess, seepärast lock vabastada LibXML-le, muidu ei pääse ligi
							if ($^O eq 'MSWin32') {
								flock(XMLF, LOCK_UN);
							}
							unless ($dicDOM->toFile($xmlFile, 0)) {
								$rsp_status_node->firstChild->setData("Server error writing file '${xmlFile}' (${cmdId})! See admin!");
								$isError = 1;
								last;
							}
							else {
								$fileUpdated = 0;
							}
						}
						else {
							$rsp_status_node->firstChild->setData("Server error writing backup file '${backupFile}' (${cmdId})! Try again!");
							$isError = 1;
							last;
						}
					}
					close(XMLF);
					$isOpen = 0;
				}
				$xmlFile = "${pathBase}/${vfn}";
				$backupFile = "backup/${vfn}";
				if (open(XMLF, '<:utf8', $xmlFile)) {
					if (flock(XMLF, $lockType)) {
						$isOpen = 1;
						$dicDOM = $dicparser->parse_file($xmlFile);
					}
					else {
						$rsp_status_node->firstChild->setData("Failed to flock '${xmlFile}' (${cmdId})!");
						$isError = 1;
						last;
					}
				}
				else {
					$rsp_status_node->firstChild->setData("Failed to open '${xmlFile}' (${cmdId})!");
					$isError = 1;
					last;
				}
			} # if ($vfn ne $lastVfn) {
		} # unless ($ainultMySql) {

		# nüüd vaja üles leida artikkel
		my ($artCnt, $artikkel);
		if ($ainultMySql) {
			my $selectCmd = "SELECT ${DIC_DESC}.art AS art FROM ${DIC_DESC} WHERE ${DIC_DESC}.G = '${g}' AND ${DIC_DESC}.vol_nr = ${vNr}";
			my $sth = $dbh->prepare($selectCmd);
			$sth->execute();
			$artCnt = $sth->rows;
			if ($artCnt == 1) {
				if (my $ref = $sth->fetchrow_hashref()) {
					my $artDom = $dicparser->parse_string(decode_utf8($ref->{'art'}));
					$artikkel = $artDom->documentElement();
				}
			}
		}
		else {
			my $artNodes = $dicDOM->documentElement()->findnodes("${DICPR}:A[${DICPR}:G = '${g}']");
			$artCnt = $artNodes->size();
			if ($artCnt == 1) {
				$artikkel = $artNodes->get_node(1);
			}
		}
		if ($artikkel) {
			my $ms = $artikkel->findvalue(".//${DICPR}:m[1]");
			$opMs .= "; ${ms}";
			$nStatus = 0;

			my $omanik = $artikkel->ownerDocument;

			if ($opType eq 'DA') { # artikli kustutamine

				# 'kustutaja ja kustutamise aeg
				my $addNode;
				my $addNodes = $artikkel->findnodes("${DICPR}:X");
				if ($addNodes->size() == 0) {
					$addNode = $artikkel->appendChild( $omanik->createElementNS( $DICURI, "${DICPR}:X" ) );
					$addNode->appendTextNode($usrName);
				}
				else {
					$addNode = $addNodes->get_node(1);
					$addNode->firstChild->setData($usrName);
				}
				$addNodes = $artikkel->findnodes("${DICPR}:XA");
				if ($addNodes->size() == 0) {
					$addNode = $artikkel->appendChild( $omanik->createElementNS($DICURI, "${DICPR}:XA") );
					$addNode->appendTextNode($nowdtstr);
				}
				else {
					$addNode = $addNodes->get_node(1);
					$addNode->firstChild->setData($nowdtstr);
				}
				# enne kustutamist paika sättida köite fail
				$artikkel->setAttributeNS($DICURI, 'KF', substr($vfn, 0, 4));

				unless ($ainultMySql) {
					unless ($deldDom) {
						$deldDom = $dicparser->parse_file($deldFile);
					}
					$deldDom->documentElement()->appendChild($artikkel);
				}

hulgiMySqlKustutamine:
				if ($qryMethod eq 'MySql') {
					$dbh->begin_work;
					my $updCmd = "UPDATE msid SET vol_nr = ${dvNr} WHERE dic_code = '${DIC_DESC}' AND G = '${g}'";
					$sth = $dbh->prepare($updCmd);
					$rcnt = $sth->execute();
					if ($rcnt > 0) {
						$TA = $nowdtstr;
						$TA =~ s/T/ /g;

						# et MySql - i ikka korrektne XML salvestuks
						$artikkel->setNamespace($DICURI, $DICPR, 0);
						my $vanaXml = $artikkel->toString;

						$artKoopiaDom->setDocumentElement($artKoopiaDom->importNode( $artikkel->cloneNode(1) ));
						my $vanaAKoopia = $artKoopiaDom->documentElement();
						foreach my $tekst ($vanaAKoopia->findnodes(".//text()")) {
							my $juhhei = $tekst->toString;
							# &amp; , muutujad + mittetähed , tõlkimine
							$juhhei = teeMs_nosKuju($juhhei);
							$tekst->setData($juhhei);
						}
						my $vanaAltXml = $vanaAKoopia->toString;

						$updCmd = "UPDATE ${DIC_DESC} SET vol_nr = ${dvNr}, X = '${usrName}', XA = '${TA}', art = " . $dbh->quote($vanaXml) . ", art_alt = " . $dbh->quote($vanaAltXml) . " WHERE ${DIC_DESC}.G = '${g}'";
						
						$sth = $dbh->prepare($updCmd);
						$rcnt = $sth->execute();
						if ($rcnt == 1) {
							$dbh->commit;
						}
						else {
							$rsp_status_node->appendTextNode($sth->errstr . ' :: ' . $updCmd);
							$dbh->rollback;
							$isError = 1;
							last; # artiklite tsüklist välja
						}
					}
					else {
						$rsp_status_node->appendTextNode($sth->errstr . ' :: ' . $updCmd);
						$dbh->rollback;
						$isError = 1;
						last; # artiklite tsüklist välja
					}
				}

				$updatedArtCount++;
				$fileUpdated = 1;
			}
			else {
				foreach my $cmdNode ($cANode->findnodes('c')) {

					my @cmdParms = split(/\x{e002}/, $cmdNode->textContent);
					$elm_xpath = $cmdParms[0];
				
					foreach my $updNode ($artikkel->findnodes($elm_xpath)) {
						if (index($seldNames . ';', '; ' . $updNode->nodeName . ';') < 0) {
							$seldNames .= '; ' . $updNode->nodeName;
						}
						if ($opType eq 'U') { #update, muuda väärtusi
							# kuulus SS1 'v.' asendus 'või'-ga; 15sept11
							my $oldText = quotemeta($cmdParms[1]);
							my $newText = $cmdParms[2];
							foreach my $txtNode ($updNode->findnodes('text()')) {
								my $txt = $txtNode->textContent;
								if ($txt =~ s/$oldText/$newText/g) {
									$txtNode->setData($txt);
									$nStatus = 1;
								}
							}
							if ($DIC_DESC eq 'sp_' && ($updNode->nodeName eq "${DICPR}:ml")) {
								my $isLetterLaRuOrDigit = "0123456789" . $REG_LETT_LA . $REG_LETT_RU;
								my $sMall = '';																						# mall
								my $uusTekst = $newText;
								$uusTekst =~ s/ /_/g;
								for ($i = 0; $i < length($uusTekst); $i++) {
									if (index($isLetterLaRuOrDigit, substr($uusTekst, $i, 1)) < 0) {
										if (index(".'(){}", substr($uusTekst, $i, 1)) < 0) {
											$sMall .= substr($uusTekst, $i, 1);
										}
									}
								}
								$updNode->setAttributeNS($DICURI, 'mm', $sMall);
							}
							if (index($tehted . ';', '; ' . $newText . ';') < 0) {
								$tehted .= '; ' . $newText;
							}
						} # U
						elsif ($opType eq 'DD') { # delete direct, otse kustutamine
							my $minOcc = $cmdParms[1];
							my $pNode = $updNode->parentNode;
							if ($pNode->findnodes($updNode->nodeName)->size() > $minOcc) {
								$pNode->removeChild($updNode);
								if ($pNode->findnodes('*|text()')->size() == 0) {
									$pNode->parentNode->removeChild($pNode);
								}
								$nStatus = 1;
							}
						}
						elsif ($opType eq 'Rattr') { # replace Attr
							my ($attrQn, $newText, $oldText);
							$attrQn = $cmdParms[1];
							$newText = $cmdParms[2];
							$oldText = $cmdParms[3];
							if ($oldText eq '' || $oldText eq $updNode->getAttribute($attrQn)) {
								$updNode->setAttribute($attrQn, $newText);
								$nStatus = 1;
								if (index($tehted . ';', '; @' . $attrQn . '-&gt;' . $newText . ';') < 0) {
									$tehted .= '; @' . $attrQn . '-&gt;' . $newText;
								}
							}
						}
						elsif ($opType eq 'Dattr') { # delete Attr
							my ($attrQn, $newText, $oldText);
							$attrQn = $cmdParms[1];
							$newText = $cmdParms[2];
							$oldText = $cmdParms[3];
							if ($oldText eq '' || $oldText eq $updNode->getAttribute($attrQn)) {
								$updNode->removeAttribute($attrQn);
								$nStatus = 1;
								if (index($tehted . ';', '; -@' . $attrQn . ';') < 0) {
									$tehted .= '; -@' . $attrQn;
								}
							}
						}
						elsif ($opType eq 'R' || $opType eq 'A' || $opType eq 'M' || $opType eq 'D') {
							my ($ancestorName, $elemName, $elemXML, $refPath, $parentRefPath, $minOcc, $maxOcc, $gcvTekst);
							$ancestorName = $cmdParms[1]; # isaNimi: kas fatherName v grandFatherName
							$elemName = $cmdParms[2]; # valitudElement: näitab, kas on otse v mitte 'isaNimi' all
							$elemXML = $cmdParms[3];
							$refPath = $cmdParms[4];
							$parentRefPath = $cmdParms[5];
							$minOcc = $cmdParms[6];
							$maxOcc = $cmdParms[7];
							$gcvTekst = $cmdParms[8];

							my $ancestors = $updNode->findnodes("ancestor::${ancestorName}[1]");
							if ($ancestors->size() == 0) {
								if ($rsp_errs_node->textContent eq '-') {
									$rsp_errs_node->firstChild->setData($elm_xpath);
								}
								else {
									$rsp_errs_node->firstChild->setData($rsp_errs_node->textContent . '; ' . $elm_xpath);
								}
								next; # järgmise $updNode juurde
							}

							my ($kusLeidaNodes, $midaLeida, $ix, $elemDOM, $lisatav);
							$midaLeida = $elemName;
							$kusLeidaNodes = $ancestors;

							my $ancestorNode = $ancestors->get_node(1);

							# kas on mingis grupis
							$ix = index($elemName, '/');
							if ($ix > -1) {
								$midaLeida = substr($elemName, $ix + 1);
								$kusLeidaNodes = $ancestorNode->findnodes(substr($elemName, 0, $ix));
								if ($kusLeidaNodes->size() == 0) {
									my $refNode = $ancestorNode->findnodes($parentRefPath)->get_node(1);
									$ancestorNode->insertBefore($dicDOM->createElementNS($DICURI, substr($elemName, 0, $ix)), $refNode);
									$kusLeidaNodes = $ancestorNode->findnodes(substr($elemName, 0, $ix));
								}
							}
							
							if ($opType ne 'D') {
								$elemDOM = $dicparser->parse_string($elemXML);
								$lisatav = $elemDOM->documentElement();
							}

							if ($opType eq 'R') { #replace
								foreach my $kusLeidaNode ($kusLeidaNodes->get_nodelist()) {
									my $elemNodes = $kusLeidaNode->findnodes("${midaLeida}${gcvTekst}");
									foreach my $elemNode ($elemNodes->get_nodelist()) {
										$kusLeidaNode->replaceChild($lisatav->cloneNode(1), $elemNode);
										$nStatus = 1;
										if (index($tehted . ';', '; =' . $elemName . '-&gt;' . $lisatav->textContent . ';') < 0) {
											$tehted .= '; =' . $elemName . '-&gt;' . $lisatav->textContent;
										}
									}
								}
							}
							elsif ($opType eq 'A') { #add
								foreach my $kusLeidaNode ($kusLeidaNodes->get_nodelist()) {
									my $jubaOlemas = $kusLeidaNode->findnodes($midaLeida)->size();
									if ($jubaOlemas < $maxOcc) {
										my $samaOlemas = $kusLeidaNode->findnodes("${midaLeida}${gcvTekst}")->size();
										if ($samaOlemas == 0) {																			# et mitte topelt lisada
											my $refNode;
											if ($refPath) {
												$refNode = $kusLeidaNode->findnodes($refPath)->get_node(1);
											}
											$kusLeidaNode->insertBefore($lisatav->cloneNode(1), $refNode);
											$nStatus = 1;
											if (index($tehted . ';', '; +' . $elemName . '-&gt;' . $lisatav->textContent . ';') < 0) {
												$tehted .= '; +' . $elemName . '-&gt;' . $lisatav->textContent;
											}
										}
									}
								}
							}
							elsif ($opType eq 'D') { #delete
								my $pNode;
								foreach my $delNode ( $ancestorNode->findnodes("${elemName}${gcvTekst}") ) {
									$pNode = $delNode->parentNode;
									if ($pNode->findnodes($midaLeida)->size() > $minOcc) {
										$pNode->removeChild($delNode);
										if ($pNode->findnodes('*|text()')->size() == 0) {
											$pNode->parentNode->removeChild($pNode);
										}
										$nStatus = 1;
										if (index($tehted . ';', '; -' . $elemName . ';') < 0) {
											$tehted .= '; -' . $elemName;
										}
									}
								}
							}
						} # R, A, M, D
						elsif ($opType eq 'G') { # salvesta taanded
							my $grpQn = $cmdParms[1];
							my $ancestorNode = $updNode->findnodes("ancestor-or-self::${grpQn}")->get_node(1);
							my $grpXml = $cmdParms[2];
							if ($grpXml eq '') {
								# $ancestorNode->parentNode->removeChild($ancestorNode);
								# $nStatus = 1;
							}
							else {
								my $grpDom = $dicparser->parse_string($grpXml);
								if ($grpDom->documentElement()->nodeName eq $ancestorNode->nodeName) {
									my $omanik = $ancestorNode->ownerDocument;
									$ancestorNode->parentNode->replaceChild( $omanik->importNode($grpDom->documentElement()), $ancestorNode );
									$nStatus = 1;
									if (index($tehted . ';', '; ' . $grpQn . ';') < 0) {
										$tehted .= '; ' . $grpQn;
									}
								}
							}
						} # G
					} # foreach my $updNode
				} # foreach my $cmdNode
			} # else if ($opType eq 'DA') { # artikli kustutamine
			if ($nStatus) {
				my $toimetajanode = $artikkel->findnodes("${DICPR}:T")->get_node(1);
				my $refNode;
				unless ($toimetajanode) {
					$refNode = $artikkel->findnodes("${DICPR}:TA | ${DICPR}:TL | ${DICPR}:PT | ${DICPR}:PTA | ${DICPR}:X | ${DICPR}:XA")->get_node(1);
					$toimetajanode = $artikkel->insertBefore($omanik->createElement("${DICPR}:T"), $refNode);
					$toimetajanode->appendTextNode('-');
				}
				$toimetajanode->firstChild->setData($usrName);
				my $tkpnode = $artikkel->findnodes("${DICPR}:TA")->get_node(1);
				unless ($tkpnode) {
					$refNode = $artikkel->findnodes("${DICPR}:TL | ${DICPR}:PT | ${DICPR}:PTA | ${DICPR}:X | ${DICPR}:XA")->get_node(1);
					$tkpnode = $artikkel->insertBefore($omanik->createElement("${DICPR}:TA"), $refNode);
					$tkpnode->appendTextNode('-');
				}
				$tkpnode->firstChild->setData($nowdtstr);

				if ($qryMethod eq 'MySql') {

					use Data::GUID;

					my ($md, $mTekstid, $ms_lang, $ms_nos, $uusO, $ms_att_OO);
					$uusO = $artikkel->findvalue("${fdArt}/\@${DICPR}:O");
					$md = '';

					$dbh->begin_work;
					
					my $delCmd = "DELETE FROM msid WHERE dic_code = '${DIC_DESC}' AND G = '${g}'";
					$sth = $dbh->prepare($delCmd);
					$rcnt = $sth->execute();
					if ($rcnt > 0) {
						# märksõnad globaalselt; VSL-is on nt märksõnad ka nn allartiklis <AA>
						foreach my $mElem ($artikkel->findnodes(".//${qn_ms}")) {
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
										G = '${g}'";
							$insCmd =~ s/\s+/ /g;
							$sth = $dbh->prepare($insCmd);
							$rcnt = $sth->execute();
							unless ($rcnt == 1) {
								$rsp_status_node->appendTextNode($sth->errstr . ' :: ' . $insCmd);
								$dbh->rollback;
								$isError = 1;
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

							$artikkel->setNamespace($DICURI, $DICPR, 0);
							$ms_att_OO = translate_ms_att_O($uusO);

							my $updCmd = "UPDATE ${DIC_DESC} SET md = " . $dbh->quote($md) . ", ms_att_O = '${uusO}', ms_att_OO = '${ms_att_OO}'";
							my $KL = $artikkel->findvalue("${DICPR}:KL");
							if ($KL) {
								$KL =~ s/T/ /g;
								$updCmd .= ", KL = '${KL}'";
							}
							else {
								$updCmd .= ", KL = NULL";
							}
							$updCmd .= ", T = '${usrName}', TA = '${TA}'";
							my $TL = $artikkel->findvalue("${DICPR}:TL");
							if ($TL) {
								$TL =~ s/T/ /g;
								$updCmd .= ", TL = '${TL}'";
							}
							else {
								$updCmd .= ", TL = NULL";
							}
							my $PT = $artikkel->findvalue("${DICPR}:PT");
							if ($PT) {
								$updCmd .= ", PT = '${PT}'";
							}
							else {
								$updCmd .= ", PT = NULL";
							}
							my $PTA = $artikkel->findvalue("${DICPR}:PTA");
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
							my $uusXml = $artikkel->toString;
							$artKoopiaDom->setDocumentElement($artKoopiaDom->importNode( $artikkel->cloneNode(1) ));
							my $uusAKoopia = $artKoopiaDom->documentElement();
							foreach my $tekst ($uusAKoopia->findnodes(".//text()")) {
								my $juhhei = $tekst->toString;
								# &amp; , muutujad + mittetähed , tõlkimine
								$juhhei = teeMs_nosKuju($juhhei);
								$tekst->setData($juhhei);
							}
							my $uusAltXml = $uusAKoopia->toString;
							$updCmd .= ", art = " . $dbh->quote($uusXml) . ", art_alt = " . $dbh->quote($uusAltXml) . " WHERE ${DIC_DESC}.G = '${g}'";
							$updCmd =~ s/\s+/ /g;
							
							$sth = $dbh->prepare($updCmd);
							$rcnt = $sth->execute();
							if ($rcnt == 1) {

								my $lisaViga = 0;

								if ($mySqlDataVer eq '2') {
									$delCmd = "DELETE FROM elemendid_${DIC_DESC} WHERE G = '${g}'";
									$sth = $dbh->prepare($delCmd);
									$rcnt = $sth->execute();

# järgnevaid pole vaja seetõttu, et võibolla on osadel sõnastikel 'elemendid/atribuudid' tabelid täitmata
#									if ($rcnt > 0) {
										$delCmd = "DELETE FROM atribuudid_${DIC_DESC} WHERE G = '${g}'";
										$sth = $dbh->prepare($delCmd);
										$rcnt = $sth->execute();

#										if ($rcnt > 0) {
											my $bulkElCmd = '';
											my $bulkAttCmd = '';

											my $mitteElemendid = "õ";
											foreach my $el ($artikkel->findnodes("descendant::*[text()]")) {
												unless ((';' . $el->localname . ';') =~ /$mitteElemendid/) {
													my $val = '';
													foreach my $elText ($el->findnodes('text()')) {
														$val .= $elText->toString; #nt textContent: '&amp;' -> '&', aga salvestada kõik XML kujul
													}
													my $val_nos = teeMs_nosKuju($val);
													my $rada = teeLihtRada($el);
													my $nimi = $el->nodeName;
													my $elG = Data::GUID->new();

													$bulkElCmd .= ',(' . $dbh->quote($elG) . ',' . $dbh->quote($nimi) . ',' . $dbh->quote($rada) . ',' . $dbh->quote($val) . ',' . $dbh->quote($val_nos) . ',' . $dbh->quote($g) . ')';

													foreach my $elAtt ($el->attributes()) {
														unless ($elAtt->prefix eq 'xmlns' || $elAtt->localname eq 'O') {
															# siin "textContent", atribuudid on enamasti valikuga ja neis pole nt HTML muutujaid
															my $elAttVal = $elAtt->textContent; # atribuutide korral annab toString: p:i="1", aga ka raha märk '¤' läheb &xA4;
															my $elAttVal_nos = teeMs_nosKuju($elAttVal);
															my $elAttNimi = $elAtt->nodeName;

															$bulkAttCmd .= ',(' . $dbh->quote($elG) . ',' . $dbh->quote($elAttNimi) . ',' . $dbh->quote($nimi) . ',' . $dbh->quote($elAttVal) . ',' . $dbh->quote($elAttVal_nos) . ',' . $dbh->quote($g) . ')';
														}
													}
												}
											} # foreach el
#											$dbh->do("SET unique_checks = 0");

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
#											$dbh->do("SET unique_checks = 1");
#										}
#										else {
#											$rsp_status_node->appendTextNode($sth->errstr . ' :: ' . $delCmd);
#											$lisaViga = 2;
#										}
#									}
#									else {
#										$rsp_status_node->appendTextNode($sth->errstr . ' :: ' . $delCmd);
#										$lisaViga = 1;
#									}
								}
								if ($lisaViga == 0) {
									$dbh->commit;
								}
								else {
									$dbh->rollback;
									$isError = 1;
									last; # artiklite tsüklist välja
								}
							}
							else {
								$rsp_status_node->appendTextNode($sth->errstr . ' :: ' . $updCmd);
								$dbh->rollback;
								$isError = 1;
								last; # artiklite tsüklist välja
							}
						}
						else {
							$isError = 1;
							last; # artiklite tsüklist välja
						}
					}
					else {
						$rsp_status_node->appendTextNode($sth->errstr . ' :: ' . $delCmd);
						$dbh->rollback;
						$isError = 1;
						last; # artiklite tsüklist välja
					}
				}
				$updatedArtCount++;
				$fileUpdated = 1;
			} # if ($nStatus) {
		} # if ($artikkel) {
		$lastVfn = $vfn;
	} # foreach my $cANode

	if ($ainultMySql) {
		$rsp_status_node->firstChild->setData("Success");
		$rsp_count_node->firstChild->setData($updatedArtCount);
	}
	else {
		if ($isOpen) {
			if ($fileUpdated) {
				unless ($isError) {
					if ($dicDOM->toFile($backupFile, 0)) {
						copy( $xmlFile, "backup/hulgi/" . substr($vfn, 0, 4) . "_${aeg}_${usrName}.xml" ) or die "Copy failed: $!";

	# Win32 all on iga thread omaette protsess, seepärast lock vabastada LibXML-le, muidu ei pääse ligi
						if ($^O eq 'MSWin32') {
							flock(XMLF, LOCK_UN);
						}
						unless ($dicDOM->toFile($xmlFile, 0)) {
							$rsp_status_node->firstChild->setData("Server error writing file '${xmlFile}' (${cmdId})! See admin!");
						}
						else {
							$fileUpdated = 0;
							$rsp_status_node->firstChild->setData("Success");
							$rsp_count_node->firstChild->setData($updatedArtCount);
						}
					}
					else {
						$rsp_status_node->firstChild->setData("Server error writing backup file '${backupFile}' (${cmdId})! Try again!");
					}
				}
			}
			close(XMLF);
			$isOpen = 0;
			if ($deldDom) {
				my $ss = $xslt->parse_stylesheet($sortXSL);
				$deldDom = $ss->transform($deldDom);
				if ($deldDom->toFile($backupDeldFile, 0)) {
					unless ($deldDom->toFile($deldFile, 0)) {
						$rsp_status_node->firstChild->setData("Server error writing destination file '${deldFile}' (${cmdId})! See admin!");
					}
				}
				else {
					$rsp_status_node->firstChild->setData("Server error writing destination backup file '${backupDeldFile}' (${cmdId})! Try again!");
				}
			}
		}
	}
	$opMs = "'" . substr($opMs, 2) . "'";
	$seldNames = '&lt;' . substr($seldNames, 2) . '&gt;';
	$tehted = substr($tehted, 2);
	if ($opType eq 'U') {
		$artMuudatused = "'${seldNames} - muuda väärtusi: ${tehted}.'";
	}
	elsif ($opType eq 'DD') {
		$artMuudatused = "'${seldNames} - kustuta.'";
	}
	elsif ($opType eq 'R') {
		$artMuudatused = "'${seldNames} - asenda element: ${tehted}.'";
	}
	elsif ($opType eq 'A') {
		$artMuudatused = "'${seldNames} - lisa element: ${tehted}.'";
	}
	elsif ($opType eq 'D') {
		$artMuudatused = "'${seldNames} - kustuta element: ${tehted}.'";
	}
	elsif ($opType eq 'G') {
		$artMuudatused = "'${seldNames} - muuda gruppe: ${tehted}.'";
	}
	elsif ($opType eq 'Rattr') {
		$artMuudatused = "'${seldNames} - asenda/lisa atribuut: ${tehted}.'";
	}
	elsif ($opType eq 'Dattr') {
		$artMuudatused = "'${seldNames} - kustuta atribuut: ${tehted}.'";
	}
	elsif ($opType eq 'DA') {
		$artMuudatused = "'kustuta artikkel.'";
	}
	else {
		$artMuudatused = "'no on midagi jälle uut tehtud ... (${opType}).'";
	}
}
elsif ($cmdId eq 'exsaGetField') {
	my $confFile = "../exsas/sqnastikud.xml";
	my $xpath= $parms[4];
	my $ln = substr($xpath, rindex($xpath, '/') + 1);
	my $dictsDOM = $dicparser->parse_file($confFile);
	my $retVal = $dictsDOM->documentElement()->findvalue($xpath);

	# kutsutakse nagunii ainult EXSA korral välja ...
	if ($ln eq 'ptd' && $usrName eq $exsaAdminDisplayName) {
		$retVal .= $usrName . ';';
	}
	if ($ln eq 'creator' && $usrName eq $exsaAdminDisplayName) {
		$retVal = $usrName;
	}

	my $answer = $responseDOM->documentElement()->appendChild($responseDOM->createElement('answer'));
	$answer->appendTextNode($retVal);
	$rsp_status_node->appendTextNode("Success");
	$rsp_count_node->appendTextNode("1");
}
elsif ($cmdId eq 'exsaSetField') {
	my $confFile = $parms[3];
	my $xPath= $parms[4];
	my $newVal = $parms[5];
	my $dictsDOM = $dicparser->parse_file($confFile);
	my $fld = $dictsDOM->documentElement()->findnodes($xPath)->get_node(1);
	unless ($fld) {
		my $slashPos = rindex($xPath, '/');
		my $parentEl;
		if ($slashPos > -1) {
			$parentEl = $dictsDOM->documentElement()->findnodes(substr($xPath, 0, $slashPos))->get_node(1);
		}
		else {
			$parentEl = $dictsDOM->documentElement();
		}
		if ($parentEl) {
			$fld = $parentEl->appendChild($dictsDOM->createElement(substr($xPath, $slashPos + 1)));
			$fld->appendTextNode("-???-");
		}
	}
	if ($fld) {
		if ($xPath eq 'msg') {
			if ($newVal eq 'true') {
				$fld->setAttribute("type", "stop");
			}
			else {
				$fld->setAttribute("type", "trääs");
			}
		}
		else {
			if ($newVal ne 'checkOnlyExists') {
				$fld->firstChild->setData($newVal);
			}
		}
		if ($dictsDOM->toFile($confFile, 0)) {
			$rsp_status_node->appendTextNode("Success");
			$rsp_count_node->appendTextNode("1");
		}
		else {
			$rsp_status_node->appendTextNode("Failed to write '${confFile}'");
			$rsp_count_node->appendTextNode("0");
		}
	}
	else {
		$rsp_status_node->appendTextNode("Failed to locate '${xPath}' in '${$confFile}'");
		$rsp_count_node->appendTextNode("0");
	}
}
elsif ($cmdId eq 'exsaCompPw') {
	my $kood = $parms[3]; #sõnastiku kood
	my $parool = $parms[4]; #sõnastiku avamise parool
	my $dictsDOM = $dicparser->parse_file($dictsConfFile);
	my $sqn = $dictsDOM->documentElement()->findnodes("items/item[\@code = '${kood}']")->get_node(1);
	my $pw = $sqn->findvalue('pw');
	if ($usrName eq $exsaAdminDisplayName) {
		$pw = "SeeOnParool1";
	}
	if ($pw eq $parool) {
		$rsp_status_node->appendTextNode("Success");
	}
	else {
		$rsp_status_node->appendTextNode("Nomatch");
	}
	$rsp_count_node->appendTextNode("1");
}
elsif ($cmdId eq 'exsaGetInfo') {
	my $kood = $parms[3]; #sõnastiku kood
	my $dictsDOM = $dicparser->parse_file($dictsConfFile);
	my $sqn = $dictsDOM->documentElement()->findnodes("items/item[\@code = '${kood}']")->get_node(1);
	my $pw = $sqn->findvalue('pw');
	my $retStr;
	if ($pw ne '') {
		$retStr = "1";
	}
	else {
		$retStr = "0";
	}
	my $ptd = $sqn->findvalue('ptd');
	if (index($ptd, ";${usrName};") > -1) {
		$retStr .= "1";
	}
	else {
		$retStr .= "0";
	}
	my $td = $sqn->findvalue('td');
	if (index($td, ";${usrName};") > -1) {
		$retStr .= "1";
	}
	else {
		$retStr .= "0";
	}
	my $answer = $responseDOM->documentElement()->appendChild($responseDOM->createElement('answer'));
	if ($usrName eq $exsaAdminDisplayName) {
		$retStr = "110";
	}
	$answer->appendTextNode($retStr);
	$rsp_status_node->appendTextNode("Success");
	$rsp_count_node->appendTextNode("1");
}
elsif ($cmdId eq 'exsaUusSqnastik') {
	my $nimetus = $parms[3];
	my $lk = $parms[4]; # lähtekeel
	my $sk = $parms[5]; # sihtkeel
	my $pw = $parms[6]; # parool
	my $kna = $parms[7]; # koos näidisartiklitega

if ($usrName ne $exsaAdminDisplayName) {

	my $dictsDOM = $dicparser->parse_file($dictsConfFile);
	my $vkNode = $dictsDOM->documentElement()->findnodes('viimaneKood')->get_node(1);
	my $viimaneKood = $vkNode->textContent;
	my $itemsNode = $dictsDOM->documentElement()->findnodes('items')->get_node(1);
	my $itemNode = $itemsNode->appendChild($dictsDOM->createElement('item'));
	$itemNode->setAttribute("code", $viimaneKood);
	my $tempNode = $itemNode->appendChild($dictsDOM->createElement('name'));
	$tempNode->appendTextNode($nimetus);
	if ($pw ne '') {
		$tempNode = $itemNode->appendChild($dictsDOM->createElement('pw'));
		$tempNode->appendTextNode($pw);
	}
	$tempNode = $itemNode->appendChild($dictsDOM->createElement('creator'));
	$tempNode->appendTextNode($usrName);
	$tempNode = $itemNode->appendChild($dictsDOM->createElement('created'));
	$tempNode->appendTextNode($nowdtstr);
	$tempNode = $itemNode->appendChild($dictsDOM->createElement('ptd'));
	$tempNode->appendTextNode(";${usrName};");
	my $kood = $viimaneKood;
	$vkNode->firstChild->setData(++($kood));
	$dictsDOM->toFile($dictsConfFile, 0);

	use File::Path;
	use File::Copy;
	my ($dir, $fspec, $perm);
	my ($sdir, $ddir, $sfile, $dfile, $cnt);
	umask 0000;

	open (NIMEKIRI, "<", $copyConfFile) || die "can't open '${copyConfFile}': $!";
	while (<NIMEKIRI>) {
		s/\s+$//; # chomp näib reavahetuse tühikuga asendavat ...
		if (substr($_, 0, 1) eq "'") {
			next;
		}
		($dir, $fspec, $perm) = split(/\t/);
		$sdir = $dir;
		$sdir =~ s/://g;
		$ddir = $dir;
		$ddir =~ s/:\w+:/$viimaneKood/;
		$sfile = $fspec;
		$sfile =~ s/://g;
		$dfile = $fspec;
		$dfile =~ s/:\w+:/$viimaneKood/;
		if ($fspec eq '') {
			$cnt = mkpath($ddir, 0, oct($perm)); # nn 'modern' stiil on igal juhul 'verbose', PUUK ...
			if ($cnt == 0) {
				# Olgu: kataloog võib olemas olla ...
				# last;
			}
		}
		else {
			if (index($fspec, '*') > -1) {
				my @files = glob("${sdir}${sfile}");
				foreach my $file (@files) {
					my $fn = substr($file, rindex($file, '/') + 1);
					if (index($fspec, ':') > -1 || substr($fn, 0, 5) eq 'stru_') {
						$fn =~ s/ex_/$viimaneKood/;
					}
					$cnt = copy($file, "${ddir}${fn}");
					if ($cnt == 0) {
						last;
					}
					chmod(oct($perm), "${ddir}${fn}");
					if ($dir eq 'xml/:ex_:/') {
						if (substr($fn, 0, 3) eq 'ag_' || substr($fn, 0, 5) eq 'stru_') {
							my $xmlFile = $dicparser->parse_file("${ddir}${fn}");
							
							############################################################
							my $xmlLangs = $xmlFile->documentElement()->findnodes("descendant-or-self::*[\@xml:lang]");
							my $jnr;
							for ($jnr = 1; $jnr <= $xmlLangs->size(); $jnr++) {
								my $xmlLangNode = $xmlLangs->get_node($jnr);
								my $xmlLangVal = $xmlLangNode->getAttribute("xml:lang");
								if ($xmlLangNode->nodeName eq "x:sr") {
									$xmlLangNode->setAttribute("xml:lang", $lk);
								}
								elsif ($xmlLangVal eq "ex") {
									$xmlLangNode->setAttribute("xml:lang", $sk);
								}
							}
							##############################################################
							
							unless ($xmlFile->toFile("${ddir}${fn}", 0)) {
								$cnt = 0;
							}
						}
					}
				}
			}
			else {
				if ($dir eq '__sr/:ex_:/') {
					my $ex_1_DOM = $dicparser->parse_file("${sdir}${sfile}");
					my $copyDOM;
					# näidisartiklitega ja lähtekeel on eesti keel
					if ($kna eq '1' && $lk eq 'et') {
						$copyDOM = $ex_1_DOM;
					}
					else {
						$copyDOM = XML::LibXML::Document->createDocument( "1.0", "UTF-8" );
						$copyDOM->setDocumentElement($copyDOM->importNode( $ex_1_DOM->documentElement()->cloneNode(0) ));
					}

					##############################################################
					my $xmlLangs = $copyDOM->documentElement()->findnodes("descendant-or-self::*[\@xml:lang]");
					my $jnr;
					for ($jnr = 1; $jnr <= $xmlLangs->size(); $jnr++) {
						my $xmlLangNode = $xmlLangs->get_node($jnr);
						my $xmlLangVal = $xmlLangNode->getAttribute("xml:lang");
						if ($xmlLangNode->nodeName eq "x:sr") {
							$xmlLangNode->setAttribute("xml:lang", $lk);
						}
						elsif ($xmlLangVal eq "ex") {
							$xmlLangNode->setAttribute("xml:lang", $sk);
						}
					}
					##############################################################
					
					$cnt = 1;
					unless ($copyDOM->toFile("${ddir}${dfile}", 0)) {
						$cnt = 0;
					}
					if ($cnt > 0) {
						chmod(oct($perm), "${ddir}${dfile}");
					}
				}
				else {
					$cnt = copy("${sdir}${sfile}", "${ddir}${dfile}");
					if ($cnt > 0) {
						chmod(oct($perm), "${ddir}${dfile}");
						if ($fspec eq 'shsconfig_:ex_:.xml') {
							my $newSHSConf = $dicparser->parse_file("${ddir}${dfile}");
							my $newNimetus = $newSHSConf->documentElement()->findnodes('nimetus')->get_node(1);
							$newNimetus->firstChild->setData($nimetus);
							my $newRootLang = $newSHSConf->documentElement()->findnodes('rootLang')->get_node(1);
							$newRootLang->firstChild->setData($lk);
							my $newDestLang = $newSHSConf->documentElement()->findnodes('destLang')->get_node(1);
							$newDestLang->firstChild->setData($sk);
							unless ($newSHSConf->toFile("${ddir}${dfile}", 0)) {
								$cnt = 0;
							}
						}
						elsif ($fspec eq ':ex_:_tyybid.xsd') {
							my $tyybidConf = $dicparser->parse_file("${ddir}${dfile}");
							$tyybidConf->documentElement()->setAttribute("targetNamespace", "http://www.eki.ee/dict/schemas/${viimaneKood}_tyybid");
							unless ($tyybidConf->toFile("${ddir}${dfile}", 0)) {
								$cnt = 0;
							}
						}
						elsif ($fspec eq 'schema_:ex_:.xsd') {
							my $schemaConf = $dicparser->parse_file("${ddir}${dfile}");
							my $tyybidNS = "http://www.eki.ee/dict/schemas/${viimaneKood}_tyybid";
							my $oldLoc = "ex_/ex__tyybid.xsd";
							my $newLoc = $oldLoc;
							$newLoc =~ s/ex_/$viimaneKood/g;
							$schemaConf->documentElement()->setAttribute("xmlns:tyybid", $tyybidNS);
							my $newImpDecl = $schemaConf->documentElement()->findnodes("xs:import[\@schemaLocation = '${oldLoc}']")->get_node(1);
							$newImpDecl->setAttribute("namespace", $tyybidNS);
							$newImpDecl->setAttribute("schemaLocation", $newLoc);
							my $z = $schemaConf->documentElement()->findnodes("xs:element[\@name = 'z']")->get_node(1);
							if ($lk eq 'ru') {
								$z->setAttribute("type", "tyybid:xzru_tyyp");
							}
							elsif ($lk eq 'de') {
								$z->setAttribute("type", "tyybid:xzde_tyyp");
							}
							my $xz = $schemaConf->documentElement()->findnodes("xs:element[\@name = 'xz']")->get_node(1);
							if ($sk eq 'ru') {
								$xz->setAttribute("type", "tyybid:xzru_tyyp");
							}
							elsif ($sk eq 'de') {
								$xz->setAttribute("type", "tyybid:xzde_tyyp");
							}
							unless ($schemaConf->toFile("${ddir}${dfile}", 0)) {
								$cnt = 0;
							}
						}
					}
				}
			}
			if ($cnt == 0) {
				last;
			}
		}
	}
	close(NIMEKIRI) || die "can't close 'sqnFailid.txt': $!";

	if ($cnt == 0) {
		$rsp_status_node->appendTextNode("Failed to create/copy '${sdir}${sfile}'");
	}
	else {
		$rsp_status_node->appendTextNode("Success");
	}
	$rsp_count_node->appendTextNode($cnt);
}
else {
	$rsp_status_node->appendTextNode("Kasutajanimi ei sobi!");
	$rsp_count_node->appendTextNode('0');
}
}
elsif ($cmdId eq 'exsaKustutaSqnastik') {

	use File::Path;

	my ($dir, $fspec, $perm);
	my ($sdir, $sfile, $cnt);

	open (NIMEKIRI, "<", $copyConfFile) || die "can't open '${copyConfFile}': $!";						# ../exsas/sqnFailid.txt
	while (<NIMEKIRI>) {
		s/\s+$//;																						# chomp näib reavahetuse tühikuga asendavat ...
		if (substr($_, 0, 1) eq "'") {
			next;
		}
		($dir, $fspec, $perm) = split(/\t/);
		$sdir = $dir;
		$sdir =~ s/:ex_:/$DIC_DESC/g;
		$sfile = $fspec;
		$sfile =~ s/:ex_:/$DIC_DESC/g;
		
		if ($fspec eq '') {																				# tegu ainult kataloogiga
			if (-e $sdir) {
				$cnt = rmtree($sdir);
				if ($cnt == 0) {
					last;
				}
			}
		}
		else {
			my $dirName = $sdir;
			if (substr($sdir, length($sdir) - 1, 1) eq '/') {
				$dirName = substr($sdir, 0 , length($sdir) - 1);
			}
			if (-e $dirName) {
				$cnt = unlink "${sdir}${sfile}";
				if ($cnt == 0) {
					last;
				}
			}
		}
		
	}
	close(NIMEKIRI) || die "can't close 'sqnFailid.txt': $!";

	if ($cnt == 0) {
		$rsp_status_node->appendTextNode("Failed to remove '${sdir}${sfile}'");
	}
	else {
		my $dictsDOM = $dicparser->parse_file($dictsConfFile);											# ../exsas/sqnastikud.xml
		my $itemNode = $dictsDOM->documentElement()->findnodes("items/item[\@code = '${DIC_DESC}']")->get_node(1);
		$itemNode->parentNode->removeChild($itemNode);
		my $toIndentedDom = $dicparser->parse_file('xsl/tools/indented_copy.xsl');
		my $ss = $xslt->parse_stylesheet($toIndentedDom);
		$dictsDOM = $ss->transform($dictsDOM);
		$dictsDOM->toFile($dictsConfFile, 0);
		$rsp_status_node->appendTextNode("Success");
	}
	$rsp_count_node->appendTextNode($cnt);
}
elsif ($cmdId eq 'getTextFileContent') {
	my $textFile = $parms[3];
	$textFile = encode("cp-1257", $textFile);

	my $retStr = '';
	if (-e $textFile) {
		if (open (MYTEXT, "<", $textFile)) {
			while (<MYTEXT>) {
				$retStr .= $_;
			}
			close(MYTEXT);
			my $answer = $responseDOM->documentElement()->appendChild($responseDOM->createElement('answer'));
			$answer->appendTextNode(encode_utf8($retStr));
			$rsp_status_node->appendTextNode("Success");
		}
		else {
			$rsp_status_node->appendTextNode("Failed to open '${textFile}', (${cmdId})!");
		}
	}
	else {
		$rsp_status_node->appendTextNode("Failed to find '${textFile}', (${cmdId})!");
	}
	$rsp_count_node->appendTextNode(length($retStr));
}
elsif ($cmdId eq 'getTextFileCDATA') {
	my $textFile = $parms[3];
	$textFile = encode("cp-1257", $textFile);

	my $retStr = '';
	if (-e $textFile) {
		if (open (MYTEXT, "<", $textFile)) {
			while (<MYTEXT>) {
				$retStr .= $_;
			}
			close(MYTEXT);
			my $answer = $responseDOM->documentElement()->appendChild($responseDOM->createElement('answer'));
			$answer->appendTextNode('<![CDATA[' . encode_utf8($retStr) . ']]>');
			$rsp_status_node->appendTextNode("Success");
		}
		else {
			$rsp_status_node->appendTextNode("Failed to open '${textFile}', (${cmdId})!");
		}
	}
	else {
		$rsp_status_node->appendTextNode("Failed to find '${textFile}', (${cmdId})!");
	}
	$rsp_count_node->appendTextNode(length($retStr));
}
elsif ($cmdId eq 'getGUID') {
	use Data::GUID;
	my $g = Data::GUID->new();
	my $answer = $responseDOM->documentElement()->appendChild($responseDOM->createElement('answer'));
	$answer->appendTextNode($g);
	$rsp_status_node->appendTextNode("Success");
	$rsp_count_node->appendTextNode(1);
}
elsif ($cmdId eq 'getAutoInc') {
	my $nimi = $parms[3];
	my $arv = -1;
	my $autoIncFile = "__sr/${DIC_DESC}/${DIC_DESC}_autoInc.txt";

	my @dicIds;
	tie(@dicIds, 'Tie::File', $autoIncFile);

    my( $found, $index ) = ( undef, -1 );
    for(my $i = 0; $i < @dicIds; $i++ ) {
		if( $dicIds[$i] =~ /^$nimi / ) {
			$found = $dicIds[$i];
			$index = $i;
			last;
		}
    }
	if ($found) {
		$arv = substr($found, index($found, ' ') + 1);
		$arv++;
		$dicIds[$index] = "${nimi} ${arv}";
	}
	else {
		$arv = 1;
		unshift(@dicIds, "${nimi} ${arv}");
	}
	untie(@dicIds);

	my $answer = $responseDOM->documentElement()->appendChild($responseDOM->createElement('answer'));
	$answer->appendTextNode($arv);
	$rsp_status_node->appendTextNode("Success");
	$rsp_count_node->appendTextNode(1);
}
elsif ($cmdId eq 'deleteFile') {
	# parms tuleb sisse "decode_utf8($q->param('POSTDATA')"
	# failinimed on aga Balti
	my $fileName = encode('cp-1257', $parms[3]);
	if (-f $fileName) {
		my $cnt = unlink($fileName);
		if ($cnt == 1) {
			$rsp_status_node->appendTextNode("Success");
		}
		else {
			$rsp_status_node->appendTextNode("Error");
		}
		$rsp_count_node->appendTextNode($cnt);
	}
	else {
		$rsp_status_node->appendTextNode("Failed to find '${fileName}', (${cmdId})!");
		$rsp_count_node->appendTextNode("0");
	}
}
elsif ($cmdId eq 'getFilesInfo') {
	# parms tuleb sisse "decode_utf8($q->param('POSTDATA')"
	# failinimed on aga Balti
	my $dirName = encode('cp-1257', $parms[3]);
	if (opendir(my $dirh, $dirName)) {
		my @fsiEntries = readdir($dirh);
		closedir($dirh);
		# @fsiEntries = sort {$a cmp $b} @fsiEntries;
		my ($fElem, $nElem, $n, $tElem, $sElem, $dElem);
		foreach my $fsi (@fsiEntries) {
			$fElem = $outDOM->documentElement()->appendChild($outDOM->createElement('fsi'));
			$nElem = $fElem->appendChild($outDOM->createElement('n'));
			# peaks tulema UTF8
			$n = decode("cp-1257", $fsi);
			$nElem->appendTextNode($n);
			$tElem = $fElem->appendChild($outDOM->createElement('t'));
			if (-d "${dirName}/${fsi}") {
				$tElem->appendTextNode('dir');
				$sElem = $fElem->appendChild($outDOM->createElement('s'));
				$dElem = $fElem->appendChild($outDOM->createElement('d'));
			}
			else {
				$tElem->appendTextNode('file');
				my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks) = stat("${dirName}/${fsi}");
				$sElem = $fElem->appendChild($outDOM->createElement('s'));
				$sElem->appendTextNode($size);
				$dElem = $fElem->appendChild($outDOM->createElement('d'));
				my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($mtime);
				my $ts = sprintf("%04d-%02d-%02d %02d:%02d:%02d", $year + 1900, $mon + 1, $mday, $hour, $min, $sec);
				$dElem->appendTextNode($ts);
			}
		}
		my $fsiSortXSL = $dicparser->parse_file('xsl/fsiOrder.xsl');
		my $ss = $xslt->parse_stylesheet($fsiSortXSL);
		$outDOM = $ss->transform($outDOM);
		$rsp_status_node->appendTextNode("Success");
		$rsp_count_node->appendTextNode(scalar(@fsiEntries));
		$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));
	}
	else {
		$rsp_status_node->appendTextNode("Error: " . $dirName);
		$rsp_count_node->appendTextNode(0);
	}
}
elsif ($cmdId eq 'getFiles') {
	$rsp_status_node->appendTextNode("Success");
	my @files = glob("${parms[3]}${parms[4]}");
	if (scalar(@files) > 0) {
		my $fElem;
		foreach my $file (@files) {
			$fElem = $outDOM->documentElement()->appendChild($outDOM->createElement('f'));
			my $n = decode("cp-1257", $file);
			$fElem->appendTextNode(substr($n, rindex($n, '/') + 1));
#			$fElem->appendTextNode($file);
		}
		$rsp_count_node->appendTextNode(scalar(@files));
		$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));
	}
	else {
		$rsp_count_node->appendTextNode(0);
	}
}
elsif ($cmdId eq "readXML") {
	my $xmlFile = $parms[3];
	my $xPath = $parms[4];
	my $xmlDom = $dicparser->parse_file($xmlFile);
	my $nodes = $xmlDom->documentElement()->findnodes($xPath);
	for ($i = 1; $i <= $nodes->size(); $i++) {
		$outDOM->documentElement()->appendChild($nodes->get_node($i)->cloneNode(1));
	}
	$rsp_status_node->appendTextNode("Success");
	$rsp_count_node->appendTextNode($nodes->size());
	$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));
}
elsif ($cmdId eq "findReplace_Find_MySQL") { # sõnapered
	$qrySql = $parms[4];
	my $elm_xpath = $parms[5];
	$fSrchPtrn = $parms[6];
	$fSubstPtrn = $parms[7];

	my $respStr = '';
	if ($qryMethod eq 'MySql') {
		$sth = $dbh->prepare($qrySql);
		$sth->execute();
		my $artikleid = $sth->rows;

		$respStr = "<sr xmlns:${DICPR}=\"${DICURI}\">";
		$respStr .= teeHulgiAsjad($sth, $elm_xpath);
		$respStr .= "</sr>";
		$sth->finish();

		if ($artsCount < $artikleid) {
			$artsCount .= '+';
		}

		$qryDOM = $dicparser->parse_string($respStr);
		$outDOM->documentElement()->appendChild($outDOM->importNode($qryDOM->documentElement()));
		$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));
	}

	$rsp_status_node->appendTextNode("Success");
	$rsp_count_node->appendTextNode($artsCount);
}
elsif ($cmdId eq "findReplace_Find_XML") { # sõnapered
	my $volsStr = $parms[3];
	$art_xpath = $parms[4];
	my $elm_xpath = $parms[5];
	$fSrchPtrn = $parms[6];
	$fSubstPtrn = $parms[7];

	my $xsldom = $dicparser->parse_file('xsl/getTaanded.xsl');
	$xsldom->documentElement()->setNamespace($DICURI, 'al', 0);
	$xsldom->documentElement()->setNamespace($DICURI, $DICPR, 0);

	my $xslnode = $xsldom->documentElement()->findnodes("xsl:template[\@match = 'al:sr']/sr/xsl:apply-templates")->get_node(1);
	$xslnode->setAttribute("select", $art_xpath);
	$xslnode = $xsldom->documentElement()->findnodes("xsl:template[\@match = 'al:A']/A/xsl:for-each")->get_node(1);
	$xslnode->setAttribute("select", $elm_xpath);
	
	my $ss = $xslt->parse_stylesheet($xsldom);
	
	my $pathBase;
	my $xmlFile;
	my $artCount = 0;
	my $qryCount = 0;

	$pathBase = "__sr/${DIC_DESC}";

	my @xmlFiles = split(/\|/, $volsStr);
	my ($xmlFile, $fn);
	for ($i = 0; $i < scalar(@xmlFiles); $i++) {
		$fn = $xmlFiles[$i] . '.xml';
		$xmlFile = "${pathBase}/${fn}";

		if (open(XMLF, '<:utf8', $xmlFile)) {
			if (flock(XMLF, $lockType)) {
				$dicDOM = $dicparser->parse_file($xmlFile);
				$qryDOM = $ss->transform($dicDOM, dic_desc => "'${DIC_DESC}'", volFile => "'${fn}'");
				flock(XMLF, LOCK_UN);
				$nStatus = 1;
			}
			close(XMLF);
		}
		if ($nStatus == 1) {
			$artCount = $qryDOM->documentElement()->childNodes->size();
			$qryCount += $artCount;

			if ($artCount > 0) {
				if ($qryCount < 5000) {
					# ja cloneNode peab vist olema, muidu ei oska ta enam atribuuti kirjutada outDOM - le
					$outDOM->documentElement()->appendChild($outDOM->importNode($qryDOM->documentElement()));
				}
				else {
					$qryCount .= '+';
					last;
				}
			}
		}
		else {
			last;
		}
	}
	
	$rsp_status_node->appendTextNode("Success");
	$rsp_count_node->appendTextNode($qryCount);
	$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));
}
elsif ($cmdId eq "findReplace_CompElements") { # sp_
	my $volsStr = $parms[3];
	$qrySql = $parms[4];
	my $elm_xpath = $parms[5]; # ".//p:ml[xmlRegex(.) > 0]"
	$fSrchPtrn = $parms[6];
	$fSubstPtrn = $parms[7];
	if ($fSubstPtrn) {
		$fSubstPtrn = $noLetters;
	}

	my $erinevaid = 0;
	my $jnr = 0;
	my $maxArtikleid = 300;

	if ($qryMethod eq 'MySql') {
		$sth = $dbh->prepare($qrySql);
		$sth->execute();
		my $artikleid = $sth->rows;

		my ($md, $g, $viimane_vol_nr, $viimaneArt);
		my @leiud;

#		open(XMLF, '>:utf8', "temp/vals.txt");

		while (my $ref = $sth->fetchrow_hashref()) {

			if ($jnr < $maxArtikleid) {

				$jnr++;

				$viimane_vol_nr = $ref->{'vol_nr'};
				$g = $ref->{'G'};

				$md = decode_utf8($ref->{'md'});
				$viimaneArt = decode_utf8($ref->{'art'});

				my $artDom = $dicparser->parse_string($viimaneArt);
				foreach my $leid ($xpc->findnodes($elm_xpath, $artDom->documentElement())) { # leitakse .//p:ml

					my $leiuRida = "<A>";
					$leiuRida .= "<md>${md}</md>";
					$leiuRida .= "<G>${g}</G>";
					$leiuRida .= "<vf>${DIC_DESC}${viimane_vol_nr}.xml</vf>";

					$leiuRida .= "<l>";

						$leiuRida .= "<e>" . $leid->nodeName . "</e>";
						my $tekst = $leid->textContent;
						$leiuRida .= "<t>${tekst}</t>";

						$tekst = teeMs_nosKuju($tekst);
						$leiuRida .= "<t_nos>${tekst}</t_nos>";

#						print(XMLF "md='${md}'; t_nos='${tekst}'\n");

						# hom nr ka, et samasugustel vahet teha; 21. august 2011
						$leiuRida .= "<i>" . $leid->getAttribute("${DICPR}:i") . "</i>";

						$leiuRida .= "<r>" . teeRada($leid) . "</r>";

						my $esiVanem = $leid->parentNode->parentNode;
						$leiuRida .= "<gf>";
							$leiuRida .= $esiVanem->toString;
						$leiuRida .= "</gf>";
						$leiuRida .= "<gf_no_qsg>";
							foreach my $kustuta ($esiVanem->findnodes(".//p:qsg")) {
								$kustuta->parentNode->removeChild($kustuta);
							}
							$leiuRida .= $esiVanem->toString;
						$leiuRida .= "</gf_no_qsg>";

					$leiuRida .= "</l>";
					$leiuRida .= "</A>";
					push(@leiud, $tekst . '_____'. $leiuRida);

				} # foreach my $leid

			} # if ($jnr < $maxArtikleid) {
			else {
				last;
			}
		} # while ($ref = $sth->fetchrow_hashref()) {

		$sth->finish();

		@leiud = sort(@leiud);
		my $respStr = "<sr xmlns:${DICPR}=\"${DICURI}\">";
		for (my $ix = 0; $ix < scalar(@leiud); $ix++) {
			$respStr .= substr($leiud[$ix], index($leiud[$ix], '_____') + 5 );
		}
		$respStr .= "</sr>";
		$qryDOM = $dicparser->parse_string($respStr);
#		$qryDOM->toFile("temp/qry.xml");

		my ($ml, $gf);
		my $lastMl = '';
		my $lastGf = '';
		my $tehtud = 0;

		$respStr = "<sr xmlns:${DICPR}=\"${DICURI}\">";
		foreach my $lNode ($qryDOM->documentElement()->findnodes('A')) {
			$ml = $lNode->findnodes('l/t_nos')->get_node(1)->textContent; # t, "textContent", et saaks hiljem 'findnodes()'
			$gf = $lNode->findnodes('l/gf_no_qsg')->get_node(1)->toString; # gf_no_qsg
#			print(XMLF "t='${ml}'; gf='${gf}'\n");
			if ($ml eq $lastMl) {
				if ($tehtud == 0) {
					if ($gf ne $lastGf) {
						$erinevaid++;
						foreach my $diffNode ($qryDOM->documentElement()->findnodes("A[l/t_nos = '${ml}']")) {
#							$outDOMSr->appendChild($outDOM->importNode( $diffNode ));
							$respStr .= $diffNode->toString;
						}
						$tehtud = 1;
					}
				}
			}
			else {
				$tehtud = 0;
				$lastMl = $ml;
				$lastGf = $gf;
			}
		}
		$respStr .= "</sr>";
		$qryDOM = $dicparser->parse_string($respStr);
#		$qryDOM->toFile("temp/erinevad.xml");

#		$outDOM = $dicparser->parse_string($outXML);
		$outDOM->documentElement()->appendChild($outDOM->importNode( $qryDOM->documentElement() ));

#		close(XMLF);

		if ($jnr < $artikleid) {
			$erinevaid .= '+';
		}

		$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));
	}

	$rsp_status_node->appendTextNode("Success");
	$rsp_count_node->appendTextNode($erinevaid);
#	$responseDOM->toFile("temp/rsp.xml");
}
elsif ($cmdId eq "findReplace_Yksikud") { # sp_
	my $volsStr = $parms[3];
	$qrySql = $parms[4];
	my $elm_xpath = $parms[5]; # ".//p:ml[xmlRegex(.) > 0][contains(@p:mm, '_') or contains(@p:mm, '+') or contains(@p:mm, '¤')]"
	$fSrchPtrn = $parms[6];
	$fSubstPtrn = $parms[7];
	
	my $erinevaid = 0;
	my $jnr = 0;
	my $maxArtikleid = 300;

	if ($qryMethod eq 'MySql') {
		$sth = $dbh->prepare($qrySql);
		$sth->execute();
		my $artikleid = $sth->rows;

		my ($md, $g, $viimane_vol_nr, $viimaneArt);
		my @leiud;

		while (my $ref = $sth->fetchrow_hashref()) {

			if ($jnr < $maxArtikleid) {

				$jnr++;

				$viimane_vol_nr = $ref->{'vol_nr'};
				$g = $ref->{'G'};

				$md = decode_utf8($ref->{'md'});
				$viimaneArt = decode_utf8($ref->{'art'});

				my $artDom = $dicparser->parse_string($viimaneArt);
				foreach my $leid ($xpc->findnodes($elm_xpath, $artDom->documentElement())) { # leitakse .//p:ml

					my $leiuRida = "<l vf=\"${DIC_DESC}${viimane_vol_nr}.xml\">";

						$leiuRida .= "<md>${md}</md>";
						$leiuRida .= "<G>${g}</G>";

						my $tekst = $leid->textContent;
						$leiuRida .= "<to>${tekst}</to>";

						$tekst =~ s/$noLetters//g;
						$leiuRida .= "<t>${tekst}</t>";

						# hom nr ka, et samasugustel vahet teha; 21. august 2011
						$leiuRida .= "<i>" . $leid->getAttribute("${DICPR}:i") . "</i>";

						my $esiVanem = $leid->parentNode->parentNode;
						$leiuRida .= "<gfo>";
							$leiuRida .= $esiVanem->toString;
						$leiuRida .= "</gfo>";
						$leiuRida .= "<gf>";
							foreach my $kustuta ($esiVanem->findnodes(".//p:qsg")) {
								$kustuta->parentNode->removeChild($kustuta);
							}
							$leiuRida .= $esiVanem->toString;
						$leiuRida .= "</gf>";

					$leiuRida .= "</l>";

					push(@leiud, $tekst . '_____'. $leiuRida);

				} # foreach my $leid
			} # if ($jnr <= $MAX_PRINT_ARTS) {
			else {
				last;
			}
		} # while ($ref = $sth->fetchrow_hashref()) {

		$sth->finish();

		$outDOM = $dicparser->parse_string($outXML);

		@leiud = sort(@leiud);
		my $respStr = "<sr xmlns:${DICPR}=\"${DICURI}\">";
		for (my $ix = 0; $ix < scalar(@leiud); $ix++) {
			$respStr .= substr($leiud[$ix], index($leiud[$ix], '_____') + 5 );
		}
		$respStr .= "</sr>";
		$qryDOM = $dicparser->parse_string($respStr);

		my ($ml, $gf, $ix);
		my $lastMl = '';
		my $lastGf = '';
		my $kuiPaljuOli = 0;

		my $ellid = $qryDOM->documentElement()->findnodes('l');
		for ($ix = 1; $ix <= $ellid->size(); $ix++) {
			my $lNode = $ellid->get_node($ix);
			$ml = $lNode->findvalue('t');
			if ($ml ne $lastMl) {
				if ($kuiPaljuOli == 1) {
					$erinevaid++;
					$outDOM->documentElement()->appendChild($outDOM->importNode( $ellid->get_node($ix - 1) ));
				}
				$kuiPaljuOli = 1;
			}
			else {
				$kuiPaljuOli++;
			}
			$lastMl = $ml;
		}
		if ($kuiPaljuOli == 1) {
			$outDOM->documentElement()->appendChild($outDOM->importNode( $ellid->get_node($ix - 1) ));
		}

		if ($jnr < $artikleid) {
			$erinevaid .= '+';
		}

		$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));
	}

	$rsp_status_node->appendTextNode("Success");
	$rsp_count_node->appendTextNode($erinevaid);
}
elsif ($cmdId eq "findReplace_RunOps") { # SÕNAPERED

	my $cmdsDom = $dicparser->parse_string($parms[3]);
	my $opType = $cmdsDom->documentElement()->getAttribute('a'); # action
	
	my $vfn;
	my $lastVfn = '';
	my $fileUpdated = 0;

	my $updatedArtCount = 0;
	$rsp_count_node->appendTextNode('0');
	$rsp_status_node->appendTextNode('-');
	
	my $isError = 0;
	my $isOpen = 0;

	my $pathBase = "__sr/${DIC_DESC}";
	my ($xmlFile, $backupFile);
	
	my ($g, $elm_xpath);

	my $srLang = $rootLang;
	my $vNr;

	my $artKoopiaDom = XML::LibXML::Document->createDocument( "1.0", "UTF-8" );

	use File::Copy;
	my $aeg = $nowdtstr;
	$aeg =~ s/T/_/g;
	$aeg =~ s/:/\-/g;

	&valmistaSortXsl();

	foreach my $cANode ($cmdsDom->documentElement()->findnodes('cA')) {
		$vfn = $cANode->getAttribute('vf');
		$vNr = substr($vfn, 3, 1);
		$g = $cANode->getAttribute('g');
		unless ($ainultMySql) {
			if ($vfn ne $lastVfn) {
				if ($isOpen) {
					if ($fileUpdated) {
						copy( $xmlFile, "backup/hulgi/" . substr($vfn, 0, 4) . "_${aeg}_${usrName}.xml" ) or die "Copy failed: $!";
						if ($dicDOM->toFile($backupFile, 0)) {
	# Win32 all on iga thread omaette protsess, seepärast lock vabastada LibXML-le, muidu ei pääse ligi
							if ($^O eq 'MSWin32') {
								flock(XMLF, LOCK_UN);
							}
							unless ($dicDOM->toFile($xmlFile, 0)) {
								$rsp_status_node->firstChild->setData("Server error writing file '${xmlFile}' (${cmdId})! See admin!");
								$isError = 1;
								last;
							}
							else {
								$fileUpdated = 0;
							}
						}
						else {
							$rsp_status_node->firstChild->setData("Server error writing backup file '${backupFile}' (${cmdId})! Try again!");
							$isError = 1;
							last;
						}
					}
					close(XMLF);
					$isOpen = 0;
				}
				$xmlFile = "${pathBase}/${vfn}";
				$backupFile = "backup/${vfn}";
				$vNr = substr($vfn, 3, 1);
				if (open(XMLF, '<:utf8', $xmlFile)) {
					if (flock(XMLF, $lockType)) {
						$isOpen = 1;
						$dicDOM = $dicparser->parse_file($xmlFile);
					}
					else {
						$rsp_status_node->firstChild->setData("Failed to flock '${xmlFile}' (${cmdId})!");
						$isError = 1;
						last;
					}
				}
				else {
					$rsp_status_node->firstChild->setData("Failed to open '${xmlFile}' (${cmdId})!");
					$isError = 1;
					last;
				}
			}
		}

		# nüüd vaja üles leida artikkel
		my ($artCnt, $artikkel);
		if ($ainultMySql) {
			my $selectCmd = "SELECT ${DIC_DESC}.art AS art FROM ${DIC_DESC} WHERE ${DIC_DESC}.G = '${g}' AND ${DIC_DESC}.vol_nr = ${vNr}";
			my $sth = $dbh->prepare($selectCmd);
			$sth->execute();
			$artCnt = $sth->rows;
			if ($artCnt == 1) {
				if (my $ref = $sth->fetchrow_hashref()) {
					my $artDom = $dicparser->parse_string(decode_utf8($ref->{'art'}));
					$artikkel = $artDom->documentElement();
				}
			}
		}
		else {
			my $artNodes = $dicDOM->documentElement()->findnodes("${DICPR}:A[${DICPR}:G = '${g}']");
			$artCnt = $artNodes->size();
			if ($artCnt == 1) {
				$artikkel = $artNodes->get_node(1);
			}
		}

		if ($artikkel) {

			my $omanik = $artikkel->ownerDocument;

			foreach my $cmdNode ($cANode->findnodes('c')) {

				my @cmdParms = split(/\x{e002}/, $cmdNode->textContent);
				$elm_xpath = $cmdParms[0]; # //t/lag/ml[. = 'x']
			
				foreach my $updNode ($artikkel->findnodes($elm_xpath)) {
					if ($opType eq 'U') { #update
						my $newText = $cmdParms[1];
						$updNode->firstChild->setData($newText);
						if ($DIC_DESC eq 'sp_' && ($updNode->nodeName eq "${DICPR}:ml")) {
							my $isLetterLaRuOrDigit = "0123456789" . $REG_LETT_LA . $REG_LETT_RU;
							my $sMall = '';																						# mall
							my $uusTekst = $newText;
							$uusTekst =~ s/ /_/g;
							for ($i = 0; $i < length($uusTekst); $i++) {
								if (index($isLetterLaRuOrDigit, substr($uusTekst, $i, 1)) < 0) {
									if (index(".'(){}", substr($uusTekst, $i, 1)) < 0) {
										$sMall .= substr($uusTekst, $i, 1);
									}
								}
							}
							$updNode->setAttributeNS($DICURI, 'mm', $sMall);
						}
						$nStatus = 1;
					} # U
					elsif ($opType eq 'R' || $opType eq 'A' || $opType eq 'M' || $opType eq 'D') {
						my ($ancestorName, $elemName, $elemXML, $refPath, $parentRefPath, $minOcc, $maxOcc);
						$ancestorName = $cmdParms[1];
						$elemName = $cmdParms[2];
						$elemXML = $cmdParms[3];
						$refPath = $cmdParms[4];
						$parentRefPath = $cmdParms[5];
						$minOcc = $cmdParms[6];
						$maxOcc = $cmdParms[7];

						my $ancestorNode = $updNode->findnodes("ancestor::${ancestorName}[1]")->get_node(1);
						unless ($ancestorNode) {
							if ($rsp_errs_node->textContent eq '-') {
								$rsp_errs_node->firstChild->setData($elm_xpath);
							}
							else {
								$rsp_errs_node->firstChild->setData($rsp_errs_node->textContent . '; ' . $elm_xpath);
							}
							next;
						}

						my ($kusLeidaNode, $midaLeida, $ix, $elemDOM, $lisatav);
						if ($opType eq 'R' || $opType eq 'A' || $opType eq 'M') {
							$ix = index($elemName, '/');
							if ($ix > -1) {
								$midaLeida = substr($elemName, $ix + 1);
								$kusLeidaNode = $ancestorNode->findnodes(substr($elemName, 0, $ix))->get_node(1);
								unless ($kusLeidaNode) {
									my $refNode = $ancestorNode->findnodes($parentRefPath)->get_node(1);
									$kusLeidaNode = $ancestorNode->insertBefore($omanik->createElementNS($DICURI, substr($elemName, 0, $ix)), $refNode);
								}
							}
							else {
								$midaLeida .= $elemName;
								$kusLeidaNode = $ancestorNode;
							}
							$elemDOM = $dicparser->parse_string($elemXML);
							$lisatav = $elemDOM->documentElement();
						}

						if ($opType eq 'R') { #replace/add
							my $elemNode = $kusLeidaNode->findnodes($midaLeida)->get_node(1);
							if ($elemNode) {
								$kusLeidaNode->replaceChild($lisatav, $elemNode);
							}
							else {
								my $refNode;
								if ($refPath) {
									$refNode = $kusLeidaNode->findnodes($refPath)->get_node(1);
								}
								$kusLeidaNode->insertBefore($lisatav, $refNode);
							}
							$nStatus = 1;
						}
						elsif ($opType eq 'A') { #add
							my $jubaOlemas = $kusLeidaNode->findnodes($midaLeida)->size();
							if ($jubaOlemas < $maxOcc) {
								my $lisatavTekst = $lisatav->textContent;
								my $samaOlemas = $kusLeidaNode->findnodes("${midaLeida}[. = '${lisatavTekst}']")->size();
								if ($samaOlemas == 0) {																			# et mitte topelt v rohkem lisada
									my $refNode;
									if ($refPath) {
										$refNode = $kusLeidaNode->findnodes($refPath)->get_node(1);
									}
									$kusLeidaNode->insertBefore($lisatav, $refNode);
									$nStatus = 1;
								}
							}
						}
						elsif ($opType eq 'M') { #add missing
							my $jubaOlemas = $kusLeidaNode->findnodes($midaLeida)->size();
							if ($jubaOlemas == 0) {
								my $refNode;
								if ($refPath) {
									$refNode = $kusLeidaNode->findnodes($refPath)->get_node(1);
								}
								$kusLeidaNode->insertBefore($lisatav, $refNode);
								$nStatus = 1;
							}
						}
						elsif ($opType eq 'D') { #delete
							my $pNode;
							foreach my $delNode ($ancestorNode->findnodes($elemName . "[position() > ${minOcc}]")) {
								$pNode = $delNode->parentNode;
								$pNode->removeChild($delNode);
								if ($pNode->findnodes('*|text()')->size() == 0) {
									$pNode->parentNode->removeChild($pNode);
								}
							}
							if ($pNode) {
								$nStatus = 1;
							}
						}
					} # R, A, M, D
					elsif ($opType eq 'G') { # salvesta taanded
						my $ancestorNode = $updNode->findnodes("../..")->get_node(1); # t
						if ($ancestorNode->nodeName eq "${DICPR}:t") {
							my $grpXml = $cmdParms[1];
							$grpXml =~ s/%u([A-Fa-f\d]{4})/chr hex $1/eg; # unescape
							$grpXml =~ s/%([A-Fa-f\d]{2})/chr hex $1/eg; # unescape
							if ($grpXml eq '') {
								$ancestorNode->parentNode->removeChild($ancestorNode);
							}
							else {
								my $grpDom = $dicparser->parse_string($grpXml);
								$ancestorNode->parentNode->replaceChild($grpDom->documentElement(), $ancestorNode);
							}
							$nStatus = 1;
						}
					} # G
				} # foreach my $updNode
			} # foreach my $cmdNode
			if ($nStatus) {
				my $toimetajanode = $artikkel->findnodes("${DICPR}:T")->get_node(1);
				my $refNode;
				unless ($toimetajanode) {
					$refNode = $artikkel->findnodes("${DICPR}:TA | ${DICPR}:TL | ${DICPR}:PT | ${DICPR}:PTA | ${DICPR}:X | ${DICPR}:XA")->get_node(1);
					$toimetajanode = $artikkel->insertBefore($omanik->createElement("${DICPR}:T"), $refNode);
					$toimetajanode->appendTextNode('-');
				}
				$toimetajanode->firstChild->setData($usrName);
				my $tkpnode = $artikkel->findnodes("${DICPR}:TA")->get_node(1);
				unless ($tkpnode) {
					$refNode = $artikkel->findnodes("${DICPR}:TL | ${DICPR}:PT | ${DICPR}:PTA | ${DICPR}:X | ${DICPR}:XA")->get_node(1);
					$tkpnode = $artikkel->insertBefore($omanik->createElement("${DICPR}:TA"), $refNode);
					$tkpnode->appendTextNode('-');
				}
				$tkpnode->firstChild->setData($nowdtstr);

				if ($qryMethod eq 'MySql') {
					my ($md, $mTekstid, $ms_lang, $ms_nos, $uusO, $ms_att_OO);
					$uusO = $artikkel->findvalue("${fdArt}/\@${DICPR}:O");
					$md = '';

					$dbh->begin_work;
					
					my $delCmd = "DELETE FROM msid WHERE dic_code = '${DIC_DESC}' AND G = '${g}'";
					$sth = $dbh->prepare($delCmd);
					$rcnt = $sth->execute();
					if ($rcnt > 0) {
						foreach my $mElem ($artikkel->findnodes($dqArt)) {
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
										G = '${g}'";
							$insCmd =~ s/\s+/ /g;
							$sth = $dbh->prepare($insCmd);
							$rcnt = $sth->execute();
							unless ($rcnt == 1) {
								$rsp_status_node->appendTextNode($sth->errstr . ' :: ' . $insCmd);
								$dbh->rollback;
								$isError = 1;
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

							$artikkel->setNamespace($DICURI, $DICPR, 0);
							$ms_att_OO = translate_ms_att_O($uusO);

							my $updCmd = "UPDATE ${DIC_DESC} SET md = " . $dbh->quote($md) . ", 
																ms_att_O = '${uusO}', 
																ms_att_OO = '${ms_att_OO}'";
							my $KL = $artikkel->findvalue("${DICPR}:KL");
							if ($KL) {
								$KL =~ s/T/ /g;
								$updCmd .= ", KL = '${KL}'";
							}
							else {
								$updCmd .= ", KL = NULL";
							}
							$updCmd .= ", T = '${usrName}', TA = '${TA}'";
							my $TL = $artikkel->findvalue("${DICPR}:TL");
							if ($TL) {
								$TL =~ s/T/ /g;
								$updCmd .= ", TL = '${TL}'";
							}
							else {
								$updCmd .= ", TL = NULL";
							}
							my $PT = $artikkel->findvalue("${DICPR}:PT");
							if ($PT) {
								$updCmd .= ", PT = '${PT}'";
							}
							else {
								$updCmd .= ", PT = NULL";
							}
							my $PTA = $artikkel->findvalue("${DICPR}:PTA");
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
							my $uusXml = $artikkel->toString;
							$artKoopiaDom->setDocumentElement($artKoopiaDom->importNode( $artikkel->cloneNode(1) ));
							my $uusAKoopia = $artKoopiaDom->documentElement();
							foreach my $tekst ($uusAKoopia->findnodes(".//text()")) {
								my $juhhei = $tekst->toString;
								# &amp; , muutujad + mittetähed , tõlkimine
								$juhhei = teeMs_nosKuju($juhhei);
								$tekst->setData($juhhei);
							}
							my $uusAltXml = $uusAKoopia->toString;
							$updCmd .= ", art = " . $dbh->quote($uusXml) . ", 
										art_alt = " . $dbh->quote($uusAltXml) . " WHERE ${DIC_DESC}.G = '${g}'";
							$updCmd =~ s/\s+/ /g;
							
							$sth = $dbh->prepare($updCmd);
							$rcnt = $sth->execute();
							if ($rcnt == 1) {

								my $lisaViga = 0;

								if ($mySqlDataVer eq '2') {

									$delCmd = "DELETE FROM elemendid_${DIC_DESC} WHERE G = '${g}'";
									$sth = $dbh->prepare($delCmd);
									$rcnt = $sth->execute();

# järgnevaid pole vaja seetõttu, et võibolla on osadel sõnastikel 'elemendid/atribuudid' tabelid täitmata
#									if ($rcnt > 0) {
										$delCmd = "DELETE FROM atribuudid_${DIC_DESC} WHERE G = '${g}'";
										$sth = $dbh->prepare($delCmd);
										$rcnt = $sth->execute();

#										if ($rcnt > 0) {
											my $bulkElCmd = '';
											my $bulkAttCmd = '';

											my $mitteElemendid = "õ";
											foreach my $el ($artikkel->findnodes("descendant::*[text()]")) {
												unless ((';' . $el->localname . ';') =~ /$mitteElemendid/) {
													my $val = '';
													foreach my $elText ($el->findnodes('text()')) {
														$val .= $elText->toString; #nt textContent: '&amp;' -> '&', aga salvestada kõik XML kujul
													}
													my $val_nos = teeMs_nosKuju($val);
													my $rada = teeLihtRada($el);
													my $nimi = $el->nodeName;
													my $elG = Data::GUID->new();

													$bulkElCmd .= ',(' . $dbh->quote($elG) . ',' . $dbh->quote($nimi) . ',' . $dbh->quote($rada) . ',' . $dbh->quote($val) . ',' . $dbh->quote($val_nos) . ',' . $dbh->quote($g) . ')';

													foreach my $elAtt ($el->attributes()) {
														unless ($elAtt->prefix eq 'xmlns' || $elAtt->localname eq 'O') {
															# siin "textContent", atribuudid on enamasti valikuga ja neis pole nt HTML muutujaid
															my $elAttVal = $elAtt->textContent; # atribuutide korral annab toString: p:i="1", aga ka raha märk '¤' läheb &xA4;
															my $elAttVal_nos = teeMs_nosKuju($elAttVal);
															my $elAttNimi = $elAtt->nodeName;

															$bulkAttCmd .= ',(' . $dbh->quote($elG) . ',' . $dbh->quote($elAttNimi) . ',' . $dbh->quote($nimi) . ',' . $dbh->quote($elAttVal) . ',' . $dbh->quote($elAttVal_nos) . ',' . $dbh->quote($g) . ')';
														}
													}
												}
											} # foreach el
#											$dbh->do("SET unique_checks = 0");

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
#											$dbh->do("SET unique_checks = 1");
#										}
#										else {
#											$rsp_status_node->appendTextNode($sth->errstr . ' :: ' . $delCmd);
#											$lisaViga = 2;
#										}
#									}
#									else {
#										$rsp_status_node->appendTextNode($sth->errstr . ' :: ' . $delCmd);
#										$lisaViga = 1;
#									}
								}
								if ($lisaViga == 0) {
									$dbh->commit;
								}
								else {
									$dbh->rollback;
									$isError = 1;
									last; # artiklite tsüklist välja
								}
							}
							else {
								$rsp_status_node->appendTextNode($sth->errstr . ' :: ' . $updCmd);
								$dbh->rollback;
								$isError = 1;
								last; # artiklite tsüklist välja
							}
						}
						else {
							$isError = 1;
							last; # artiklite tsüklist välja
						}
					}
					else {
						$rsp_status_node->appendTextNode($sth->errstr . ' :: ' . $delCmd);
						$dbh->rollback;
						$isError = 1;
						last; # artiklite tsüklist välja
					}
				}

				$updatedArtCount++;
				$fileUpdated = 1; # faili salvestamiseks
			}
		} # if ($artNodes->size() == 1)
		$lastVfn = $vfn;
	} # foreach my $cANode

	if ($ainultMySql) {
		$rsp_status_node->firstChild->setData("Success");
		$rsp_count_node->firstChild->setData($updatedArtCount);
	}
	else {
		if ($isOpen) {
			if ($fileUpdated) {
				unless ($isError) {
					copy( $xmlFile, "backup/hulgi/" . substr($vfn, 0, 4) . "_${aeg}_${usrName}.xml" ) or die "Copy failed: $!";
					if ($dicDOM->toFile($backupFile, 0)) {
	# Win32 all on iga thread omaette protsess, seepärast lock vabastada LibXML-le, muidu ei pääse ligi
						if ($^O eq 'MSWin32') {
							flock(XMLF, LOCK_UN);
						}
						unless ($dicDOM->toFile($xmlFile, 0)) {
							$rsp_status_node->firstChild->setData("Server error writing file '${xmlFile}' (${cmdId})! See admin!");
						}
						else {
							$fileUpdated = 0;
							$rsp_status_node->firstChild->setData("Success");
							$rsp_count_node->firstChild->setData($updatedArtCount);
						}
					}
					else {
						$rsp_status_node->firstChild->setData("Server error writing backup file '${backupFile}' (${cmdId})! Try again!");
					}
				}
			}
			close(XMLF);
			$isOpen = 0;
		}
	}
}
elsif ($cmdId eq "updateXML") {
	my $xmlFile = $parms[3];
	my $xPath = $parms[4];
	my $newXML = $parms[5]; # nt 'xs:enumeration[]/ ...'
	my $newXMLDom = $dicparser->parse_string($newXML);
	my $xmlDom = $dicparser->parse_file($xmlFile);
	my $luua = $parms[6]; # tühi v "1"

	my $otsitav;
	my $nodes = $xmlDom->documentElement()->findnodes($xPath);
	if ($nodes->size() == 0) {
		if ($luua) {
			my @elems = split(/\//, $xPath);

			my $parentOtsitav = $xmlDom->documentElement();
			foreach my $elem (@elems) {
				$otsitav = $parentOtsitav->findnodes($elem . '[1]');
				unless ($otsitav) {
					$otsitav = $parentOtsitav->appendChild($xmlDom->createElement($elem));
				}
				$parentOtsitav = $otsitav;
			}
		}
	}
	elsif ($nodes->size() == 1) {
		$otsitav = $nodes->get_node(1);
	}
	if ($otsitav) {
		# xsd tüübidDom kirjutamisel nt
		if ($otsitav->isSameNode($xmlDom->documentElement())) {
			$xmlDom->setDocumentElement( $xmlDom->importNode( $newXMLDom->documentElement() ) );
		}
		else {
			$otsitav->parentNode->replaceChild($xmlDom->importNode($newXMLDom->documentElement()), $otsitav);
		}
		if ($xmlDom->toFile($xmlFile, 0)) {
			$rsp_count_node->appendTextNode("1");
			$rsp_status_node->appendTextNode("Success");
		}
		else {
			$rsp_status_node->appendTextNode("Failed to write '${xmlFile}', (${cmdId})!");
		}
	}
	else {
		$rsp_count_node->appendTextNode($nodes->size());
		$rsp_status_node->appendTextNode("Failed to locate '${xPath}' in '${xmlFile}', (${cmdId})!");
	}
}
elsif ($cmdId eq "insertBefore" || $cmdId eq "insertAfter") {
	my $xmlFile = $parms[3];
	my $xPath = $parms[4];
	my $newXML = $parms[5];
	my $newXMLDom = $dicparser->parse_string($newXML);
	my $xmlDom = $dicparser->parse_file($xmlFile);
	my $nodes = $xmlDom->documentElement()->findnodes($xPath);
	if ($nodes->size() == 1) {
		if ($cmdId eq "insertBefore") {
			$nodes->get_node(1)->parentNode->insertBefore($xmlDom->importNode($newXMLDom->documentElement()), $nodes->get_node(1));
		}
		elsif ($cmdId eq "insertAfter") {
			$nodes->get_node(1)->parentNode->insertAfter($xmlDom->importNode($newXMLDom->documentElement()), $nodes->get_node(1));
		}
#		my $xsldom = $dicparser->parse_file('xsl/tools/indented_copy.xsl');
#		my $ss = $xslt->parse_stylesheet($xsldom);
#		$xmlDom = $ss->transform($xmlDom);
		if ($xmlDom->toFile($xmlFile, 0)) {
			$rsp_status_node->appendTextNode("Success");
			$rsp_count_node->appendTextNode(1);
		}
		else {
			$rsp_status_node->appendTextNode("Failed to write '${xmlFile}', (${cmdId})!");
		}
	}
	else {
		$rsp_count_node->appendTextNode($nodes->size());
		$rsp_status_node->appendTextNode("Failed to locate '${xPath}' in '${xmlFile}', (${cmdId})!");
	}
}
elsif ($cmdId eq "removeNode") {
	my $xmlFile = $parms[3];
	my $xPath = $parms[4];
	my $xmlDom = $dicparser->parse_file($xmlFile);
	my $nodes = $xmlDom->documentElement()->findnodes($xPath);
	if ($nodes->size() == 1) {
		$nodes->get_node(1)->parentNode->removeChild($nodes->get_node(1));
#		my $xsldom = $dicparser->parse_file('xsl/tools/indented_copy.xsl');
#		my $ss = $xslt->parse_stylesheet($xsldom);
#		$xmlDom = $ss->transform($xmlDom);
		if ($xmlDom->toFile($xmlFile, 0)) {
			$rsp_status_node->appendTextNode("Success");
			$rsp_count_node->appendTextNode(1);
		}
		else {
			$rsp_status_node->appendTextNode("Failed to write '${xmlFile}', (${cmdId})!");
		}
	}
	else {
		$rsp_count_node->appendTextNode($nodes->size());
		$rsp_status_node->appendTextNode("Failed to locate '${xPath}' in '${xmlFile}', (${cmdId})!");
	}
}
elsif ($cmdId eq "getHeadWords") {

	my $xsldom = $dicparser->parse_file('xsl/gethwds.xsl');
	$xsldom->documentElement()->setNamespace($DICURI, 'al', 0);

	my $ss = $xslt->parse_stylesheet($xsldom);

	my $pathBase = $parms[3];
	my $impVolNr = $parms[4];
	my $xmlFile;
	my $artcount;

	# getHwds_ALoopmann_har1.xml
	my $getHwdsFileId = "getHwds_${usrName}_${DIC_DESC}${impVolNr}.xml";

	# __sr/har/har1.xml
	$xmlFile = "${pathBase}/${DIC_DESC}/${DIC_DESC}${impVolNr}.xml";
	if (open(XMLF, '<:utf8', $xmlFile)) {
		# if (flock(XMLF, $lockType)) {
			$dicDOM = $dicparser->parse_file($xmlFile);
			$qryDOM = $ss->transform($dicDOM, dic_desc => "'${DIC_DESC}'");
			flock(XMLF, LOCK_UN);
			$nStatus = 1;
		# }
		close(XMLF);
	}
	if ($nStatus) {
		$artcount = $qryDOM->documentElement()->childNodes->size();

		my ($newElem, $hwLimits, $artNr);
		# hwdsChunkSize: 2000
		for ($i = 1; $i <= $artcount; $i += $hwdsChunkSize) {
			$hwLimits = $qryDOM->documentElement()->findvalue("A[${i}]/md");
			$artNr = $i + $hwdsChunkSize - 1;
			if ($artNr > $artcount) {
				$hwLimits .= ' - ' . $qryDOM->documentElement()->findvalue("A[${artcount}]/md");
			}
			else {
				$hwLimits .= ' - ' . $qryDOM->documentElement()->findvalue("A[${artNr}]/md");
			}
			$newElem = $outDOM->documentElement()->appendChild($outDOM->createElement('hwl'));
			$newElem->appendTextNode($hwLimits);
		}
		$newElem = $outDOM->documentElement()->appendChild($outDOM->createElement('fId'));
		$newElem->appendTextNode($getHwdsFileId);

		$qryDOM->toFile("temp/${getHwdsFileId}", 0);

		$xsldom = $dicparser->parse_file('xsl/gethwdschunk.xsl');
		$ss = $xslt->parse_stylesheet($xsldom);
		$qryDOM = $ss->transform($qryDOM, pos1 => "'1'", pos2 => "'${hwdsChunkSize}'");

		$outDOM->documentElement()->appendChild($outDOM->importNode($qryDOM->documentElement()));

		$rsp_status_node->appendTextNode("Success");
		$rsp_count_node->appendTextNode($artcount);

		$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));
	}
	else {
		$rsp_status_node->appendTextNode("Failed to open/flock '${xmlFile}' (${cmdId})!");
	}

}
elsif ($cmdId eq "getHeadWordsChunk") {
	my $xsldom = $dicparser->parse_file('xsl/gethwdschunk.xsl');
	my $ss = $xslt->parse_stylesheet($xsldom);
	my $poss1 = (($parms[4] - 1) * $hwdsChunkSize) + 1;
	my $poss2 = $parms[4] * $hwdsChunkSize;

	my $xmlFile = "temp/${parms[3]}";
	if (open(XMLF, '<:utf8', $xmlFile)) {
		# if (flock(XMLF, $lockType)) {
			$dicDOM = $dicparser->parse_file($xmlFile);
			$qryDOM = $ss->transform($dicDOM, pos1 => "'${poss1}'", pos2 => "'${poss2}'");
			flock(XMLF, LOCK_UN);
			$nStatus = 1;
		# }
		close(XMLF);
	}
	if ($nStatus) {
		my $artcount = $qryDOM->documentElement()->childNodes->size();

		$outDOM->documentElement()->appendChild($outDOM->importNode($qryDOM->documentElement()));

		$rsp_status_node->appendTextNode("Success");
		$rsp_count_node->appendTextNode($artcount);

		$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));
	}
	else {
		$rsp_status_node->appendTextNode("Failed to open/flock '${xmlFile}' (${cmdId})!");
	}
}
elsif ($cmdId eq "xmlCopy") {

	if ($ainultMySql) {
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
	}

	use IO::Compress::Zip qw(:all);

	my @files;
	for ($i = 1; $i <= $DIC_VOLS_COUNT; $i++) {
		push @files, "__sr/${DIC_DESC}/${DIC_DESC}${i}.xml";
	}

	my $myZipFile = "temp/${DIC_DESC}_xmlKoopia_${usrName}.zip";

	zip \@files => "${myZipFile}"
		or die "zip failed: $ZipError\n";

	my $outNode = $outDOM->documentElement()->appendChild($outDOM->createElement('f'));
	$outNode->appendTextNode($myZipFile);
	$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));

	$rsp_status_node->appendTextNode("Success");
	$rsp_count_node->appendTextNode($DIC_VOLS_COUNT);
}
elsif ($cmdId eq "msLoend") {
	my $mslSql = $parms[3];
	$mslSql =~ s/\s+/ /g;

	my $msLoendFile = "temp/${DIC_DESC}_msLoend_${usrName}.txt";

	# kui määrad '>:utf8', siis peab stringi võtma ka kui 'decode_utf8'
	# PS: 'temp' kaustast saadetakse kõik text/html failid utf-8 vaikimisi kodeeringus brauserile
	open(MSLF, '>:utf8', $msLoendFile);
	if ($qryMethod eq 'MySql') {
		$sth = $dbh->prepare($mslSql);
		$sth->execute();
		my $msCnt = $sth->rows;
		while (my $ref = $sth->fetchrow_hashref()) {
			my $md = decode_utf8($ref->{'md'});
			print(MSLF ($md . "\n"));
		}
		$sth->finish();
	} else {

		my $msLoendXSL = $dicparser->parse_file('xsl/msLoend.xsl');
		$msLoendXSL->documentElement()->setNamespace($DICURI, 'al', 0);
		$msLoendXSL->documentElement()->setNamespace($DICURI, $DICPR, 0);

		my $msLoendNode = $msLoendXSL->documentElement()->findnodes("xsl:template[\@match = 'al:A']/xsl:variable[\@name = 'marksonad']/xsl:for-each[\@select = 'siinTulebAsendada']")->get_node(1);
		$msLoendNode->setAttribute("select", $dqArt);

		my $ss = $xslt->parse_stylesheet($msLoendXSL);

		my $outLoendDom = XML::LibXML::Document->createDocument( "1.0", "UTF-8" );
		$outLoendDom->setDocumentElement($outLoendDom->createElement('outLoend'));

		for ($i = 1; $i <= $DIC_VOLS_COUNT; $i++) {
		
			my $xmlFile = "__sr/${DIC_DESC}/${DIC_DESC}${i}.xml";

			if (open(XMLF, '<:utf8', $xmlFile)) {
				$dicDOM = $dicparser->parse_file($xmlFile);
				$qryDOM = $ss->transform($dicDOM);
				$nStatus = 1;
				close(XMLF);
			}
			if ($nStatus) {
				# mitu sr - i, $qryDOM - i mitte puutuda
				$outLoendDom->documentElement()->appendChild($outLoendDom->importNode($qryDOM->documentElement()));
			}
			else {
				last;
			}
		} # for ($i; $i <= $j; $i++) {

		if ($nStatus) {
#			$outLoendDom->toFile("temp/${DIC_DESC}_msLoend_${usrName}_dom.xml", 0);
#			print(MSLF ($outLoendDom->documentElement()->textContent));
			foreach my $mElem ($outLoendDom->documentElement()->findnodes('sr/md')) {
				print(MSLF ($mElem->textContent . "\n"));
			}
		}
	}
	close(MSLF);

	my $outNode = $outDOM->documentElement()->appendChild($outDOM->createElement('f'));
	$outNode->appendTextNode($msLoendFile);
	$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));

	$rsp_status_node->appendTextNode("Success");
	$rsp_count_node->appendTextNode($DIC_VOLS_COUNT);
}
elsif ($cmdId eq "oxfordDudenSisukord") {
	my $xsldom = $dicparser->parse_file('xsl/odSisukord.xsl');
	my $ss = $xslt->parse_stylesheet($xsldom);

	my $xmlFile = "__sr/od_/od_1.xml";
	if (open(XMLF, '<:utf8', $xmlFile)) {
		if (flock(XMLF, $lockType)) {
			$dicDOM = $dicparser->parse_file($xmlFile);
			$qryDOM = $ss->transform($dicDOM);
			flock(XMLF, LOCK_UN);
			$nStatus = 1;
		}
		close(XMLF);
	}
	if ($nStatus) {
		my $artcount = $qryDOM->documentElement()->childNodes->size();

		$outDOM->documentElement()->appendChild($outDOM->importNode($qryDOM->documentElement()));

		$rsp_status_node->appendTextNode("Success");
		$rsp_count_node->appendTextNode($artcount);
		$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));
	}
	else {
		$rsp_status_node->appendTextNode("Failed to open/flock '${xmlFile}' (${cmdId})!");
	}
}
elsif ($cmdId eq "oxfordDudenIndeksEng") {
	my $xsldom = $dicparser->parse_file('xsl/odIndeksEng.xsl');
	my $ss = $xslt->parse_stylesheet($xsldom);

	my $xmlFile = "__sr/od_/od_1.xml";
	if (open(XMLF, '<:utf8', $xmlFile)) {
		if (flock(XMLF, $lockType)) {
			$dicDOM = $dicparser->parse_file($xmlFile);
			$qryDOM = $ss->transform($dicDOM);
			flock(XMLF, LOCK_UN);
			$nStatus = 1;
		}
		close(XMLF);
	}
	if ($nStatus) {
		my $artcount = $qryDOM->documentElement()->childNodes->size();

		$outDOM->documentElement()->appendChild($outDOM->importNode($qryDOM->documentElement()));

		$rsp_status_node->appendTextNode("Success");
		$rsp_count_node->appendTextNode($artcount);
		$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));
	}
	else {
		$rsp_status_node->appendTextNode("Failed to open/flock '${xmlFile}' (${cmdId})!");
	}
}
elsif ($cmdId eq "oxfordDudenIndeksEst") {
	my $xsldom = $dicparser->parse_file('xsl/odIndeksEst.xsl');
	my $ss = $xslt->parse_stylesheet($xsldom);

	my $xmlFile = "__sr/od_/od_1.xml";
	if (open(XMLF, '<:utf8', $xmlFile)) {
		if (flock(XMLF, $lockType)) {
			$dicDOM = $dicparser->parse_file($xmlFile);
			$qryDOM = $ss->transform($dicDOM);
			flock(XMLF, LOCK_UN);
			$nStatus = 1;
		}
		close(XMLF);
	}
	if ($nStatus) {
		my $artcount = $qryDOM->documentElement()->childNodes->size();

		$outDOM->documentElement()->appendChild($outDOM->importNode($qryDOM->documentElement()));

		$rsp_status_node->appendTextNode("Success");
		$rsp_count_node->appendTextNode($artcount);
		$responseDOM->documentElement()->appendChild($responseDOM->importNode($outDOM->documentElement()));
	}
	else {
		$rsp_status_node->appendTextNode("Failed to open/flock '${xmlFile}' (${cmdId})!");
	}
}
elsif ($cmdId eq "saveGendView") {
	my $nimetus = $parms[6];
	my $cssFile = "css/gendView_${DIC_DESC}${nimetus}.css";
	my $confFile = "config/view/gendViewConf_${DIC_DESC}${nimetus}.xml";
	my $xslFile = "xsl/gendView_${DIC_DESC}${nimetus}.xsl";

	# parms tuleb sisse "decode_utf8($q->param('POSTDATA')"
	# failinimed on aga Balti
	$cssFile = encode('cp-1257', $cssFile);
	$confFile = encode('cp-1257', $confFile);
	$xslFile = encode('cp-1257', $xslFile);

	my $newCSS = $parms[5];
	my $newConf = $parms[4];
	my $newConfDom = $dicparser->parse_string($newConf);
	my $newXSL = $parms[3];
	my $newXSLDom = $dicparser->parse_string($newXSL);
	
	use File::Copy;
	my $aeg = $nowdtstr;
	$aeg =~ s/T/_/g;
	$aeg =~ s/:/\-/g;
	my $bkpFile;
	if (-e $confFile) {
		$bkpFile = encode('cp-1257', "backup/gendVaade/gendViewConf_${DIC_DESC}${nimetus}_${aeg}_${usrName}.xml");
		copy( $confFile, $bkpFile ) or die "Copy failed: $!";
	}
	if (-e $xslFile) {
		$bkpFile = encode('cp-1257', "backup/gendVaade/gendView_${DIC_DESC}${nimetus}_${aeg}_${usrName}.xsl");
		copy( $xslFile, $bkpFile ) or die "Copy failed: $!";
	}
	if (-e $cssFile) {
		$bkpFile = encode('cp-1257', "backup/gendVaade/gendView_${DIC_DESC}${nimetus}_${aeg}_${usrName}.css");
		copy( $cssFile, $bkpFile ) or die "Copy failed: $!";
	}

	if ($newConfDom) {
		umask 0000;
		if ($newConfDom->toFile($confFile, 0)) {
			$nStatus = 1;
			chmod(oct('0666'), $confFile);
		}
		else {
			$rsp_status_node->appendTextNode("Failed to write '${confFile}', (${cmdId})!");
		}
	}
	else {
		$rsp_status_node->appendTextNode("Failed to parse 'XML' in '${confFile}', (${cmdId})!");
	}
	if ($nStatus == 1) {
		if ($newXSLDom) {
			umask 0000;
			if ($newXSLDom->toFile($xslFile, 0)) {
				$nStatus = 2;
				chmod(oct('0666'), $xslFile);
			}
			else {
				$rsp_status_node->appendTextNode("Failed to write '${xslFile}', (${cmdId})!");
			}
		}
		else {
			$rsp_status_node->appendTextNode("Failed to parse 'XSL' in '${xslFile}', (${cmdId})!");
		}
	}
	if ($nStatus == 2) {
		umask 0000;
		open (MYCSS, ">", $cssFile);
		if (print(MYCSS $newCSS)) {
			$nStatus = 3;
			$rsp_status_node->appendTextNode("Success");
		}
		else {
			$rsp_status_node->appendTextNode("Failed to write '${cssFile}', (${cmdId})!");
		}
		close(MYCSS);
		chmod(oct('0666'), $cssFile);
		if ($qryMethod eq 'MySql') {
			$rcnt = $dbh->do("INSERT INTO dicsinfo (dic_code, genview_time) VALUES ('${DIC_DESC}',NOW()) ON DUPLICATE KEY UPDATE genview_time = NOW();");
		}
	}
	$rsp_count_node->appendTextNode($nStatus);
}
elsif ($cmdId eq "saveGendXSD") {
	my $newXSD = $parms[3];
	my $newXSDDom = $dicparser->parse_string($newXSD);
	my $newConf = $parms[4];
	my $newConfDom = $dicparser->parse_string($newConf);
	my $newXsl2 = $parms[5];
	my $newXsl2Dom = $dicparser->parse_string($newXsl2);
	my $newStruXml = $parms[6];
	my $newStruDom = $dicparser->parse_string($newStruXml);
	my $newCSS = $parms[7];
	
	my $xsdFile = "xsd/schema_${DIC_DESC}.xsd";
	my $confFile = "config/xsl2/gendXsl2Conf_${DIC_DESC}.xml";
	my $xsl2File = "xsl/gendXsl2_${DIC_DESC}.xsl";
	my $struFile = "xml/${DIC_DESC}/stru_${DIC_DESC}.xml";
	my $cssFile = "css/gendEdit_${DIC_DESC}.css";

	use File::Copy;
	my $aeg = $nowdtstr;
	$aeg =~ s/T/_/g;
	$aeg =~ s/:/\-/g;
	if (-e $xsdFile) {
		copy( $xsdFile, "backup/gendSkeem/schema_${DIC_DESC}_${aeg}_${usrName}.xsd" );
	}
	if (-e $confFile) {
		copy( $confFile, "backup/gendSkeem/gendXsl2Conf_${DIC_DESC}_${aeg}_${usrName}.xml" );
	}
	if (-e $xsl2File) {
		copy( $xsl2File, "backup/gendSkeem/gendXsl2_${DIC_DESC}_${aeg}_${usrName}.xsl" );
	}
	if (-e $struFile) {
		copy( $struFile, "backup/gendSkeem/stru_${DIC_DESC}_${aeg}_${usrName}.xml" );
	}
	if (-e $cssFile) {
		copy( $cssFile, "backup/gendSkeem/gendEdit_${DIC_DESC}_${aeg}_${usrName}.css" );
	}

	umask 0000;

	if ($newXSDDom) {
		if ($newXSDDom->toFile($xsdFile, 0)) {
			$nStatus = 1;
			chmod(oct('0666'), $xsdFile);
		}
		else {
			$rsp_status_node->appendTextNode("Failed to write '${xsdFile}', (${cmdId})!");
		}
	}
	else {
		$rsp_status_node->appendTextNode("Failed to parse 'XML' in '${xsdFile}', (${cmdId})!");
	}
	if ($nStatus == 1) {
		if ($newConfDom) {
			if ($newConfDom->toFile($confFile, 0)) {
				$nStatus = 2;
				chmod(oct('0666'), $confFile);
			}
			else {
				$rsp_status_node->appendTextNode("Failed to write '${confFile}', (${cmdId})!");
			}
		}
		else {
			$rsp_status_node->appendTextNode("Failed to parse 'XML' in '${confFile}', (${cmdId})!");
		}
	}
	if ($nStatus == 2) {
		if ($newXsl2Dom) {
			if ($newXsl2Dom->toFile($xsl2File, 0)) {
				$nStatus = 3;
				chmod(oct('0666'), $xsl2File);
			}
			else {
				$rsp_status_node->appendTextNode("Failed to write '${xsl2File}', (${cmdId})!");
			}
		}
		else {
			$rsp_status_node->appendTextNode("Failed to parse 'XML' in '${xsl2File}', (${cmdId})!");
		}
	}
	if ($nStatus == 3) {
		if ($newStruDom) {
			if ($newStruDom->toFile($struFile, 0)) {
				$nStatus = 4;
				chmod(oct('0666'), $struFile);
			}
			else {
				$rsp_status_node->appendTextNode("Failed to write '${struFile}', (${cmdId})!");
			}
		}
		else {
			$rsp_status_node->appendTextNode("Failed to parse 'XML' in '${struFile}', (${cmdId})!");
		}
	}
	if ($nStatus == 4) {
		if (open (MYCSS, ">", $cssFile)) {
			if (print(MYCSS $newCSS)) {
				close(MYCSS);
				$nStatus = 5;
				chmod(oct('0666'), $cssFile);
				$rsp_status_node->appendTextNode("Success");
			}
			else {
				$rsp_status_node->appendTextNode("Failed to write '${cssFile}', (${cmdId})!");
			}
		}
		else {
			$rsp_status_node->appendTextNode("Failed to open '${cssFile}', (${cmdId})!");
		}
	}
	$rsp_count_node->appendTextNode($nStatus);
}
elsif ($cmdId eq 'getAddElements') {
	my $xmlDir = $parms[3]; # lõpus /: 'xml/har/'
	my $xmlFile = $parms[4];
	my $fullName = "${xmlDir}${xmlFile}";
	my $jubaOlemas = $parms[5];
	$dicparser->keep_blanks(0);
	if ($xmlFile =~ /^ag_/) {
		my $answer = $responseDOM->documentElement()->appendChild($responseDOM->createElement('answer'));
		if (-e $fullName) {
			my $xmlDom = $dicparser->parse_file($fullName);
			$answer->appendChild($responseDOM->importNode($xmlDom->documentElement()));
		}
		else {
			my $qName = substr($xmlFile, 3); # peale 'ag_'
			# '_' järgi otsida ei saa, SP-s nt <kom_k>, 58 on ':' ord()
			$qName = substr($qName, 0, index($qName, '_' . ord(substr($qName, 0, 1)) . '_58_'));
			$qName =~ s/-/:/;
			$answer->appendChild($responseDOM->createElement($qName));
		}
		$rsp_status_node->appendTextNode("Success");
		$rsp_count_node->appendTextNode(1);
	}
	elsif ($xmlFile =~ /^al_/) {
		if (-e $fullName) {
			my $qNamesDom = $dicparser->parse_file($fullName);
			my $qNames = $qNamesDom->documentElement()->textContent;
			my @elements = split(/\|/, $qNames);
			my $answer = $responseDOM->documentElement()->appendChild($responseDOM->createElement('answer'));
			foreach my $qName (@elements) {
				unless ($jubaOlemas =~ /;$qName;/) {
					my $elementFile = "${xmlDir}ag_" . unNameCgi($qName) . '.xml';
					if (-e $elementFile) {
						my $xmlDom = $dicparser->parse_file($elementFile);
						$answer->appendChild($responseDOM->importNode($xmlDom->documentElement()));
					}
					else {
						$answer->appendChild($responseDOM->createElement($qName));
					}
				}
			}
			$rsp_status_node->appendTextNode("Success");
			$rsp_count_node->appendTextNode(scalar(@elements));
		}
		else {
			$rsp_status_node->appendTextNode("Error");
			$rsp_count_node->appendTextNode(0);
		}
	}
	elsif ($xmlFile =~ /^aa_/) {
		if (-e $fullName) {
			my $qNamesDom = $dicparser->parse_file($fullName);
			my $qNames = $qNamesDom->documentElement()->textContent;
			my $answer = $responseDOM->documentElement()->appendChild($responseDOM->createElement('answer'));
			$answer->appendTextNode($qNames);
			$rsp_status_node->appendTextNode("Success");
			$rsp_count_node->appendTextNode(1);
		}
		else {
			$rsp_status_node->appendTextNode("Error");
			$rsp_count_node->appendTextNode(0);
		}
	}
	else {
		unless ($xmlDir =~ /^xml\//) {
			if (-e $fullName) {
				my $answer = $responseDOM->documentElement()->appendChild($responseDOM->createElement('answer'));
				my $xmlDom = $dicparser->parse_file($fullName);
				$answer->appendChild($responseDOM->importNode($xmlDom->documentElement()));
				$rsp_status_node->appendTextNode("Success");
				$rsp_count_node->appendTextNode(1);
			}
			else {
				$rsp_status_node->appendTextNode("Error");
				$rsp_count_node->appendTextNode(0);
			}
		}
	}
}
elsif ($cmdId eq 'getAddAllElements') {
	my $xmlDir = $parms[3]; # lõpus /, nt 'xml/har/'
	my $nodeName = $parms[4];
	my $jubaOlemas = $parms[5];
	$dicparser->keep_blanks(0);
	my $ysFile = "${xmlDir}stru_${DIC_DESC}.xml";
	if (-e $ysFile) {
		my $yldStruDom = $dicparser->parse_file($ysFile);
		my $tNode = $yldStruDom->documentElement()->findnodes(".//${nodeName}")->get_node(1);
		if ($tNode) {
			my $answer = $responseDOM->documentElement()->appendChild($responseDOM->createElement('answer'));
			my $elCnt = 0;
			foreach my $alam ($tNode->findnodes("*")) {
				my $qName = $alam->nodeName;
				unless ($jubaOlemas =~ /;$qName;/) {
					my $elementFile = "${xmlDir}ag_" . unNameCgi($qName) . '.xml';
					if (-e $elementFile) {
						my $xmlDom = $dicparser->parse_file($elementFile);
						# kas (1) v (0): alamplokid kohe olemas v mitte
						my $lisatav = $xmlDom->documentElement()->cloneNode(1);
						$answer->appendChild($responseDOM->importNode($lisatav));
					}
					else {
						$answer->appendChild($responseDOM->createElement($qName));
					}
					$elCnt++;
				}
			}
			$rsp_status_node->appendTextNode("Success");
			$rsp_count_node->appendTextNode($elCnt);
		}
		else {
			$rsp_status_node->appendTextNode("Error");
			$rsp_count_node->appendTextNode(0);
		}
	}
	else {
		$rsp_status_node->appendTextNode("Error");
		$rsp_count_node->appendTextNode(0);
	}
}
elsif ($cmdId eq "appOpen") {
	my $brVer = $parms[3];
	my $brNimi = "X";
	if (index($brVer, 'Internet Explorer') > -1) {
		$brNimi = "IE";
	}
	elsif (index($brVer, 'Chrome') > -1) {
		$brNimi = "Chrome";
	}
	elsif (index($brVer, 'Firefox') > -1) {
		$brNimi = "Firefox";
	}
	elsif (index($brVer, 'Opera') > -1) {
		$brNimi = "Opera";
	}
	elsif (index($brVer, 'Safari') > -1) {
		$brNimi = "Safari";
	}
	$opMs = $brNimi;
	$opAttrs = $brVer;
	$rsp_count_node->appendTextNode('1');
	$rsp_status_node->appendTextNode("Success");
}


if ($qryMethod eq 'MySql') {
	$dbh->disconnect();
}


$nowdtstr =~ s/T/\t/g;
my $elTime = (time() - $startTime);
my $logSta = $rsp_status_node->firstChild->toString(0);
my $logCnt = $rsp_count_node->firstChild->toString(0);

$qrySql =~ s/\s+/ /g;

my @logLines;
tie(@logLines, 'Tie::File', "logs/${DIC_DESC}/${logFileName}.log");

### Kui siin midagi muudad, siis sama teha ka 'srvfuncs.cgi' - s !
my $logLine = "${nowdtstr}\t${usrName}\t\"${remoteAddress}\"\t${cmdId}\t${dicVol}\t${elTime}s.\t${logSta}\t${logCnt}\t${qinfo}\t${art_xpath}\tsrchPtrn: '${fSrchPtrn}'\t${artMuudatused}\t${opMs}\t${opAttrs}\t${qryMethod}\t${qrySql}";

unshift(@logLines, encode_utf8($logLine));
untie(@logLines);



print "Content-type: text/xml; charset=utf-8\n\n";
print $responseDOM->toString(0);

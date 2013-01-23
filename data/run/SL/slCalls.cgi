#!/perl/bin/perl

require '/var/www/EELex/shs_config/shs_config.ini';
our $mysql_ip;

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

# my $startTime = time();

# my $remoteAddress = $ENV{REMOTE_ADDR}; #HTTP_X_FORWARDED_FOR, REMOTE_ADDR
# use Socket;
# my $hostName = gethostbyaddr(inet_aton($remoteAddress), AF_INET);


sub teeXMLStr {

	my $artsXML = '';

	my $stHandle = shift(@_);
	while (my $ref = $stHandle->fetchrow_hashref()) {

		$artsXML .= '<A>';

		$artsXML .= '<ms>' . decode_utf8($ref->{'ms'}) . '</ms>';
#		$artsXML .= '<ms_nos>' . $ref->{'ms_nos'} . '</ms_nos>';
		$artsXML .= '<vol_nr>' . $ref->{'vol_nr'} . '</vol_nr>';
		$artsXML .= '<dic_code>' . $ref->{'dic_code'} . '</dic_code>';

		$artsXML .= '<i>' . $ref->{'ms_att_i'} . '</i>';
		$artsXML .= '<liik>' . decode_utf8($ref->{'ms_att_liik'}) . '</liik>';

		$artsXML .= '<g>' . $ref->{'G'} . '</g>';

		$artsXML .= '</A>';

	} # while ($ref = $stHandle->fetchrow_hashref()) {
	
	return $artsXML;
}


my $tagaTyhik = '';
my $kyljes = 1;
my $currentLn = '';

my $DIC_DESC;

sub RS {
	# siia tuleb sisse tekst nood (text()) ...
	
	# textContent: '&amp;' -> '&'
	# textContent: krahvitar, &ema;&la;count&ll;&eml;’i abikaasa v tütar
	# toString: krahvitar, &amp;ema;&amp;la;count&amp;ll;&amp;eml;’i abikaasa v tütar
	# peab jätma "toString", sest on ainuke, mis ei moonuta

	my $nodeList = shift(@_);
	my $currNode = $nodeList->get_node(1);

	my $tekst = $currNode->textContent;
	my $itStyle = shift(@_);
	if ($itStyle) {
		$itStyle = $itStyle->get_node(1)->textContent;
	}
	my $ln = shift(@_);
	my $printing = shift(@_);

	if ($DIC_DESC eq 'qs_') {
		$tekst =~ s/¤/\x{00b4}/g; # acute accent
		$tekst =~ s/--/\x{2013}/g; # en dash
		if ($ln eq 'm') {
			my $eelmineM = shift(@_)->get_node(1)->textContent;
			if ($eelmineM) {
				my $slashes_m1 = ($eelmineM =~ tr/\///);
				my $slashes = ($tekst =~ tr/\///);
				if ($slashes_m1 == 0) { # abra.siiv
					my $fm = $eelmineM;
					if (substr($tekst, 0, length($fm) + 1) eq $fm . '/') {
						$tekst = substr($tekst, length($fm));
					}
				}
				elsif ($slashes_m1 == 1) { # aabitsa/.jünger, kuu/.keskene (po tõstutundlik); abso.luut/ ja abso.luutne: ei pea lühendama
					if ($slashes < 2) {
						my $fm = substr($eelmineM, 0, index($eelmineM, '/'));
						if (substr($tekst, 0, length($fm) + 1) eq $fm . '/') {
							$tekst = substr($tekst, length($fm));
						}
					}
				}
			}
		}
		# slash / asendus alakaarega, hiljem võib HTML tõttu juba olla lisa /
		$tekst =~ s/\//\x{203f}/g;
	}
	elsif ($DIC_DESC eq 'ss_' || $DIC_DESC eq 'ss1') {
		if ($ln eq 'vk' || $ln eq 'sl') {
			$tekst =~ s/(\s)/.$1/g;
		}
		$tekst =~ s/(\\(.+?)\\)/<i style='font-style:normal;background-color:sandybrown;'>$2<\/i>/g; # kursiivis pöörata kursiiv tagasi
	}

	$tekst =~ s/_+$//g; # alakriipsud <m> jt lõpust maha
	$tekst =~ s/</&lt;/g;

    # //ss_, ss1: Jutumärgid nagu raamatus: <<  >> (lõpetaval on ees konks)
	# //nt = nt.replace(/\^"/g, String.fromCharCode(0x00BB));
	# //nt = nt.replace(/"/g, String.fromCharCode(0x00AB));
	$tekst =~ s/\^"/\x{201D}/g;
	$tekst =~ s/"/\x{201E}/g;

	$tekst =~ s/(&suba;(.+?)&subl;)/<sub>$2<\/sub>/g;
	$tekst =~ s/(&supa;(.+?)&supl;)/<sup>$2<\/sup>/g;
	$tekst =~ s/(&ba;(.+?)&bl;)/<b>$2<\/b>/g;
	$tekst =~ s/(&la;(.+?)&ll;)/<u>$2<\/u>/g;

	if ($itStyle eq '1') {
		$tekst =~ s/(&ema;(.+?)&eml;)/<i style='font-style:normal;'>$2<\/i>/g; # kursiivis pöörata kursiiv tagasi
	}
	else {
		$tekst =~ s/(&ema;(.+?)&eml;)/<i>$2<\/i>/g;
	}

	# teeme nüüd nii, et ainult teatud asjad asendame (et jääksid oma loomulikku rada kehtima &apos;, &#x0011; jne)
	$tekst =~ s/(&(ja|jne|jt|ka|ehk|Hrl|hrl|nt|puudub|v|vm|vms|напр\.|и др\.|и т\. п\.|г\.);)/<i>$2<\/i>/g;

	$tekst =~ s/&/&amp;/g;

    $tagaTyhik = '';
    $kyljes = 0;

	return $tekst;
}

sub paneTyhikJarele {
	my $sym = shift(@_);
    $tagaTyhik = ' ';
    return $sym;
}

sub paneJarele {
	my $sym = shift(@_);
    $tagaTyhik = ' ';
    return $sym;
}

sub paneTaha {
	my $sym = shift(@_);
    $tagaTyhik = ' ';
    return $sym;
}

sub paneTyhikEtte {
	my $nodeList = shift(@_);
	my $tekst = $nodeList->get_node(1)->textContent;
	my $ln = shift(@_);

	my $retStr;
	if ($tagaTyhik eq ' ') {
		$retStr = '';
	}
	else {
		if ($kyljes == 0) {
			if ($ln eq $currentLn) { # omab tähendust ainult elemendi ja tema atribuutide vaheldumisel
				$retStr = ' ';
			}
			else { # algas uus element, atribuudi korral saadetakse ka element ise, mitte atribuut
				if (index(');:,.!?-', substr($tekst, 0, 1)) > -1) {
					$retStr = '';
				}
				else {
					my $prevNode = $nodeList->get_node(1)->findnodes('preceding-sibling::node()[1]');
					unless ($prevNode) { # kõik on ju tekstid, sellepärast 'parentNode'
						my $parNode = $nodeList->get_node(1)->parentNode;
						if ($parNode) {
							$prevNode = $parNode->findnodes('preceding-sibling::node()[1]');
						}
					}
					unless ($prevNode) {
						$retStr = ' ';
					}
					else {
						if (index('(-', substr($prevNode->textContent, length($prevNode->textContent) - 1, 1)) > -1) {
							$retStr = '';
						}
						else {
							$retStr = ' ';
						}
					}
				}
			}
		}
		else {
			$retStr = '';
		}
	}
	$currentLn = $ln;
	return $retStr;
}

sub paneKylge {
	my $sym = shift(@_);
	$kyljes = 1;
    return $sym;
}

sub paneTyhik {
	if ($tagaTyhik eq ' ') {
		return '';
	}
	else {
		if ($kyljes == 0) {
			return ' ';
		}
		else {
			return '';
		}
	}
}


use CGI;
my $q = new CGI;

my $cmdId = $q->param('cmd');

use DBI();
my $mySqlDbName = 'xml_dicts';
my $dbh = DBI->connect("DBI:mysql:database=${mySqlDbName};mysql_enable_utf8=1;host=${mysql_ip}",
						"koond", "koondKasutaja",
						{'RaiseError' => 1});

my $statusString;
my $countString;

my $qryResp = "<sr>";

if ($cmdId eq '') {
	$statusString = '<sta>GET/POST data not defined.</sta>';
	$countString = '<cnt>0</cnt>';
}
elsif ($cmdId eq 'readHw') {
	my $lisand = $q->param('lisand');
	if ($lisand) {
		my $msNosCount = $dbh->do($lisand);
	}
	my $sql = $q->param('sql');
	my $sth = $dbh->prepare($sql);
	$sth->execute();

	my $leide = $sth->rows;
	$qryResp .= teeXMLStr($sth);

	$statusString = "<sta>Success</sta>";
	$countString = "<cnt>${leide}</cnt>";
}
elsif ($cmdId eq 'readArtXml') {
	my $sql = $q->param('sql');
	my $sth = $dbh->prepare($sql);
	$sth->execute();

	my $leide = $sth->rows;
	if (my $ref = $sth->fetchrow_hashref()) {
		$qryResp .= decode_utf8($ref->{'art'});
	}

	$statusString = "<sta>Success</sta>";
	$countString = "<cnt>${leide}</cnt>";
}
elsif ($cmdId eq 'readArtHtml') {
	my $g = $q->param('g');
	$g =~ s/["';]//g;
	$DIC_DESC = $q->param('dic_desc');
	$DIC_DESC =~ s/["';]//g;
	my $sql = "SELECT ${DIC_DESC}.art AS art FROM ${DIC_DESC} WHERE ${DIC_DESC}.G='${g}'";
	my $sth = $dbh->prepare($sql);
	$sth->execute();

	my $leide = $sth->rows;
	if (my $ref = $sth->fetchrow_hashref()) {
		my $artXml = decode_utf8($ref->{'art'});

		use XML::LibXML;
		my $dicparser = XML::LibXML->new();

		my $shsconfig = $dicparser->parse_file("../../__shs/shsconfig_${DIC_DESC}.xml");
		my $rootLang = $shsconfig->documentElement()->findvalue('rootLang');
		unless ($rootLang) {
			$rootLang = 'et';
		}
		my $DICPR = $shsconfig->documentElement()->findvalue('dicpr');
		my $DICURI = $shsconfig->documentElement()->findvalue('dicuri');

		$artXml = "<${DICPR}:sr xmlns:${DICPR}='${DICURI}'>" . $artXml . "</${DICPR}:sr>";
		my $artDOM = $dicparser->parse_string($artXml);
		$artDOM->documentElement()->setAttribute('xml:lang', $rootLang);

		my $viewXSLDom = $dicparser->parse_file("../../__shs/xsl/view_${DIC_DESC}.xsl");
		my $XSLSCRIPTSURI = 'http://www.eo.ee/xml/xsl/perlscripts';
		$viewXSLDom->documentElement()->setAttribute('xmlns:al', $XSLSCRIPTSURI);
		# EVS-i pärast, seal ei ole funktsioone, on vaid 'disable-output-escaping="yes"'
		if ($DIC_DESC eq 'evs') {
			foreach my $xslNode ($viewXSLDom->documentElement()->findnodes(".//xsl:value-of[\@select = 'current()'][\@disable-output-escaping = 'yes']")) {
				$xslNode->setAttribute('disable-output-escaping', 'no');
			}
		}


		my $html = "<html>";
		$html .= "<head>";

		if (open(STYLE, "<", "../../__shs/css/view_${DIC_DESC}.css")) {
			$html .= "<style>";
			while (<STYLE>) {
				# s/\s+$//; # chomp näib reavahetuse tühikuga asendavat ...
				$html .= $_;
			}
			close(STYLE);
			$html .= "</style>";
		}

		$html .= "</head>";

		use XML::LibXSLT;
		XML::LibXSLT->register_function($XSLSCRIPTSURI, 'RS', \&RS);
		XML::LibXSLT->register_function($XSLSCRIPTSURI, 'paneJarele', \&paneJarele);
		XML::LibXSLT->register_function($XSLSCRIPTSURI, 'paneTaha', \&paneTaha);
		XML::LibXSLT->register_function($XSLSCRIPTSURI, 'paneTyhikJarele', \&paneTyhikJarele);
		XML::LibXSLT->register_function($XSLSCRIPTSURI, 'paneTyhikEtte', \&paneTyhikEtte);
		XML::LibXSLT->register_function($XSLSCRIPTSURI, 'paneKylge', \&paneKylge);
		XML::LibXSLT->register_function($XSLSCRIPTSURI, 'paneTyhik', \&paneTyhik);

		my $xslt = XML::LibXSLT->new();
		my $ss = $xslt->parse_stylesheet($viewXSLDom);

		my $xslStr = decode_utf8($ss->transform($artDOM)->toString);
		my $htmlDom = $dicparser->parse_string($xslStr);
		foreach my $htmlNode ($htmlDom->documentElement()->findnodes(".//*[\@id or \@title or \@tabIndex]")) {
			$htmlNode->removeAttribute('id');
			$htmlNode->removeAttribute('title');
			$htmlNode->removeAttribute('tabIndex');
		}
		foreach my $htmlNode ($htmlDom->documentElement()->findnodes(".//a")) {
			my $uusSpan = $htmlNode->parentNode->insertBefore( $htmlDom->createElement('span'), $htmlNode);
			$uusSpan->appendTextNode($htmlNode->textContent);
			$uusSpan->setAttribute('style', $htmlNode->getAttribute('style') . ';color:blue;text-decoration:underline;cursor:hand');
			$htmlNode->parentNode->removeChild($htmlNode);
		}
		my $htmlBody = $htmlDom->documentElement()->findnodes("descendant-or-self::body")->get_node(1);
		if ($htmlBody) {
			# $htmlDom->documentElement()->removeAttribute('xmlns:msxsl');
			# $htmlDom->documentElement()->removeAttribute('xmlns:al');
			# $htmlDom->documentElement()->removeAttribute("xmlns:${DICPR}");
			$htmlBody->setAttribute('style', 'background-color:AntiqueWhite');
			$html .= $htmlBody->toString;
		}
		else {
			# $html .= $htmlDom->documentElement()->toString;
			$html .= "<body></body>";
		}
		$html .= "</html>";

		$qryResp .= $html;
	}

	$statusString = "<sta>Success</sta>";
	$countString = "<cnt>${leide}</cnt>";
}

$dbh->disconnect();

$qryResp .= "</sr>";

my $respStr = "<rsp>${statusString}${countString}${qryResp}</rsp>";

print "Content-type: text/xml; charset=utf-8\n\n";
print encode_utf8($respStr);

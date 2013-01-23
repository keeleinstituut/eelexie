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


my $DIC_DESC;



sub teeXMLStr {

	my $artsXML = '';

	my $stHandle = shift(@_);
	while (my $ref = $stHandle->fetchrow_hashref()) {

		$artsXML .= '<A>';

		$artsXML .= '<ms>' . decode_utf8($ref->{'ms'}) . '</ms>';
		$artsXML .= '<vol_nr>' . $ref->{'vol_nr'} . '</vol_nr>';
		$artsXML .= '<dic_code>' . $ref->{'dic_code'} . '</dic_code>';

		$artsXML .= '<i>' . $ref->{'ms_att_i'} . '</i>';
		$artsXML .= '<liik>' . decode_utf8($ref->{'ms_att_liik'}) . '</liik>';

		$artsXML .= '<g>' . $ref->{'G'} . '</g>';

		$artsXML .= '</A>';

	} # while ($ref = $stHandle->fetchrow_hashref()) {
	
	return $artsXML;
} # teeXMLStr


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

use CGI;
my $q = new CGI;

# my $cmdId = $q->param('cmd');
# my $pd = decode_utf8($q->param('POSTDATA'));
my $pd = $q->param('POSTDATA');

if ($pd eq '') {
	print "Content-type: text/html; charset=utf-8\n\n"; #header utf-8 -s
	print 'not defined.';
	exit;
}

my $prmDOM = $dicparser->parse_string($pd);

my $cmdId = $prmDOM->documentElement()->findvalue('cmd');
my $sql = $prmDOM->documentElement()->findvalue('sql');
$sql =~ s/\s+/ /g;
my $SQL_CALC_FOUND_ROWS = $prmDOM->documentElement()->findvalue('scfr');
my $dicVol = $prmDOM->documentElement()->findvalue('vol'); # "ief1" jne
my $artG = $prmDOM->documentElement()->findvalue('G');

my $usrName = "$ENV{REMOTE_USER}";
unless ($usrName) {
	$cmdId = '';
}

use DBI();
my $mySqlDbName = 'xml_dicts';
my $dbh = DBI->connect("DBI:mysql:database=${mySqlDbName};mysql_enable_utf8=1;host=${mysql_ip}",
						"koond", "koondKasutaja",
						{'RaiseError' => 1});

my $statusString;
my $countString;

my $qryResp = "<sr>";

if ($cmdId eq '') {
	$statusString = '<sta>GET/POST data or username not defined.</sta>';
	$countString = '<cnt>0</cnt>';
}
elsif ($cmdId eq 'srvSaveAs') {

	my $sth = $dbh->prepare($sql);
	$sth->execute();
	my $leide = $sth->rows;
	my $loendur = 0;
	my $tekstiFail = "temp/loend_${usrName}.txt";

	open(LOEND, '>:utf8', $tekstiFail);
	while (my $ref = $sth->fetchrow_hashref()) {
		$loendur++;
		my $ms = decode_utf8($ref->{'ms'});
		my $homNr = $ref->{'ms_att_i'};
		my $liik = decode_utf8($ref->{'ms_att_liik'});
		my $dd = $ref->{'dic_code'};
		print(LOEND "${loendur}\t${ms}\t${homNr}\t${liik}\t${dd}\n");
	}
	close(LOEND);

	my $zipFile = "${tekstiFail}.zip";
	use IO::Compress::Zip qw(:all);
    zip $tekstiFail => $zipFile or die "zip failed: $ZipError\n";

	my $deldCnt = unlink($tekstiFail);

	$statusString = "<sta>Success</sta>";
	$countString = "<cnt>${leide}</cnt><zF>${zipFile}</zF>";
}
elsif ($cmdId eq 'ClientRead') {
	if ($SQL_CALC_FOUND_ROWS) {
		$sql =~ s/^SELECT /SELECT ${SQL_CALC_FOUND_ROWS} /g;
	}

	my $sth = $dbh->prepare($sql);
	$sth->execute();

	my $leide = $sth->rows;
	$qryResp .= teeXMLStr($sth);

	my $fullCnt = "";
	if ($SQL_CALC_FOUND_ROWS) {
		$sth = $dbh->prepare("SELECT FOUND_ROWS() AS fullCnt");
		$sth->execute();
		if (my $ref = $sth->fetchrow_hashref()) {
			$fullCnt = $ref->{'fullCnt'};
		}
	}

	$statusString = "<sta>Success</sta>";
	$countString = "<cnt>${leide}</cnt><fullCnt>${fullCnt}</fullCnt>";
}
elsif ($cmdId eq 'getRandomWord') {

	# $sql = "SELECT ms_nos AS ms_nos FROM msid ORDER BY RAND() limit 1";

	my $dicsTing = '';
	if ($sql) {
		$dicsTing = ' WHERE ' . $sql;
	}
	$sql = "select FLOOR(RAND() * (select count(*) from msid${dicsTing})) AS rida from msid limit 1";
	my $sth = $dbh->prepare($sql);
	$sth->execute();

	my $ref;
	my $reaNr = 0;
	if ($ref = $sth->fetchrow_hashref()) {
		$reaNr = $ref->{'rida'};
	}
	$sql = "SELECT ms_nos AS ms_nos FROM msid${dicsTing} limit ${reaNr}, 1";
	$sth = $dbh->prepare($sql);
	$sth->execute();

	my $leide = $sth->rows;
	my $sqna;
	if ($ref = $sth->fetchrow_hashref()) {
		$sqna = decode_utf8($ref->{'ms_nos'});
	}

	$statusString = "<sta>Success</sta>";
	$countString = "<cnt>${leide}</cnt>";

	$statusString = "<sta>Success</sta>";
	$countString = "<cnt>${leide}</cnt><w>" . '<![CDATA[' . $sqna . ']]>' . "</w>";
}
elsif ($cmdId eq 'readArtXml') {
	my $volNr = substr($dicVol, 3, 1);
	$DIC_DESC = substr($dicVol, 0, 3);

	$sql = "SELECT ${DIC_DESC}.art AS art FROM ${DIC_DESC} WHERE ${DIC_DESC}.G='${artG}'";
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
	my $volNr = substr($dicVol, 3, 1);
	$DIC_DESC = substr($dicVol, 0, 3);

	my $leide;
	my $html = "";

	my $cssFile = "../../../__shs/css/gendView_${DIC_DESC}.css";
	unless (-e $cssFile) {
		$cssFile = "../../../__shs/css/view_${DIC_DESC}.css";
	}
	if (open(STYLE, "<", $cssFile)) {
		# $html .= "<style>";
		while (<STYLE>) {
			$html .= $_;
		}
		close(STYLE);
		# $html .= "</style>";
	}
	$html .= "\x{e001}";

	my $sthColInfo = $dbh->prepare("SHOW FULL COLUMNS FROM ${DIC_DESC} WHERE field = 'hasHtml'");
	my $colInfoCount = $sthColInfo->execute();
	if ($colInfoCount == 1) {

		$sql = "SELECT ${DIC_DESC}.art_html AS art_html, ${DIC_DESC}.hasHtml AS hasHtml FROM ${DIC_DESC} WHERE ${DIC_DESC}.G = '${artG}'";
		my $sth = $dbh->prepare($sql);
		$sth->execute();

		$leide = $sth->rows;
		if (my $ref = $sth->fetchrow_hashref()) {
			my $artHtml .= decode_utf8($ref->{'art_html'}); # <![CDATA[<body> ... ]]>
			$artHtml = substr($artHtml, 9);
			$artHtml = substr($artHtml, 0, length($artHtml) - 3);
			$html .= $artHtml;
			$html .= "\x{e001}";

			my $hasHtml = $ref->{'hasHtml'};
			$html .= $hasHtml;
		}
	}
	else {
		$html .= "\x{e001}";
	}

	$qryResp .= '<![CDATA[' . $html . ']]>';

	$statusString = "<sta>Success</sta>";
	$countString = "<cnt>${leide}</cnt>";
}

$dbh->disconnect();

$qryResp .= "</sr>";

my $respStr = "<rsp>${statusString}${countString}${qryResp}</rsp>";

print "Content-type: text/xml; charset=utf-8\n\n";
print encode_utf8($respStr);

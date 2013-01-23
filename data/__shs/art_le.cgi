#!/usr/bin/perl

use strict; 
use HTTPD::GroupAdmin ();

# Only one case remains where an explicit use utf8 is needed:
# if your Perl script itself is encoded in UTF-8,
# you can use UTF-8 in your identifier names,
# and in string and regular expression literals, by saying use utf8.

use utf8;

# used for submitted values

use Encode 'decode_utf8';


# To output UTF-8, use the :utf8 output layer. Prepending
# binmode(STDOUT, ":utf8");
# to this program ensures that the output is completely UTF-8.

binmode(STDOUT, ":utf8");


use CGI;
my $q = new CGI;
my $scriptName = $ENV{SCRIPT_NAME};
my $ua = $ENV{HTTP_USER_AGENT};
my $DIC_DESC = $q->param('app_id');
my $APP_NIMETUS = decode_utf8($q->param('app_nimetus'));
my $APP_LANG = $q->param('app_lang');
my $usrName = decode_utf8($q->param('app_usr'));

# ats (09.11.12)
my $ccCount = 0;
my $ccPrevElem = "";
my $ccSaveStat = 0;
my $ccField = "";
my $ccHomNr = "";
#

unless ($ua =~ /MSIE/) {
	if ($scriptName =~ /\/art\.cgi$/) {

#		print "Location: art_crRef.cgi\n\n";
#		print $q->redirect('art_crRef.cgi');

        print "Content-type: text/html; charset=utf-8\n\n";

print <<"pContent";
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=utf-8\n\n">
<TITLE>"suunamine ..."</TITLE>
</HEAD>

<BODY style="background-color:seashell" topmargin="0" onload="sdata.submit()">
<form name="sdata" method="post" action="art_crRef.cgi">
    <input id="app_id" name="app_id" type="hidden" value="$DIC_DESC">
    <input id="app_lang" name="app_lang" type="hidden" value="$APP_LANG">
</form>

</BODY>
</HTML>
pContent

		exit;
	}
}

my $exsaAdminLoginName = 'EKI_EELex_EXSA';
my $exsaAdminDisplayName = 'exsaAdmin';

my $nEditAllowed = 0;
# 
my ($agf, $i);

if ($usrName eq "") { # EXSA puhul on juba initsialiseeritud
    $usrName = "$ENV{REMOTE_USER}";
    if ($usrName eq "") {
        print "Content-type: text/html; charset=utf-8\n\n";
        print "<h1>Authorization Required (1)</h1>";
        exit;
    }
    # siin nüüd EELex värk ...
    # võta .htaccess'ist failinimed
    open (HTACCESS, "<", '.htaccess') || die "can't open '.htaccess': $!";
    while (<HTACCESS>) {
        s/\s+$//; # chomp näib reavahetuse tühikuga asendavat ...
        next unless /^AuthGroupFile /;
        $agf = $';
    }
    close(HTACCESS) || die "can't close '.htaccess': $!";

    #kui õnnestus siis kontrolli kasutajat
    my $group;

    if (-e $agf) { #grupifail

        $group = new HTTPD::GroupAdmin (DBType => 'Text',
                                        DB     => $agf,
                                        Server => 'apache');

        if($group->exists("grp_${DIC_DESC}", $usrName)) {
            $nEditAllowed =  1;
        }
        
        elsif($group->exists("grp_DEV", $usrName)) {
            $nEditAllowed =  1;
        }
        
        elsif($group->exists("quest_${DIC_DESC}", $usrName) ){
            $usrName = 'vaataja';
        }

    } 
    else {
        print "Content-type: text/html; charset=utf-8\n\n";
        print "<h1>Authorization Required(2)</h1>";
        exit;
    }

    #Kui ei ole grupi õiguseid siis välja
    unless (($nEditAllowed == 1) || ($usrName eq 'vaataja')) {
        print "Content-type: text/html; charset=utf-8\n\n";
        print "<h1>${usrName} has no access for ${DIC_DESC}</h1>";
        exit;
    }

}
else { # siin peaks nüüd EXSA värk olema, kui on ...
	if ($usrName eq $exsaAdminLoginName) {
		$usrName = $exsaAdminDisplayName;
	}
	$nEditAllowed = 1;
}


# *****************************************************
# Constants
# *****************************************************

use XML::LibXML;
my $dicparser = XML::LibXML->new();

my $lcDom = $dicparser->parse_file('lc.xml');
my $lexListDom = $dicparser->parse_file('../lexlist.xml');

my $APP_DESC;
unless ($APP_NIMETUS) { # EELex
	# $APP_DESC = $lcDom->documentElement()->findvalue("itm[\@n = 'APP_DESC'][\@dd = '${DIC_DESC}'][\@l = '${APP_LANG}']");
	$APP_DESC = $lexListDom->documentElement()->findvalue("lex[\@id = '${DIC_DESC}']/name[\@l = '${APP_LANG}']");

}
else { # EXSA
	$APP_DESC = $APP_NIMETUS;
}

my $NAME_VOL = $lcDom->documentElement()->findvalue("art/itm[\@n = 'NAME_VOL'][\@l = '${APP_LANG}']");
my $DELD_VOL = $lcDom->documentElement()->findvalue("art/itm[\@n = 'DELD_VOL'][\@l = '${APP_LANG}']");
my $ALL_VOLS = $lcDom->documentElement()->findvalue("art/itm[\@n = 'ALL_VOLS'][\@l = '${APP_LANG}']");
my $NAME_FIND = $lcDom->documentElement()->findvalue("art/itm[\@n = 'NAME_FIND'][\@l = '${APP_LANG}']");
my $NAME_PATH = $lcDom->documentElement()->findvalue("art/itm[\@n = 'NAME_PATH'][\@l = '${APP_LANG}']");
my $NAME_EDIT = $lcDom->documentElement()->findvalue("art/itm[\@n = 'NAME_EDIT'][\@l = '${APP_LANG}']");
my $NAME_TABLE = $lcDom->documentElement()->findvalue("art/itm[\@n = 'NAME_TABLE'][\@l = '${APP_LANG}']");
my $NAME_AS_VIEW = $lcDom->documentElement()->findvalue("art/itm[\@n = 'NAME_AS_VIEW'][\@l = '${APP_LANG}']");
my $NAME_VIEW = $lcDom->documentElement()->findvalue("art/itm[\@n = 'NAME_VIEW'][\@l = '${APP_LANG}']");

my $TEST_DB = $lcDom->documentElement()->findvalue("art/itm[\@n = 'TEST_DB'][\@l = '${APP_LANG}']");
$TEST_DB = substr($TEST_DB, 3);

my $NAME_ARTICLE = $lcDom->documentElement()->findvalue("art/itm[\@n = 'NAME_ARTICLE'][\@l = '${APP_LANG}']");
my $NAME_IMAGES = $lcDom->documentElement()->findvalue("art/itm[\@n = 'NAME_IMAGES'][\@l = '${APP_LANG}']");
my $NAME_BROWSE = $lcDom->documentElement()->findvalue("art/itm[\@n = 'NAME_BROWSE'][\@l = '${APP_LANG}']");
my $CHOOSE_VOL = $lcDom->documentElement()->findvalue("art/itm[\@n = 'CHOOSE_VOL'][\@l = '${APP_LANG}']");
my $ADD_ARTICLE = $lcDom->documentElement()->findvalue("art/itm[\@n = 'ADD_ARTICLE'][\@l = '${APP_LANG}']");
my $PRINT_ARTICLES = $lcDom->documentElement()->findvalue("art/itm[\@n = 'PRINT_ARTICLES'][\@l = '${APP_LANG}']");
my $SR_TOOLS = $lcDom->documentElement()->findvalue("art/itm[\@n = 'SR_TOOLS'][\@l = '${APP_LANG}']");
my $IMPORT_ARTICLE = $lcDom->documentElement()->findvalue("art/itm[\@n = 'IMPORT_ARTICLE'][\@l = '${APP_LANG}']");
my $XML_SCHEMA = $lcDom->documentElement()->findvalue("art/itm[\@n = 'XML_SCHEMA'][\@l = '${APP_LANG}']");
my $APP_TIPS = $lcDom->documentElement()->findvalue("art/itm[\@n = 'APP_TIPS'][\@l = '${APP_LANG}']");
my $APP_HELP = $lcDom->documentElement()->findvalue("art/itm[\@n = 'APP_HELP'][\@l = '${APP_LANG}']");
my $ATTR_ENUMS = $lcDom->documentElement()->findvalue("art/itm[\@n = 'ATTR_ENUMS'][\@l = '${APP_LANG}']");
my $ATTR_TEXT = $lcDom->documentElement()->findvalue("art/itm[\@n = 'ATTR_TEXT'][\@l = '${APP_LANG}']");
my $ELEM_ENUMS = $lcDom->documentElement()->findvalue("art/itm[\@n = 'ELEM_ENUMS'][\@l = '${APP_LANG}']");
my $ELEM_TEXT = $lcDom->documentElement()->findvalue("art/itm[\@n = 'ELEM_TEXT'][\@l = '${APP_LANG}']");
my $ADV_QUERY = $lcDom->documentElement()->findvalue("art/itm[\@n = 'ADV_QUERY'][\@l = '${APP_LANG}']");
my $QRY_CASE_SENSITIVITY = $lcDom->documentElement()->findvalue("art/itm[\@n = 'QRY_CASE_SENSITIVITY'][\@l = '${APP_LANG}']");
my $QRY_SYMBOL_SENSITIVITY = $lcDom->documentElement()->findvalue("art/itm[\@n = 'QRY_SYMBOL_SENSITIVITY'][\@l = '${APP_LANG}']");
my $QRY_FAKULT_SENSITIVITY = $lcDom->documentElement()->findvalue("art/itm[\@n = 'QRY_FAKULT_SENSITIVITY'][\@l = '${APP_LANG}']");
my $QRY_GLOBAL_SENSITIVITY = $lcDom->documentElement()->findvalue("art/itm[\@n = 'QRY_GLOBAL_SENSITIVITY'][\@l = '${APP_LANG}']");
my $QRYTYPE_MODES = $lcDom->documentElement()->findvalue("art/itm[\@n = 'QRYTYPE_MODES'][\@l = '${APP_LANG}']");
my $ART_TOOLS = $lcDom->documentElement()->findvalue("art/itm[\@n = 'ART_TOOLS'][\@l = '${APP_LANG}']");
my $ENTRY_FIRST = $lcDom->documentElement()->findvalue("art/itm[\@n = 'ENTRY_FIRST'][\@l = '${APP_LANG}']");
my $ENTRY_PREV = $lcDom->documentElement()->findvalue("art/itm[\@n = 'ENTRY_PREV'][\@l = '${APP_LANG}']");
my $ENTRY_NEXT = $lcDom->documentElement()->findvalue("art/itm[\@n = 'ENTRY_NEXT'][\@l = '${APP_LANG}']");
my $ENTRY_LAST = $lcDom->documentElement()->findvalue("art/itm[\@n = 'ENTRY_LAST'][\@l = '${APP_LANG}']");
my $ART_HISTORY = $lcDom->documentElement()->findvalue("art/itm[\@n = 'ART_HISTORY'][\@l = '${APP_LANG}']");
my $EXPAND_COLLAPSE = $lcDom->documentElement()->findvalue("art/itm[\@n = 'EXPAND_COLLAPSE'][\@l = '${APP_LANG}']");
my $VALIDATE_ARTICLE = $lcDom->documentElement()->findvalue("art/itm[\@n = 'VALIDATE_ARTICLE'][\@l = '${APP_LANG}']");
my $SAVE_ARTICLE = $lcDom->documentElement()->findvalue("art/itm[\@n = 'SAVE_ARTICLE'][\@l = '${APP_LANG}']");
my $DELETE_ARTICLE = $lcDom->documentElement()->findvalue("art/itm[\@n = 'DELETE_ARTICLE'][\@l = '${APP_LANG}']");
my $APP_UNDO = $lcDom->documentElement()->findvalue("art/itm[\@n = 'APP_UNDO'][\@l = '${APP_LANG}']");
my $APP_REDO = $lcDom->documentElement()->findvalue("art/itm[\@n = 'APP_REDO'][\@l = '${APP_LANG}']");
my $UNDO_TITLE = $lcDom->documentElement()->findvalue("art/itm[\@n = 'UNDO_TITLE'][\@l = '${APP_LANG}']");
my $REDO_TITLE = $lcDom->documentElement()->findvalue("art/itm[\@n = 'REDO_TITLE'][\@l = '${APP_LANG}']");
my $ALIGN_VIEW_LEFT = $lcDom->documentElement()->findvalue("art/itm[\@n = 'ALIGN_VIEW_LEFT'][\@l = '${APP_LANG}']");
my $ALIGN_VIEW_CENTER = $lcDom->documentElement()->findvalue("art/itm[\@n = 'ALIGN_VIEW_CENTER'][\@l = '${APP_LANG}']");
my $ALIGN_VIEW_RIGHT = $lcDom->documentElement()->findvalue("art/itm[\@n = 'ALIGN_VIEW_RIGHT'][\@l = '${APP_LANG}']");
my $ALIGN_VIEW_JUSTIFY = $lcDom->documentElement()->findvalue("art/itm[\@n = 'ALIGN_VIEW_JUSTIFY'][\@l = '${APP_LANG}']");
my $PRINT_VIEW = $lcDom->documentElement()->findvalue("art/itm[\@n = 'PRINT_VIEW'][\@l = '${APP_LANG}']");
my $QRY_METHOD_XML = $lcDom->documentElement()->findvalue("art/itm[\@n = 'QRY_METHOD_XML'][\@l = '${APP_LANG}']");

my $sWTitle = '[' . uc($DIC_DESC) . ']';
my $backImageStyle = '';
my $bgColor = 'antiquewhite';
my $onTestDB = '';
if (index($scriptName, '/__shs_test/') > -1) {
	$bgColor = '#D0E3EF'; # #D0E3EF, WhiteSmoke
	$sWTitle .= " ${TEST_DB}";
	$onTestDB = $TEST_DB;
}
$sWTitle .= " ${APP_DESC}: '${usrName}'";
if ($ENV{SERVER_NAME} eq 'localhost') {
	$backImageStyle = "background-image:'url(graphics/vista_logo.jpg)';";
}

my $shsconfig = $dicparser->parse_file("shsconfig_${DIC_DESC}.xml");

my $mySqlDataVer = $shsconfig->documentElement()->findvalue('mySqlDataVer');
if ($mySqlDataVer) {
	$mySqlDataVer = "\x{2011}" . $mySqlDataVer;
}

my $eeLexConfDom = $dicparser->parse_file('shsConfig.xml');
my $eeLexQM = $eeLexConfDom->documentElement()->findvalue('qmMySql');
my $qryMethod = 'XML';
my $dbInfo = 'XML';
my $yhisedMySql = '';
if (index($eeLexQM, ";${DIC_DESC};") > -1) {
	$qryMethod = 'MySql';
	$dbInfo = "MySql${mySqlDataVer}\x{00A0}::\x{00A0}XML";

	# $yhisedMySql .= "<table>";
	my @sqlSqnastikud = split(/;/, substr($eeLexQM, 1, length($eeLexQM) - 2));
	@sqlSqnastikud = sort(@sqlSqnastikud);
	for ($i = 0; $i < scalar(@sqlSqnastikud); $i++) {
		my $sqlSqnastik = $sqlSqnastikud[$i];
		if ($sqlSqnastik ne $DIC_DESC) {
			my $sqlSqnastikKirjeldav = $lexListDom->documentElement()->findvalue("lex[\@id = '${sqlSqnastik}']/name[\@l = '${APP_LANG}']");
			$yhisedMySql .= "<tr id='mySqlYhisedMs/${sqlSqnastik}' class = 'mi' value='${sqlSqnastik}|||1|`${sqlSqnastik}`'>";
			$yhisedMySql .= "<td style='color:silver;'>${sqlSqnastik}</td>";
			$yhisedMySql .= "<td>${sqlSqnastikKirjeldav}</td>";
			$yhisedMySql .= "</tr>";
		}
	}
	# $yhisedMySql .= "</table>";
}
my $eeLexAinultMySql = $eeLexConfDom->documentElement()->findvalue('ainultMySql');
if (index($eeLexAinultMySql, ";${DIC_DESC};") > -1) {
	if ($qryMethod eq 'MySql') {
		$dbInfo = "MySql${mySqlDataVer}";
	}
}

my $vols = $shsconfig->documentElement()->findnodes('vols/vol');
my $volOpts = '';
foreach my $vol ($vols->get_nodelist()) {
	my $volNr = $vol->getAttribute('nr');
	my $volText = $vol->textContent;
	$volOpts .= "<option id='${DIC_DESC}${volNr}'>${volNr}. ${NAME_VOL} ${volText}</option>";
}
$volOpts .= "<option id='${DIC_DESC}All'";
if (($qryMethod eq 'MySql') && ($vols->size() > 1)) {
	$volOpts .= ' selected';
}
$volOpts .= ">${ALL_VOLS}</option>";
$volOpts .= "<option id='${DIC_DESC}0'>${DELD_VOL}</option>";

my $VERS_DB = $shsconfig->documentElement()->findvalue('VERS_DB');
my $illustratsNupp = '';
my $illustrats = $shsconfig->documentElement()->findvalue('illustrats');
if ($illustrats) {
	$illustratsNupp =
	"<td class='tbbt'>
		<img id='img_Images' title='${NAME_IMAGES}' src='graphics/Book_openHS.png' onclick='imgImagesClick()' onmouseover='SwitchTD(window.event)' onmouseout='SwitchTD(window.event)'>
	</td>";

}

# editFont: toimetamisala DIV-i "ifrdiv" font
# sätitakse ka dünaamiliselt, et 'EELex sätted', 'Fontide sätted' kohe jõustuksid
my $editFont = $shsconfig->documentElement()->findvalue('colorsFonts/editArea/editFont');
unless ($editFont) {
	$editFont = 'Times New Roman';
}

# editFontSize: toimetamisala DIV-i "ifrdiv" fondi suurus
# sätitakse ka dünaamiliselt, et 'EELex sätted', 'Fontide sätted' kohe jõustuksid
my $editFontSize = $shsconfig->documentElement()->findvalue('colorsFonts/editArea/editFontSize');
if ($editFontSize) {
	$editFontSize = "font-size:${editFontSize}pt;";
}

# vaateFont: vaate DIV-i "ifrviewdiv" font
# sätitakse ka dünaamiliselt, et 'EELex sätted', 'Fontide sätted' kohe jõustuksid
# läheb ka vaate XSL-i <body> 'style'-iks (kui ei ole Word väljatükk; sinna läheb "viewFont" + "wordFontSize")
my $vaateFont = $shsconfig->documentElement()->findvalue('colorsFonts/viewArea/viewFont');
unless ($vaateFont) {
	$vaateFont = 'Times New Roman';
}

# vaateFontSize: vaate DIV-i "ifrviewdiv" fondi suurus
# sätitakse ka dünaamiliselt, et 'EELex sätted', 'Fontide sätted' kohe jõustuksid
# läheb ka vaate XSL-i <body> 'style'-iks (kui ei ole Word väljatükk; sinna läheb "viewFont" + "wordFontSize")
my $vaateFontSize = $shsconfig->documentElement()->findvalue('colorsFonts/viewArea/viewFontSize');
if ($vaateFontSize) {
	$vaateFontSize = "font-size:${vaateFontSize}pt;";
}


print "Content-type: text/html; charset=utf-8\n\n";
print <<"artEdit";
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="x-ua-compatibleA" content="IE=5">
<meta http-equiv="x-ua-compatible" content="IE=EmulateIE9" >
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="pragma" content="no-cache">
<!--<meta http-equiv="refresh" content="10">-->
<meta name="copyright" content="Eesti Keele Instituut, Andres Loopmann">
<meta name="author" content="Andres Loopmann">
<meta name="keywords" content="EELex">
<link rel="stylesheet" type="text/css" href="css/script.css">
<link rel="stylesheet" type="text/css" href="css/edit_${DIC_DESC}.css">
<link id="viewCss" rel="stylesheet" type="text/css" href="css/view_${DIC_DESC}.css">
<TITLE>$sWTitle</TITLE>

<script type="text/javascript" src="htmlle/res_var.js"></script>
<script type="text/javascript" src="htmlle/res_lang_${APP_LANG}.js"></script>
<script type="text/javascript" src="htmlle/tools.js"></script>
<script type="text/javascript" src="htmlle/res_xml.js"></script>
<script type="text/javascript" src="htmlle/procs_app.js"></script>
<script type="text/javascript" src="htmlle/procs_edt.js"></script>
<script type="text/javascript" src="htmlle/kontrollid.js"></script>
<script type="text/javascript" src="htmlle/komponendid.js"></script>
<script type="text/javascript" src="htmlle/lisad.js"></script>
<script type="text/javascript" src="htmlle/procs_TextContMenu.js"></script>
<script type="text/javascript" src="htmlle/jwplayer/jwplayer.js"></script>
<script type="text/javascript" src="htmlle/ats_app.js"></script>

</HEAD>

<BODY style="background-color:seashell;${backImageStyle}" 
topmargin="0" 
onload="bodyOnLoad()" 
onkeyup="bodyOnKeyUp()"
onfocusout="documentOnFocusOut()">


	<PARAM NAME="propDd" VALUE="${DIC_DESC}">
</OBJECT>

<table id="tbl_Ops" style="background-color:gainsboro;margin-bottom:4px;width:100\%;">
<tr>
	<td width="1\%" title="$CHOOSE_VOL">
		<span style="text-transform:capitalize">${NAME_VOL}</span>:&nbsp;
		<select id="sel_Vol" onchange="volSelected()" tabindex="1">${volOpts}</select>
	</td>
	<td width="1px">|</td>
	<td class="tbbt">
		<img id="img_Record" title="$NAME_ARTICLE" src="graphics/kirje 16-16.ico" onclick="imgRecordClick()" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
	</td>
	${illustratsNupp}
	<td class="tbbt">
		<img id="img_Browse" title="$NAME_BROWSE" src="graphics/tabel 16-16.ico" onclick="imgBrowseClick()" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
	</td>
	<td width="1px">|</td>
	<td class="tbbt">
		<img id="img_ArtAdd" disabled title="$ADD_ARTICLE" onclick="imgArtAddClick()" src="graphics/addart 16-16.ico" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
	</td>
	<td class="tbbt">
		<img id="img_ArtExport" disabled title="$PRINT_ARTICLES" src="graphics/winword 16-16.ico" onclick="imgArtExportClick()" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
	</td>


	<td width="1px">|</td>
	<td class="tbbt">
		<img id="img_SrTools" disabled style="visibility:hidden" title="$SR_TOOLS" onclick="showSrToolsMenu()" src="graphics/hr_xp_shell32_16_256.ico" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
	</td>
	<td style="width:1px;"><span id="spn_dbInfo" style="font-size:xx-small;color:DimGray;">[$dbInfo]</span></td>
	<td width="1px">|</td>
	<td></td>

	<td width="1px">|</td>
	<td class="tbbt">
		<img id="img_ArtImport" disabled style="visibility:hidden" title="$IMPORT_ARTICLE" src="graphics/sahtel_16_16.ico" onclick="showImportDics()" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
	</td>
	<td width="1px">|</td>
	<td></td>
	<td width="1">|</td>
	<td class="tbbt">
		<img id="img_ShowSchema" title="$XML_SCHEMA" onclick="ShowSchema()" src="graphics/msxml_16-256.ico" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
	</td>
	<td class="tbbt">
		<img id="img_ShowTips" title="$APP_TIPS" onclick="ShowTipsTricks()" src="graphics/shell32_16-256.ico" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
	</td>
	<td class="tbbt">
		<img id="img_ShowHelp" title="$APP_HELP" onclick="ShowDicHelp()" src="graphics/qyl 16-16.ico" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
	</td>
</tr>
</table>

<table id="tbl_Input" style="width:100\%;MARGIN-BOTTOM:4px;
filter:progid:DXImageTransform.Microsoft.Gradient(GradientType=1, StartColorStr='#FFD700', EndColorStr='#FAEBD7')" border="0">
<tr valign="top" style="width:100\%">
	<td width="35\%" style="padding:2px;border:solid thin #FFD700;background-color:#FFD700">
		<span id="spn_ElemsMenu" style="width:100\%;background-color:infobackground;padding-left:8px;padding-right:8px;font-weight:bold;border:solid thin gray" onclick="ChooseElement()" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)"></span>
	</td>
	<td class="tbbt3">
		<img id="img_AttrEnumsMenu" title="$ATTR_ENUMS" onclick="ShowAttribEnums()" src="graphics/downarrow 16-16.ico" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
	</td>
	<td style="width:5\%">
		<input id="inp_AttrText" title="$ATTR_TEXT" style="width:100\%" maxlength="255" type="text" tabindex="2">
	</td>
	<td style="width:2\%">
	</td>
	<td class="tbbt3">
		<img id="img_ElemEnumsMenu" title="$ELEM_ENUMS" onclick="ShowElemEnums()" src="graphics/downarrow 16-16.ico" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
	</td>
	<td style="width:22\%">
		<input id="inp_ElemText" title="$ELEM_TEXT" style="width:100\%" maxlength="1024" type="text" tabindex="3" oncontextmenu="HandleWindowContextClick()" onfocus="inp_ElemTextOnFocus()">
	</td>
	<td class="tbbt3">
		<img id="img_advQuery" title="$ADV_QUERY" style="display:none;" onclick="getAdvQuery()" src="graphics/p.ico" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
	</td>
	<td style="width:24px;border:1px solid gray">
		<input id="inp_UseCase" style="height:12px" title="$QRY_CASE_SENSITIVITY" type="checkbox" checked tabindex="4">
	</td>
	<td style="width:24px;border:1px solid gray">
		<input id="inp_UseSymbols" style="height:12px" title="$QRY_SYMBOL_SENSITIVITY" type="checkbox" tabindex="5" onclick="useSymbolsOnClick()">
	</td>
	<td style="width:24px;border:1px solid gray">
		<input id="inp_UseFakult" style="height:12px" title="$QRY_FAKULT_SENSITIVITY" type="checkbox" checked tabindex="6">
	</td>
	<td style="width:24px;border:1px solid gray">
		<input id="inp_UseGlobal" style="height:12px" title="$QRY_GLOBAL_SENSITIVITY" type="checkbox" checked tabindex="7">
	</td>
	<td style="width:24px;border:1px solid gray" title="$QRYTYPE_MODES">
		<select id="sel_queryType" tabindex="8">
			<option id=".//text()" selected>.//text()</option>
			<option id="self::node()">.</option>
			<option id="text()">text()</option>
		</select>
	</td>
	<td></td>
	<td style="width:10\%">
		<input type="button" id="inp_RunQuery" onclick="btnRunQuery()" value="$NAME_FIND" style="width:100\%" tabindex="9">
	</td>
	<td style="width:3\%">
		<input type="button" id="inp_RunQueryXML" onclick="btnRunQuery()" value="xml" title="$QRY_METHOD_XML" style="width:100\%;" tabindex="10">
	</td>
</tr>
</table>

<DIV id="div_appSisu" style="background-color:seashell;position:relative;top:0;left:0;z-index:-2">
	<div id="div_NodeInfo" style="background-color:gainsboro;height:6mm;margin-bottom:4px;" onmouseover="showArtXML()">
		<b>$NAME_PATH<span id="spn_MsVal"></span><span id="spn_ArtModified"></span>]:</b>
		<span id="spn_NodeInfo"></span>
	</div>
	<!-- table-layout:fixed;word-wrap:break-word; -->
	<table id="tbl_XML" style="width:100\%;height:75\%;" border="1">
		<tr height="3\%">
			<td width="60\%">
				<table width="100\%">
					<tr>
						<td style="font-size:x-small;width:16px">$NAME_EDIT</td>
						<td style="width:16px;cursor:hand"><span id="xsl1Edit" style="visibility:hidden;font-weight:bold;font-size:x-small;" onclick="switchEdit(window.event.srcElement)">&nbsp;XML&nbsp;</span></td>
						<td style="width:16px;cursor:hand"><span id="xsl2Edit" style="visibility:hidden;font-weight:bold;font-size:x-small;" onclick="switchEdit(window.event.srcElement)">&nbsp;${NAME_TABLE}&nbsp;</span></td>
						<td style="width:16px;cursor:hand"><span id="xsl3Edit" style="visibility:hidden;font-weight:bold;font-size:x-small;" onclick="switchEdit(window.event.srcElement)">&nbsp;${NAME_AS_VIEW}&nbsp;</span></td>
						<td width="1px">|</td>
						<td class="tbbt2">
							<img id="img_ArtTools" disabled style="visibility:hidden" title="$ART_TOOLS" onclick="showArtToolsMenu()" src="graphics/tools_16_16.ico" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
						</td>
			            <td width="1px">|</td>
						<td class="tbbt2">
							<img id="img_readFirst" style="margin-top:1mm;" title="${ENTRY_FIRST}" onclick="showPrevNextEntry(0)" src="graphics/DataContainer_MoveFirstHS.png" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
						</td>
						<td class="tbbt2">
							<img id="img_readPrev" style="margin-top:1mm;" title="${ENTRY_PREV}" onclick="showPrevNextEntry(-1)" src="graphics/DataContainer_MovePreviousHS.png" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
						</td>
						<td class="tbbt2">
							<img id="img_readNext" style="margin-top:1mm;" title="${ENTRY_NEXT}" onclick="showPrevNextEntry(+1)" src="graphics/DataContainer_MoveNextHS.png" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
						</td>
						<td class="tbbt2">
							<img id="img_readLast" style="margin-top:1mm;" title="${ENTRY_LAST}" onclick="showPrevNextEntry(1000000)" src="graphics/DataContainer_MoveLastHS.png" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
						</td>
			            <td width="1px">|</td>
						<td class="tbbt2">
							<img id="img_artHistory" style="margin-top:1mm;width:24px;" title="${ART_HISTORY}" onclick="showArtHistory()" src="graphics/History.png" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
						</td>
			            <td width="1px">|</td>


                        <td class="tbbt2">
							<img id="img_artAttent" style="margin-top:1mm;width:24px;" onclick="showArtWarrant()" src="graphics/warning.ico" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
						</td>


						<td class="tbbt2">
							<img id="img_ExpandCollapse" style="margin-top:1mm;display:none;" title="${EXPAND_COLLAPSE}" onclick="artExpandCollapse()" src="graphics/112_Plus_Orange_16x16_72.png" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
						</td>
						<td></td>
						<td class="tbbt2">
							<img id="img_ArtValidate" style="visibility:hidden" title="$VALIDATE_ARTICLE" onclick="validateSR()" src="graphics/checkmrk 16-16.ico" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
						</td>
						<td class="tbbt2">
							<img id="img_ArtSave" disabled style="visibility:hidden" title="$SAVE_ARTICLE" onclick="imgArtSaveClick()" src="graphics/saveart 16-16.ico" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
						</td>
						<td class="tbbt2">
							<img id="img_ArtDelete" disabled style="visibility:hidden" title="$DELETE_ARTICLE" onclick="imgArtDeleteClick()" src="graphics/delart 16-16.ico" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
						</td>
						<td id="td_UndoRedoNumbers" style="visibility:hidden;FONT-SIZE:x-small;" width="10mm" valign="top">
							(<span id="spn_UndoRedoIndex" title="$UNDO_TITLE">0</span>/<span id="spn_UndoRedoLast" title="$REDO_TITLE">0</span>)
						</td>
						<td class="tbbt2">
							<img id="img_Undo" style="visibility:hidden" title="$APP_UNDO" src="graphics/back_grey 16-16.ico" onclick="UndoArticle()" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
						</td>
						<td class="tbbt2">
							<img id="img_Redo" style="visibility:hidden" title="$APP_REDO" src="graphics/forward_grey 16-16.ico" onclick="RedoArticle()" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
						</td>
					</tr>
				</table>
			</td>
			<td>
				<table width="100\%">
					<tr>
						<td style="FONT-SIZE:x-small;">$NAME_VIEW <select id="sel_Vaated" onchange="xslViewSelected()" style="width:4cm;visibility:hidden;"></select></td>
						<td></td>
						<td class="tbbt2">
							<img id="img_AlignLeft" style="visibility:hidden" title="$ALIGN_VIEW_LEFT" src="graphics/left.ico" onclick="SetIfrViewLeftAlign()" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
						</td>
						<td class="tbbt2">
							<img id="img_AlignCenter" style="visibility:hidden" title="$ALIGN_VIEW_CENTER" src="graphics/center.ico" onclick="SetIfrViewCenterAlign()" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
						</td>
						<td class="tbbt2">
							<img id="img_AlignRight" style="visibility:hidden" title="$ALIGN_VIEW_RIGHT" src="graphics/right.ico" onclick="SetIfrViewRightAlign()" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
						</td>
						<td class="tbbt2">
							<img id="img_AlignJustify" style="visibility:hidden" title="$ALIGN_VIEW_JUSTIFY" src="graphics/justify.ico" onclick="SetIfrViewJustifyAlign()" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
						</td>
						<td class="tbbt2">
							<img id="img_ArtPrint" style="visibility:hidden" title="$PRINT_VIEW" src="graphics/print 16-16.ico" onclick="imgArtPrintClick()" onmouseover="SwitchTD(window.event)" onmouseout="SwitchTD(window.event)">
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<div id="divFrameEdit" style="width:100\%;height:100\%;background-color:${bgColor};overflow-y:auto;" 
				onclick="HandleEditClick()"
				oncontextmenu="HandleContextClick()"
				tabIndex="20">
					<div id="ifrdiv" style="text-align:left;font-family:'${editFont}';${editFontSize}" onpropertychange="XMLChanged()"></div>
				</div>
			</td>
			<td>
				<div id="divFrameView" style="width:100\%;height:100\%;background-color:${bgColor};overflow-y:auto;" 
				onclick="HandleViewClick()"
				oncontextmenu="HandleViewContextClick()"
				ondblclick="HandleViewSelectionChange()"
				onselectionchange="HandleViewSelectionChange()"
				tabIndex="21">
					<div id="ifrviewdiv" style="text-align:left;font-family:'${vaateFont}';${vaateFontSize}"></div>
				</div>
			</td>
		</tr>
	</table>
</DIV>
<iframe id="frame_Browse" src="html/browseframe.htm" style="position:absolute;top:expression(div_appSisu.offsetTop);left:expression(div_appSisu.offsetLeft);width:expression(div_appSisu.offsetWidth);height:expression(div_appSisu.offsetHeight);z-index:-3"></iframe>
<iframe id="frame_dbgPrint" src="html/dbgframe.htm" style="position:absolute;top:expression(div_appSisu.offsetTop);left:expression(div_appSisu.offsetLeft);width:expression(div_appSisu.offsetWidth);height:expression(div_appSisu.offsetHeight);z-index:-4"></iframe>
<iframe id="frame_Images" src="html/imgsframe.htm" style="position:absolute;top:expression(div_appSisu.offsetTop);left:expression(div_appSisu.offsetLeft);width:expression(div_appSisu.offsetWidth);height:expression(div_appSisu.offsetHeight);z-index:-5"></iframe>
<table>
	<tr>
		<td>
			<img id="statusAnim" src="graphics/status_anim.gif" style="visibility:hidden">
		</td>
		<td  style="vertical-align:top;color:maroon;font-weight:bold;">${onTestDB}</td>
		<td  style="vertical-align:top;color:maroon;font-weight:bold;">  $VERS_DB</td>
		<td>
			<SPAN id="spn_msg" onclick="spnMsgDelete()"></SPAN>
		</td>
	</tr>
</table>

<span id="spn_SrvParms" style="display:none">$usrName\|$nEditAllowed\|$DIC_DESC\|$APP_LANG\|$APP_DESC</span>


<!-- A---------------------------------------------------------------------
B ------------------------------------------------------------------------- -->

<!-- otsitava elemendi valik -->
<div id="div_ElemsMenu" style="display:none; position:absolute; width:660px;height:480px;
background-color:menu; border:outset 3px gray; overflow-y:auto; padding-left:5px"
onmouseover="SwitchElemsMenu()" onmouseout="SwitchElemsMenu()"
onclick="ClickElemsMenu()" oncontextmenu="DisableContextMenu()"
onlosecapture="HideDivMenu()">
</div>

<!-- atribuutide valiku lisamenüü otsitava elemendi valiku kõrval -->
<div id="div_AttrsMenu" style="display:none; position:absolute; width:300px;
background-color:menu; border:outset 3px gray; padding-left:5px">
</div>



<!-- imporditavad sõnastikud -->
<div id="div_ImportDicts" style="display:none; position:absolute; width:400px;
background-color:menu; border:outset 3px gray; overflow-y:auto"
onmouseover="SwitchElemsMenu()" onmouseout="SwitchElemsMenu()"
onclick="ClickImportArticle()" oncontextmenu="DisableContextMenu()"
onlosecapture="HideDivMenu()">
	<table id='tbl_ImportDictsMenu' width='100%' border='0' cellSpacing='0'>
		<tr class='mi' id='evs' value='evs' title=''>
			<td>Eesti-Vene sõnaraamat</td>
			<td></td>
		</tr>
		<tr class='mi' id='ex_' value='ex_' title=''>
			<td>Eesti-X sõnastikupõhi</td>
			<td></td>
		</tr>
	</table>
</div>

<!-- elemendi väärtuste enum-id -->
<div id="div_ElemEnumsMenu" style="display:none; position:absolute; width:400px;
background-color:menu; border:outset 3px gray; overflow-y:auto"
onmouseover="SwitchElemsMenu()" onmouseout="SwitchElemsMenu()"
onclick="ClickElemEnums()" oncontextmenu="DisableContextMenu()"
onlosecapture="HideDivMenu()">
</div>

<!-- atribuudi väärtuste enum-id -->
<div id="div_AttrEnumsMenu" style="display:none; position:absolute; width:400px;
background-color:menu; border:outset 3px gray; overflow-y:auto"
onmouseover="SwitchElemsMenu()" onmouseout="SwitchElemsMenu()"
onclick="ClickAttribEnums()" oncontextmenu="DisableContextMenu()"
onlosecapture="HideDivMenu()">
</div>



<div id="cmenu" style="display:none; position:absolute; width:300px;
background-color:menu; border:outset 3px gray"
onmouseover="SwitchCMenu()" onmouseout="SwitchCMenu()"
onclick="ClickCMenu()" oncontextmenu="DisableContextMenu()"
onlosecapture="HideDivMenu()">
</div>

<div id="sm_before" style="display:none; position:absolute; width:300px;
background-color:menu; border:outset 3px gray">
</div>

<div id="sm_after" style="display:none; position:absolute; width:300px;
background-color:menu; border:outset 3px gray">
</div>

<div id="sm_insert" style="display:none; position:absolute; width:300px;
background-color:menu; border:outset 3px gray">
</div>

<div id="sm_attrs" style="display:none; position:absolute; width:300px;
background-color:menu; border:outset 3px gray">
</div>

<div id="paste_node_options" style="display:none; position:absolute; width:200px;
background-color:menu; border:outset 3px gray">
</div>

<div id="divMySqlYhisedMs" style="display:none; position:absolute; width:300px;
background-color:menu; border:outset 3px gray">
	${yhisedMySql}
</div>


<div id="tn_cmenu" style="display:none; position:absolute; width:300px;
background-color:menu; border:outset 3px gray"
onmouseover="SwitchCMenu()" onmouseout="SwitchCMenu()"
onclick="ClickTNCMenu()" oncontextmenu="DisableContextMenu()"
onlosecapture="HideDivMenu()">
</div>

<div id="tn_sm_before" style="display:none; position:absolute; width:300px;
background-color:menu; border:outset 3px gray">
</div>

<div id="tn_sm_after" style="display:none; position:absolute; width:300px;
background-color:menu; border:outset 3px gray">
</div>

<div id="tn_sm_insert" style="display:none; position:absolute; width:300px;
background-color:menu; border:outset 3px gray">
</div>


<!-- sõnastiku tööriistade menüü -->
<div id="div_SrToolsMenu" style="display:none; position:absolute; width:400px;
background-color:menu; border:outset 3px gray; overflow-y:auto"
onmouseover="SwitchElemsMenu()" onmouseout="SwitchElemsMenu()"
onclick="ClickSrToolsMenu()" oncontextmenu="DisableContextMenu()"
onlosecapture="HideDivMenu()">
</div>

<!-- artikli tööriistade menüü -->
<div id="div_ArtToolsMenu" style="display:none; position:absolute; width:400px;
background-color:menu; border:outset 3px gray; overflow-y:auto"
onmouseover="SwitchElemsMenu()" onmouseout="SwitchElemsMenu()"
onclick="ClickArtToolsMenu()" oncontextmenu="DisableContextMenu()"
onlosecapture="HideDivMenu()">
</div>

<!-- artiklite ajalugu -->
<div id="div_ArtHistoryMenu" style="display:none; position:absolute; width:360;height:400px;
background-color:menu; border:outset 3px gray; overflow-y:auto; padding-left:5px"
onmouseover="SwitchElemsMenu()" onmouseout="SwitchElemsMenu()"
onclick="ClickArtHistoryMenu()" oncontextmenu="DisableContextMenu()"
onlosecapture="HideDivMenu()">
	<table id="tbl_ArtHistoryMenu" width="100\%" border="0" cellSpacing="0"></table>
</div>

<!-- flash player -->
<div id="div_ArtJWPlayer" style="display:none; position:fixed; top:0; left:0; width:0; height:0; z-index:-1001">
</div>
<div id="div_ArtJWPlayerImage" style="display:none; position:absolute; width:256;">
	<img src="graphics/Speaker_256.png" alt="kõlar">
</div>

<!-- päringutulemuste veerud -->
<div id="div_BrTableCols" style="display:none; position:absolute; width:480;height:640px;
background-color:menu; border:outset 3px gray; overflow:auto; padding:5mm">
	<div id="div_skeemiJupp" style="width:100\%;height:85\%;background-color:white;padding:0;margin:0;"></div>
	<br/>
	<input type="button" id="veerudOk" onclick="veerudOkClick()" value=" Ok ">
	<input type="button" id="veerudCancel" onclick="veerudCancelClick()" value=" Loobu ">
</div>

</BODY>
</HTML>
artEdit

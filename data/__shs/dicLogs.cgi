#!/usr/bin/perl

use strict;
use utf8; # skripti ja tema sees olla võivate utf-8 muutujate (nimed, väärtused) tõttu
# decode_utf8, encode_utf8 ...
use Encode;
# et print laseks kõik utf-8 -s välja (kui on välja kommitud, siis iga 'print' po 'encode_utf8'
# VÄLJA ARVATUD 'DOM->toString' korral, sest on ise juba UTF-8
# Seega: kõik 'funcs' sarnased cgi-d po ILMA 'binmode' -ta.
binmode(STDOUT, ":utf8");


my $usrName = "$ENV{REMOTE_USER}";

use CGI;
my $q = new CGI;
my $DIC_DESC = decode_utf8($q->param('dic_desc'));
my $APP_LANG = $q->param('appLang');
my $wTitle = decode_utf8($q->param('par1'));
my $reqHw = decode_utf8($q->param('par2')); #headword, märksõna
my $reqUsr = decode_utf8($q->param('par3')); #milline kasutaja

# if ($usrName eq "") {
#	print "Content-type: text/html; charset=utf-8\n\n";
#	print "<h1>Permission denied</h1>";
#	exit;
# }


# *****************************************************
# Constants
# *****************************************************

my $PAGE_DESC = 'Toimetamiste logi: ';

print "Content-type: text/html; charset=utf-8\n\n";
print <<"beginPage";
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=utf-8\n\n">
<TITLE>"${PAGE_DESC}${wTitle}"</TITLE>

    <script type="text/javascript">
	<!--
		function bodyOnLoad() {
			var spnInfo = document.getElementById("spnInfo");
			spnInfo.innerHTML = document.getElementById("inpInfo").value;
		} // bodyOnLoad

		function bodyOnKeyUp() {
			var keyCode = ('which' in event) ? event.which : event.keyCode;
			if (keyCode == 27) {
				window.close();
			} else if (keyCode == 13) {
			}
		} // bodyOnKeyUp

		function btnRunOnClick() {
			var forward = document.getElementById("forward");
			var reqUsrText = document.getElementById("inpUser").value;
			if (reqUsrText) {
				forward.par3.value = reqUsrText;
			}
			var reqMsText = document.getElementById("inpMs").value;
			if (reqMsText) {
				forward.par2.value = reqMsText;
			}
			if (chkWrite.checked) {
				forward.par_S.value = " checked";
			}
			if (chkAdd.checked) {
				forward.par_L.value = " checked";
			}
			if (chkDelete.checked) {
				forward.par_K.value = " checked";
			}
			if (chkRestore.checked) {
				forward.par_T.value = " checked";
			}
			if (chkImportread.checked) {
				forward.par_I.value = " checked";
			}
			if (chkPrint.checked) {
				forward.par_W.value = " checked";
			}
			if (chkXMLCopy.checked) {
				forward.par_C.value = " checked";
			}
			if (chkBulkUpdates.checked) {
				forward.par_H.value = " checked";
			}
			if (chkGenSkeem.checked) {
				forward.par_GS.value = " checked";
			}
			if (chkGenVaade.checked) {
				forward.par_GV.value = " checked";
			}
			if (chkXMLChanges.checked) {
				forward.par_X.value = " checked";
			}
			if (chkBrowser.checked) {
				forward.par_B.value = " checked";
			}

			forward.submit()
		} // btnRunOnClick
	-->
	</script>

</HEAD>

<BODY style="background-color:seashell" topmargin="0" onkeyup="bodyOnKeyUp()" onload="bodyOnLoad()">
beginPage

my $DATE = 0;
my $TIME = 1;
my $USER = 2;
my $IP = 3;
my $CMDID = 4;
my $VOLFILE = 5;
my $STATUS = 7;
my $ARTCOUNT = 8;
my $QINFO = 9;
my $ARTMUUDATUSED = 12;
my $OPMS = 13;
my $OPATTRS = 14;

my @xFiles = glob("logs/${DIC_DESC}/*.log");
my @files = sort @xFiles;
my ($file, $i, @logiAsjad);
my ($asuKoht, $ps, $ms, $hom, $k, $l, $src, $alt, $muudatused, $attrs);
my ($n2idata, $kirjeid, $v6rreldav, $spikker);

print "<br/>";

my ($S_checked, $L_checked, $K_checked, $T_checked, $I_checked, $W_checked, $C_checked, $H_checked, $GS_checked, $GV_checked, $X_checked, $B_checked);
$S_checked = $q->param('par_S');
$L_checked = $q->param('par_L');
$K_checked = $q->param('par_K');
$T_checked = $q->param('par_T');
$I_checked = $q->param('par_I');
$W_checked = $q->param('par_W');
$C_checked = $q->param('par_C');
$H_checked = $q->param('par_H');
$GS_checked = $q->param('par_GS');
$GV_checked = $q->param('par_GV');
$X_checked = $q->param('par_X');
$B_checked = $q->param('par_B');


print <<"contPage";
<table border='1'>
	<tr>
		<td>
			<img src='graphics/saveart 16-16.ico'>
			<input id='chkWrite' type='checkbox'$S_checked></input><label for='chkWrite' title='salvestamine'>S</label></td>
		<td>
			<img src='graphics/addart 16-16.ico'>
			<input id='chkAdd' type='checkbox'$L_checked></input><label for='chkAdd' title='lisamine'>L</label></td>
		<td>
			<img src='graphics/delart 16-16.ico'>
			<input id='chkDelete' type='checkbox'$K_checked></input><label for='chkDelete' title='kustutamine'>K</label></td>
		<td>
			<img src='graphics/backtolist 16-16.ico'>
			<input id='chkRestore' type='checkbox'$T_checked></input><label for='chkRestore' title='taastamine'>T</label></td>
		<td>
			<img src='graphics/Book_openHS.png'>
			<input id='chkImportread' type='checkbox'$I_checked></input><label for='chkImportread' title='Import'>I</label></td>
		<td>
			<img src='graphics/winword 16-16.ico'>
			<input id='chkPrint' type='checkbox'$W_checked></input><label for='chkPrint' title='Word-i väljatrükk'>W</label></td>
		<td>
			<img src='graphics/CopyHS.png'>
			<input id='chkXMLCopy' type='checkbox'$C_checked></input><label for='chkXMLCopy' title='Baasi koopia'>C</label></td>
		<td>
			<img src='graphics/Datbase_16x16.ico'>
			<input id='chkBulkUpdates' type='checkbox'$H_checked></input><label for='chkBulkUpdates' title='Hulgiparandused'>H</label></td>
		<td>
			<img src='graphics/schema1 16-16.ico'>
			<input id='chkGenSkeem' type='checkbox'$GS_checked></input><label for='chkGenSkeem' title='Skeemi genereerimine'>GS</label></td>
		<td>
			<img src='graphics/bounce_16-256.ico'>
			<input id='chkGenVaade' type='checkbox'$GV_checked></input><label for='chkGenVaade' title='Vaate genereerimine'>GV</label></td>
		<td>
			<img src='graphics/justify.ico'>
			<input id='chkXMLChanges' type='checkbox'$X_checked></input><label for='chkXMLChanges' title='XML käsud'>X</label></td>
		<td>
			<img src='graphics/AppWindow.png'>
			<input id='chkBrowser' type='checkbox'$B_checked></input><label for='chkBrowser' title='Kasutatud brauser'>B</label></td>
	</tr>
</table>
<table>
	<tr>
		<td>Märksõna</td>
		<td>Toimetaja</td>
		<td rowSpan='2' valign='bottom'><input id='btnRun' type='submit' value=' Uuesti ' onclick='btnRunOnClick()'></input></td>
	</tr>
	<tr>
		<td><input id='inpMs' type='text' value='${reqHw}'></input></td>
		<td><input id='inpUser' type='text' value='${reqUsr}'></input></td>
	</tr>
</table>
<span id='spnInfo' style='background-color:info;'></span>
<br/>
<br/>
contPage

print "<table border='1' style='width:100%;'>\n";
print "<thead style='background-color:navy;color:white;'>\n";
print "<tr>\n";
print "<th colSpan='2'>Op</th>\n";
# print "<th>Op</th>\n";
print "<th>Kuupäev</th>\n";
print "<th>Aeg</th>\n";
print "<th>Toimetaja</th>\n";
# print "<th>Koht</th>\n";
# print "<th>\@Ps</th>\n";
print "<th>Märksõna</th>\n";
print "<th>Ms. atr.</th>\n";
print "<th>Arv</th>\n";
print "<th>St.</th>\n";
# print "<th>Hom</th>\n";
print "<th>Muudatused</th>\n";
print "</tr>\n";
print "</thead>\n";

$kirjeid = 0;

my $mituPaeva = 60;

for ($i = scalar(@files); $i--; $i > -1) {
	$file = $files[$i];

	open (THISLOG, "<:utf8", $file);
	while (<THISLOG>) {
		s/\s+$//; # chomp näib reavahetuse tühikuga asendavat ...
		@logiAsjad = split(/\t/);
		$n2idata = 0;
		$spikker = '';
		if ($logiAsjad[$CMDID] eq 'ClientWrite') {
			if ($S_checked eq ' checked') {
				$src = 'graphics/saveart 16-16.ico';
				$alt = 'S'; #salvestamine
				$n2idata = 1;
			}
		}
		elsif ($logiAsjad[$CMDID] eq 'ClientAdd') {
			if ($L_checked eq ' checked') {
				$src = 'graphics/addart 16-16.ico';
				$alt = 'L'; # lisamine
				$n2idata = 1;
			}
		}
		elsif ($logiAsjad[$CMDID] eq 'ClientDelete') {
			if ($K_checked eq ' checked') {
				$src = 'graphics/delart 16-16.ico';
				$alt = 'K'; # kustutamine
				$n2idata = 1;
			}
		}
		elsif ($logiAsjad[$CMDID] eq 'ClientRestore') {
			if ($T_checked eq ' checked') {
				$src = 'graphics/backtolist 16-16.ico';
				$alt = 'T'; # taastamine
				$n2idata = 1;
			}
		}
		elsif ($logiAsjad[$CMDID] eq 'ImportRead' || $logiAsjad[$CMDID] eq 'getHeadWords' || $logiAsjad[$CMDID] eq 'getHeadWordsChunk') {
			if ($I_checked eq ' checked') {
				$src = 'graphics/Book_openHS.png';
				$alt = 'I'; # import
				$spikker = $logiAsjad[$CMDID];
				$n2idata = 1;
			}
		}
		elsif ($logiAsjad[$CMDID] eq 'ClientPrint') {
			if ($W_checked eq ' checked') {
				$src = 'graphics/winword 16-16.ico';
				$alt = 'W'; # Word
				$n2idata = 1;
			}
		}
		elsif ($logiAsjad[$CMDID] eq 'xmlCopy' || $logiAsjad[$CMDID] eq 'msLoend') {
			if ($C_checked eq ' checked') {
				$src = 'graphics/CopyHS.png';
				$alt = 'C'; # copy
				$spikker = $logiAsjad[$CMDID];
				$n2idata = 1;
			}
		}
		elsif ($logiAsjad[$CMDID] eq 'hulgi_Käivita' || $logiAsjad[$CMDID] eq 'findReplace_RunOps') {
			if ($H_checked eq ' checked') {
				$src = 'graphics/Datbase_16x16.ico';
				$alt = 'H'; # hulgiparandused
				$spikker = $logiAsjad[$CMDID];
				$n2idata = 1;
			}
		}
		# eelkõige loendid, aga ka sätted
		elsif ($logiAsjad[$CMDID] eq 'updateXML' || $logiAsjad[$CMDID] eq 'insertAfter' || $logiAsjad[$CMDID] eq 'insertBefore' || $logiAsjad[$CMDID] eq 'removeNode') {
			if ($X_checked eq ' checked') {
				$src = 'graphics/justify.ico';
				$alt = 'X'; # XML commands
				$spikker = $logiAsjad[$CMDID];
				$n2idata = 1;
			}
		}
		elsif ($logiAsjad[$CMDID] eq 'saveGendXSD') {
			if ($GS_checked eq ' checked') {
				$src = 'graphics/schema1 16-16.ico';
				$alt = 'GS';
				$spikker = "Skeemi genereerimine";
				$n2idata = 1;
			}
		}
		elsif ($logiAsjad[$CMDID] eq 'saveGendView') {
			if ($GV_checked eq ' checked') {
				$src = 'graphics/bounce_16-256.ico';
				$alt = 'GV';
				$spikker = "Vaate genereerimine";
				$n2idata = 1;
			}
		}
		elsif ($logiAsjad[$CMDID] eq 'appOpen') {
			if ($B_checked eq ' checked') {
				$alt = 'B';
				$spikker = "Brauser";
				$n2idata = 1;
			}
		}
		
		#
		# neid nüüd ei näita ...
		#
		
		elsif ($logiAsjad[$CMDID] eq 'y') { # andmebaas on lukku pandud ...
			$src = '';
			$alt = 'L'; # read
			$n2idata = 0;
		}
		elsif ($logiAsjad[$CMDID] eq 'BrowseRead') {
			$src = '';
			$alt = 'B'; # browse
			$n2idata = 0;
		}
		elsif ($logiAsjad[$CMDID] eq 'ClientRead') {
			$src = '';
			$alt = 'R'; # read
			$n2idata = 0;
		}
		elsif ($logiAsjad[$CMDID] eq 'prevNextRead' || $logiAsjad[$CMDID] eq 'nextRead') {
			$src = '';
			$alt = 'J'; # järgmine
			$n2idata = 0;
		}
		elsif ($logiAsjad[$CMDID] eq 'SaveList') {
			$src = '';
			$alt = 'N'; # nimekiri
			$n2idata = 0;
		}
		elsif (substr($logiAsjad[$CMDID], 0, 7) eq 'readXML') {
			$src = '';
			$alt = 'RX'; # read node
			$n2idata = 0;
		}
		elsif (substr($logiAsjad[$CMDID], 0, 4) eq 'exsa' || $logiAsjad[$CMDID] eq 'uusSqnastik') {
			$src = '';
			$alt = 'X';
			$n2idata = 0;
		}
		elsif ($logiAsjad[$CMDID] eq 'getTextFileContent') {
			$src = '';
			$alt = 'GT'; # get text
			$n2idata = 0;
		}
		elsif (substr($logiAsjad[$CMDID], 0, 10) eq 'hulgi_Otsi' || substr($logiAsjad[$CMDID], 0, 11) eq 'findReplace') {
			$src = '';
			$alt = 'HO';
			$n2idata = 0;
		}
		elsif ($logiAsjad[$CMDID] eq 'findReplace_CompElements') {
			$src = '';
			$alt = 'VT'; # võrdle taandeid
			$n2idata = 0;
		}
		elsif ($logiAsjad[$CMDID] eq 'findReplace_Yksikud') {
			$src = '';
			$alt = 'LY';
			$n2idata = 0;
		}
		elsif ($logiAsjad[$CMDID] eq 'getFiles') {
			$src = '';
			$alt = 'GF';
			$n2idata = 0;
		}
		elsif (substr($logiAsjad[$CMDID], 0, 11) eq 'oxfordDuden') {
			$src = '';
			$alt = 'OD';
			$n2idata = 0;
		}
		elsif ($logiAsjad[$CMDID] eq 'msSarnased') {
			$src = '';
			$alt = 'MSS';
			$n2idata = 0;
		}
		elsif ($logiAsjad[$CMDID] eq 'tyhjadViited') {
			$src = '';
			$alt = 'TV';
			$n2idata = 0;
		}
		elsif ($logiAsjad[$CMDID] eq 'readArtByGuid') {
			$src = '';
			$alt = 'RG';
			$n2idata = 0;
		}
		elsif ($logiAsjad[$CMDID] eq 'getAddElements' || $logiAsjad[$CMDID] eq 'getAddElement') {
			$src = '';
			$alt = 'gAD';
			$n2idata = 0;
		}
		elsif ($logiAsjad[$CMDID] eq 'getFilesInfo') {
			$src = '';
			$alt = 'gFI';
			$n2idata = 0;
		}
		elsif ($logiAsjad[$CMDID] eq 'deleteFile') {
			$src = '';
			$alt = 'dF';
			$n2idata = 0;
		}
		elsif ($logiAsjad[$CMDID] eq 'getGUID') {
			$src = '';
			$alt = 'gG';
			$n2idata = 0;
		}
		elsif ($logiAsjad[$CMDID] eq 'srvXmlValidate') {
			$src = '';
			$alt = 'sxv';
			$n2idata = 0;
		}
		
		#
		# tundmatut näitame ...
		#
		
		else {
			$src = '';
			$alt = $logiAsjad[$CMDID];
			$n2idata = 1;
		}
		$ps = '-';
		$ms = '-';
		$hom = '';
		if ($logiAsjad[$OPMS]) {
			$ms = $logiAsjad[$OPMS];
			if ($ms eq "'opMs'") {
				$ms = "-";
			}
			elsif (substr($ms, 0, 12) eq 'fakultPtrn: ') {
				$ms = $logiAsjad[$QINFO]; #vanasti oli korraks 'fakultPtrn' OPMS asemel
			}
		}
		else {
			$ms = $logiAsjad[$QINFO];
		}
		if ($ms eq "'qinfo'") {
			$ms = "-";
		}

		$v6rreldav = $ms;

		$ms =~ s/&suba;(.+?)&subl;/<sub>$1<\/sub>/g;
		$ms =~ s/&supa;(.+?)&supl;/<sup>$1<\/sup>/g;
		$ms =~ s/&la;(.+?)&ll;/<u>$1<\/u>/g;
		$ms =~ s/&capa;(.+?)&capl;/<i style='font-weight:bold;font-style:italic;font-variant:small-caps;'>$1<\/i>/g;
		$ms =~ s/&br;/<br\/>/g;
		$ms =~ s/&ba;(.+?)&bl;/<b>$1<\/b>/g;
		$ms =~ s/&ema;(.+?)&eml;/<i>$1<\/i>/g;
		$ms =~ s/(&(ehk|Hrl|hrl|ja|jne|jt|ka|nt|puudub|v|vm|vms|vrd|vt|напр\.|и др\.|и т\. п\.|г\.);)/<i>$2<\/i>/g;

		$attrs = $logiAsjad[$OPATTRS];
		if ($attrs eq "" || $attrs eq "'opAttrs'") {
			$attrs = '-';
		}
		unless ($hom) {
			$hom = '-';
		}
		if ($reqHw) {
			if ($v6rreldav ne $reqHw) {
				$n2idata = 0;
			}
		}
		if ($reqUsr) {
			if ($logiAsjad[$USER] ne $reqUsr) {
				$n2idata = 0;
			}
		}
		if ($n2idata) {
			if ($logiAsjad[$CMDID] eq 'appOpen') {
				if ($v6rreldav eq 'IE') {
					$src = 'graphics/compatible_ie.gif';
				}
				elsif ($v6rreldav eq 'Firefox') {
					$src = 'graphics/compatible_firefox.gif';
				}
				elsif ($v6rreldav eq 'Chrome') {
					$src = 'graphics/compatible_chrome.gif';
				}
				elsif ($v6rreldav eq 'Opera') {
					$src = 'graphics/compatible_opera.gif';
				}
				elsif ($v6rreldav eq 'Safari') {
					$src = 'graphics/compatible_safari.gif';
				}
				else {
					$src = 'graphics/AppWindow.png';
				}
			}
			if (substr($logiAsjad[$IP], 0, 9) eq '"192.168.') {
				$asuKoht = "Tööl";
			}
			else {
				$asuKoht = "Väljas";
			}
			$muudatused = $logiAsjad[$ARTMUUDATUSED];
			unless ($muudatused) {
				$muudatused = '-';
			}
			else {
				if ($muudatused eq "'artMuudatused'") {
					$muudatused = '-';
				}
			}

#			$muudatused =~ s/&ema;(.+)&eml;/<i>$1<\/i>/og;
#			$muudatused =~ s/&ba;(.+)&bl;/<b>$1<\/b>/og;
#			$muudatused =~ s/&la;(.+)&ll;/<u>$1<\/u>/og;
#			$muudatused =~ s/&suba;(.+)&subl;/<sub>$1<\/sub>/og;
#			$muudatused =~ s/&supa;(.+)&supl;/<sup>$1<\/sup>/og;
#			if (length($muudatused) > 256 && length($muudatused) > length($ms)) {
#				$muudatused = substr($muudatused, 0, length($ms) - 5) . ' ...';
#			}

			$kirjeid++;
			print "<tr>\n";
			print "<td><img src='${src}' alt='${alt}'></td>\n";
			print "<td title='${spikker}'>${alt}</td>\n";
			print "<td>${logiAsjad[$DATE]}</td>\n";
			print "<td>${logiAsjad[$TIME]}</td>\n";
			print "<td>${logiAsjad[$USER]}</td>\n";
			# print "<td>${asuKoht}</td>\n";
			# print "<td>${ps}</td>\n";
			print "<td title='${logiAsjad[$QINFO]}'>${ms}</td>\n";
			print "<td>${attrs}</td>\n";
			print "<td>${logiAsjad[$ARTCOUNT]}</td>\n";
			print "<td>${logiAsjad[$STATUS]}</td>\n";
			# print "<td>${hom}</td>\n";
			print "<td>$muudatused</td>\n";
			print "</tr>\n";
		}
	}
	close(THISLOG);
	if ((scalar(@files) - $i) > $mituPaeva) {
		last;
	}
}
print "</table>\n";

print <<"contPage";
<form id="forward" name="forward" method="post">
	<input id="dic_desc" name="dic_desc" type="hidden" value="${DIC_DESC}">
	<input id="appLang" name="appLang" type="hidden" value="${APP_LANG}">
	<input id="par1" name="par1" type="hidden" value="${wTitle}">
	<input id="par2" name="par2" type="hidden" value="">
	<input id="par3" name="par3" type="hidden" value="">

	<input id="par_S" name="par_S" type="hidden" value="">
	<input id="par_L" name="par_L" type="hidden" value="">
	<input id="par_K" name="par_K" type="hidden" value="">
	<input id="par_T" name="par_T" type="hidden" value="">
	<input id="par_I" name="par_I" type="hidden" value="">
	<input id="par_W" name="par_W" type="hidden" value="">
	<input id="par_C" name="par_C" type="hidden" value="">
	<input id="par_H" name="par_H" type="hidden" value="">
	<input id="par_GS" name="par_GS" type="hidden" value="">
	<input id="par_GV" name="par_GV" type="hidden" value="">
	<input id="par_X" name="par_X" type="hidden" value="">
	<input id="par_B" name="par_B" type="hidden" value="">

</form>

<input id="inpInfo" name="inpInfo" type="hidden" value="Märksõna['<b>${reqHw}</b>'], toimetaja['<b>${reqUsr}</b>'] korral (viimased ${mituPaeva} päeva) kirjeid ${kirjeid} tk.">

</BODY>
</HTML>
contPage

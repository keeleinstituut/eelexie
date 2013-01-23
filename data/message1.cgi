#!/usr/bin/perl
use strict;
use CGI;
use Socket;

print "Content-type: text/html; charset=utf-8\n\n";

my $ua = $ENV{HTTP_USER_AGENT};
my $ra = $ENV{REMOTE_ADDR};
my $hn = gethostbyaddr(inet_aton($ra), AF_INET);

print <<"LoginPage";
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
	<head>
		<title>Üheköiteline seletav sõnaraamat - login</title>
		<META http-equiv="Content-Type" content="text/html; charset=utf-8">
		<script language="javascript">
		<!--
		function pl()
		{
			var uaname = "$ua";
				dicenter.disabled = true;
				dicdemo.disabled = true;
			if (uaname.indexOf("MSIE") == -1) {
				dicenter.disabled = true;
				dicdemo.disabled = true;
				notes.innerHTML = "Sõnastiku sisestust on testitud <b>MS Internet Explorer</b> - ga. Palume kasutada <b>MSIE (7+)</b>!";
			}
		}
		-->
		</script>
		
		<script language="vbscript">
		<!--
		
		Function GoToWork()
			sdata.action = "__shs/art.cgi"
			sdata.submit()
		End Function 'GoToWork

		Function GoToDemo()
			sdata.submit()
		End Function 'GoToDemo
		
		-->
		</script>
    <style type="text/css">
    body,td,th {
	color: #F00;
}
    </style>

	</head>
	<body onload="pl()">
		<BR>
		<BR>
		<H2 align="center">Toimub sõnaraamatu tööversiooni uuendamine.<br>Palun proovige mõne aja möödudes uuesti!</H2>
		<BR>
		<table style="WIDTH: 100\%; HEIGHT: 70px; BACKGROUND-COLOR: silver" align="center">
		<tr>
		<td align="center"><INPUT id="dicenter" name="dicenter" type="button" value="Tööversioon" title="Alt-T" accesskey="t" onclick="GoToWork()"></td>
		<td align="center"><INPUT id="dicdemo" name="dicdemo" type="button" value="Testversioon" title="Alt-E" accesskey="e" onclick="GoToDemo()"></td>
		</tr>
		</table>
		<BR>
		<BR>
		<HR width="100%" SIZE="1">
		<DIV id="ua" style="color:gray;font-size:x-small">Brauser $ua</DIV>
		<DIV id="from" style="color:gray;font-size:x-small">aadressilt: $ra ($hn)</DIV>
		<BR>
		<DIV id="notes" style="color:red;font-size:small"></DIV>
		<br />
		<br />
		<br />
		<br />
		<br />
		<br />
		<br />
		<br />
		<br />
		<br />
		<br />
		<form name="sdata" method="post" action="__shs_test/art.cgi">
			<input id="app_id" name="app_id" type="hidden" value="ss1">
			<input id="app_lang" name="app_lang" type="hidden" value="et">
		</form>
	</body>
</html>

LoginPage

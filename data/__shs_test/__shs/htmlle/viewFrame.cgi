#!/usr/bin/perl
use strict;

print "Content-type: text/html; charset=utf-8\n\n";

my $bgColor = 'antiquewhite';
if (index($ENV{SCRIPT_NAME}, '/__shs_test/') > -1) {
	$bgColor = 'khaki';
}


print <<"frmContent";
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	</head>
	<body id="viewFrameBodyId" style="background-color:${bgColor};">
		<div id="ifrviewdiv" style="text-align:left;font-family:'Times New Roman';"></div>
	</body>
</html>
frmContent

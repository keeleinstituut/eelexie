#!/usr/bin/perl

use strict;
# use utf8; # skripti ja tema sees olla võivate utf-8 muutujate (nimed, väärtused) tõttu
# decode_utf8, encode_utf8 ...
# use Encode;
# et print laseks kõik utf-8 -s välja (kui on välja kommitud, siis iga 'print' po 'encode_utf8',
# VÄLJA ARVATUD 'DOM->toString' korral, sest on ise juba UTF-8
# Seega: kõik 'funcs' sarnased cgi-d po ILMA 'binmode' -ta.
# binmode(STDOUT, ":utf8");


# *****************************************************
# CGI parameters
# *****************************************************

use CGI;
$CGI::POST_MAX = 1024 * 5000;
# We'll also use the CGI::Carp module to display errors in the web page, rather than displaying a generic 
# "500 Server Error" message (it's a good idea to comment out this line in a production environment
use CGI::Carp qw ( fatalsToBrowser );
my $q = new CGI;

print "Content-type: text/html; charset=utf-8\n\n";
print <<END_HTML;
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="et" lang="et">
 <head>
   <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
   <title>Vali fail</title>

        <script type="text/javascript">
        <!--

			function upLoadFile() {
				oForm.submit();
			}


        -->
        </script>
 </head>
 <body style="background-color:buttonface">
END_HTML


my $fileName = $q->param('inpFile');
my $dic_desc = $q->param('dic_desc');
my $fBase = $q->param('fBase');
my $fDir = $q->param('fDir');
if ($fileName) {
	my $upload_filehandle = $q->upload("inpFile");
	my $fName;
    if ($fileName =~ /([^\/\\]+)$/) {
		$fName = "$1";
    }
    else {
        $fName = "$fileName";
    }

	my $fullName = $fDir . $fName;

	$fullName =~ s/õ/\xF5/g;
	$fullName =~ s/Õ/\xD5/g;
	$fullName =~ s/ä/\xE4/g;
	$fullName =~ s/Ä/\xC4/g;
	$fullName =~ s/ö/\xF6/g;
	$fullName =~ s/Ö/\xD6/g;
	$fullName =~ s/ü/\xFC/g;
	$fullName =~ s/Ü/\xDC/g;
	$fullName =~ s/š/sh/g;
	$fullName =~ s/Š/Sh/g;
	$fullName =~ s/ž/zh/g;
	$fullName =~ s/Ž/Zh/g;

	my $safe_filename_characters = "a-zA-Z0-9_ ()\xF5\xD5\xE4\xC4\xF6\xD6\xFC\xDC.-/";
#	$fullName =~ s/[^$safe_filename_characters]//g;
	if ( $fullName =~ /^([$safe_filename_characters]+)$/ ) {
		$fullName = $1;
	}
	else {
		die "Vigased tähed failinimes: ${fullName}";
	}

	my $var1257 = "__sr/${dic_desc}${fBase}${fullName}";
	open ( UPLOADFILE, ">${var1257}") or die "$!";
	binmode UPLOADFILE;
	while ( <$upload_filehandle> ) {
	 print UPLOADFILE;
	}
	close UPLOADFILE;
	umask 0000;
	chmod(oct('0666'), $var1257);

	print "<p>Täname faili laadimise eest!</p>";
	print "<p>Fail: $fileName</p>";
}

print <<END_HTML;
	<br />
	<div id="idBody" style="padding:5mm 10mm 5mm 10mm;">
		<FORM id="oForm" NAME="oForm" ENCTYPE="multipart/form-data" METHOD="post">
			<INPUT TYPE="file" id="inpFile" NAME="inpFile" />
			<INPUT TYPE="button" VALUE=" Lae üles " onclick="upLoadFile()">
			<INPUT id="dic_desc" name="dic_desc" TYPE="hidden" VALUE="${dic_desc}">
			<INPUT id="fBase" name="fBase" TYPE="hidden" VALUE="${fBase}">
			<INPUT id="fDir" name="fDir" TYPE="hidden" VALUE="${fDir}">
		</FORM>
	</div>
</body>
</html>
END_HTML

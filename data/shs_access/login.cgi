#!/usr/bin/perl
use strict;
#use CGI;
use Socket;

# UUE SONARAAMATU LISAMISEKS lisa see veebijuurikasse, faili lexlist.xml

print "Content-type: text/html; charset=utf-8\n\n";
my $ua = $ENV{HTTP_USER_AGENT};
my $ra = $ENV{REMOTE_ADDR};
my $hn = gethostbyaddr(inet_aton($ra), AF_INET);

print <<"Pais";
<html XMLNS:shs="http://www.eki.ee/shs">
<head>
    <title>EELex login</title>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="cache-control" content="no-cache" />
    <link href="/eki.css" rel="stylesheet" type="text/css">
</head>
<body>
<div id="sisu">
Pais

if ($hn !~ /\.eki\.ee$/) {
#    print "<h1>Lp. $hn! Lehek&uuml;lg on kasutamiseks EKI sisev&otilde;rgus</h1>\n</body></html>\n";
#    exit;
}

# if ($ua !~ / MSIE/) {
#    print "<h1>NB! Ilma Internet Explorerita pole m&otilde;tet j&auml;tkata!</h1>\n";
# }

print "<div style=\"float:right;text-align:right\">\n";
print "<h4>kasutaja</h4>\n";
print "<ul>";
print "<li><b><a href=\"http://eelextest.eki.ee/run/SL/Koond/Koond.html#/Algus\">S&otilde;nastike &uuml;hisp&auml;ring</a></b></li>\n";
print "</ul>";
print "<h4>toimetaja</h4>\n";
print "<ul>";
print "<li><b><a href=\"http://eelextest.eki.ee/shs_access/halda.cgi\">Kasutajate haldus</a></b></li>\n";
print "</ul>";
print "<h4>arendaja</h4>\n";
print "<ul>";
print "<li><b><a href=\"http://eelextest.eki.ee/shs_manager/shs_list.cgi\">S&otilde;nastike haldus</a></b></li>\n";
print "<li><b><a href=\"http://eelextest.eki.ee/shs_access/admhalda.cgi\">Kasutajagrupid</a></b></li>\n";
print "<li><b><a href=\"http://eelextest.eki.ee/shs_manager/newdict\">Uus s&otilde;nastik</a></b></li>\n";
print "<br>\n";

my $d = (stat('tooplaan.xls'))[9];
my ($kp, $kk) = (localtime($d))[3..4];
$kk++;
$d = " ($kp.$kk)";
print "<li><b><a href=\"http://eelextest.eki.ee/shs_login.cgi?app_id=ess\">S&otilde;nastike s&otilde;nastik</a></b></li>\n";
print "<li><b><a href=\"tooplaan.xls\">T&ouml;&ouml;plaan$d</a></b></li>\n";
print "</ul>";
print "</div>";

my %lc_tyyp = ();	# lexlist sisu
my %lc_plk = ();	# lexlist sisu
my %lc_lf = ();		# lexlist sisu
my %lc_id = ();		# lexlist sisu, 3taheline id lihtsalt naitamiseks
my %lc_mysql = ();		# config sisu
my %lc_xml = ();		# config sisu
my %lc_testmysql = ();		# config sisu
my %lc_testxml = ();		# config sisu

my ($jrk, $id, $type, $lf, $plk, $pikkrida, $lex) = '';

my $webroot = '/var/www/EELex/data/';
my $lcxml = $webroot . 'lexlist.xml';
my $lang = 'et';

my $tcc_mysql = '';		# config sisu
my $tcc_ainultmysql = '';	# config sisu
my $tcc_conf = $webroot . '__shs/shsConfig.xml';
if (-e $tcc_conf) {
    open (F, "<$tcc_conf");
    # binmode (F, ":utf8");
    while (<F>) {
	chomp;
	$tcc_mysql = $1 if /<qmMySql>(.*)<\/qmMySql>/;
	$tcc_ainultmysql = $1 if /<ainultMySql>(.*)<\/ainultMySql>/;
    }
    close (F);
}

my $test_mysql = '';		# config sisu
my $test_ainultmysql = '';	# config sisu
my $test_conf = $webroot . '__shs_test/shsConfig.xml';
if (-e $test_conf) {
    open (F, "<$test_conf");
    # binmode (F, ":utf8");
    while (<F>) {
	chomp;
	$test_mysql = $1 if /<qmMySql>(.*)<\/qmMySql>/;
	$test_ainultmysql = $1 if /<ainultMySql>(.*)<\/ainultMySql>/;
    }
    close (F);
}

if (-e $lcxml) {
    open (F, "<$lcxml");
    # binmode (F, ":utf8");
    $jrk = 'a';
    $pikkrida = '';
    while (<F>) {
	chomp;
	$pikkrida .= $_;
    }
    close (F);
} else {
    print "VIGA: $lcxml puudu\n</div></body>\n</html>\n";
    exit;
}

sub getmysqlver {
    my $conff = shift;
    if (-e $conff) {
	open (F, "<$conff");
	while (<F>) {
	    chomp;
	    return '-'.$1 if /<mySqlDataVer>(.*)<\/mySqlDataVer>/;
	}
	close (F);
    }
    return '';
}

while ($pikkrida =~ /<lex .+?<\/lex>/) {
	$pikkrida = $';
	$lex = $&;
	
	next unless $lex =~ / id=\"(.+?)\"/; # kui id puudub, ei tee midagi
	$id = $1;

# kommenteeri valja, kui tahad kuvada lexlist-i jarjestust
	$jrk = $id;

	while ($lex =~ /<(note|comment)>.*?<\/\1>/ ) { $lex = $` . $'; }
	while ($lex =~ /<name l=.(.+?).>(.+?)<\/name>/ ) {
	    $lex = $` . $';
	    next unless $1 eq $lang;
	    $lc_plk{$jrk} = $2;
	}

# kommenteeri valja, kui tahad kuvada lexlist-i jarjestust
#	$jrk = $lc_plk{$jrk};

	$lc_xml{$jrk} = ($tcc_ainultmysql =~ /$id/ ? '' : ' XML');
	$lc_mysql{$jrk} = ($tcc_mysql =~ /$id/ ? ' MySQL' : '');
	$lc_testxml{$jrk} = ($test_ainultmysql =~ /$id/ ? '' : ' XML');
	$lc_testmysql{$jrk} = ($test_mysql =~ /$id/ ? ' MySQL' : '');

	$lc_mysql{$jrk} .= &getmysqlver ($webroot.'__shs/shsconfig_'.$id.'.xml');
	$lc_testmysql{$jrk} .= &getmysqlver ($webroot.'__shs_test/shsconfig_'.$id.'.xml');

	$type = '';
	$type = $1 if $lex =~ / type=\"(.+?)\"/;
	$lc_tyyp{$jrk} = $type;

	$lf = 'shs_login.cgi?app_id=' . $id;
	$lf = $1 if $lex =~ / lf=\"(.+?)\"/;
	$lc_lf{$jrk} = $lf;
	$lc_id{$jrk} = $id;

	$jrk .= 'a';
}

#foreach $jrk (sort keys %lc_plk) { print "$jrk", '=', $lc_plk{$jrk} };

&prindisektsioon ('ykskeelsed', '&Uuml;kskeelsed s&otilde;nastikud', 'Yks');
&prindisektsioon ('mitmekeelsed', 'Mitmekeelsed s&otilde;nastikud', 'Mit');
&prindisektsioon ('terminoloogilised', 'Terminoloogia andmebaasid', 'Trm');
&prindisektsioon ('liigitamata', 'Muud', 'Muu');

sub prindisektsioon {
    my ($sklass, $splk, $smargend) = @_;
    my $i = 1;

    print "<div id=\"$sklass\" style=\"width:550;margin-right:120;\"><h2>$splk</h2>\n<ul>\n";
    print "<table>\n";
    foreach $jrk (sort { lc($lc_plk{$a}) cmp lc($lc_plk{$b}) } keys %lc_tyyp)  {
	my $bk = ' style="background-color:#deeeee"' if ($i % 2);
	next unless $lc_tyyp{$jrk} eq $smargend;
	$plk = $lc_plk{$jrk};
	$lf = $lc_lf{$jrk};
	print "<tr>\n";
	print "<tr$bk><td width=380><tt>" . $lc_id{$jrk} . "</tt> &nbsp; <a href=\"http://eelextest.eki.ee/$lf\">$plk</a></td>";
	print "<td><span class=\"pisi\">" . $lc_xml{$jrk} . $lc_mysql{$jrk} . "</span></td>";
	print "<td><span class=\"pisi\">" . $lc_testxml{$jrk} . $lc_testmysql{$jrk} . "</span></td>";
	print "</tr>\n";
	$i++;
    }
    print "</table>";
    print "</div>\n\n";
}

print "</div>\n</body>\n</html>\n";

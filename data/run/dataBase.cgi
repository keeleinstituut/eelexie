#!/perl/bin/perl

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


my $startTime = time();


use CGI;
my $q = new CGI;

my $cmdId = decode_utf8($q->param('cmd'));
if ($cmdId eq '') {
	print "Content-type: text/plain; charset=utf-8\n\n";
	print 'POST data not defined.';
	exit;
}

my $remoteAddress = $ENV{REMOTE_ADDR}; #HTTP_X_FORWARDED_FOR, REMOTE_ADDR
use Socket;
my $hostName = gethostbyaddr(inet_aton($remoteAddress), AF_INET);

my $retString = '';

if ($cmdId eq 'send') {
	my $localIPs = decode_utf8($q->param('ip'));
	my $localGWs = decode_utf8($q->param('gw'));
	my $physicalAdresses = decode_utf8($q->param('ph'));
	my $dnsSuffixes = decode_utf8($q->param('ds'));
	my $userDomainName = decode_utf8($q->param('ud'));
	my $userName = decode_utf8($q->param('un'));
	my $userDisplayName = decode_utf8($q->param('dn'));
	my $machineName = decode_utf8($q->param('mn'));
	my $osVersion = decode_utf8($q->param('ov'));
	my $clrVersion = decode_utf8($q->param('cv'));

	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime($startTime);
	my $nowdtstr = sprintf("%04d-%02d-%02dT%02d:%02d:%02d", $year + 1900, $mon + 1, $mday, $hour, $min, $sec);
	my $logFileName = substr($nowdtstr, 0, 10);

	use Tie::File;
	my @logLines;
	tie(@logLines, 'Tie::File', "dataBase/${logFileName}.log");

	my $logLine = "${nowdtstr}\t${remoteAddress}\t${hostName}\t${localIPs}\t${localGWs}\t${physicalAdresses}\t${dnsSuffixes}\t${userDomainName}\t${userName}\t${userDisplayName}\t${machineName}\t${osVersion}\t${clrVersion}";

	unshift(@logLines, encode_utf8($logLine));
	untie(@logLines);
	
	$retString = 'Okk';
}
elsif ($cmdId eq 'news') {
	my $lastNewsFileName = decode_utf8($q->param('last'));
	my @newsFiles = glob('news/*.rtf');
#	@articles = sort {$a cmp $b} @files;
#	@articles = sort {$b cmp $a} @files;
#	@articles = sort {uc($a) cmp uc($b)} @files;
	@newsFiles = sort {$a cmp $b} @newsFiles;
	if (scalar(@newsFiles) > 0) {
		foreach my $newsFile (@newsFiles) {
			my $fn = substr($newsFile, rindex($newsFile, '/') + 1);
			if ($fn eq $lastNewsFileName) {
				$retString = '';
			}
			else {
				$retString .= '|' . $fn;
			}
		}
	}
	$retString = substr($retString, 1);
}


print "Content-type: text/xml; charset=utf-8\n\n";
print encode_utf8($retString);


#!/usr/bin/perl

use strict;

use utf8;
use Encode 'decode_utf8';
binmode(STDOUT, ":utf8");

use CGI;
use POSIX qw(strftime);

#use lib qw( ./ );
#use SHS_man;
#use SHS_cfg (':dir', ':file');

my $q = new CGI;
print $q->header ( -charset => "UTF-8" );

my $ua = $ENV{HTTP_USER_AGENT};
my $ra = $ENV{REMOTE_ADDR};
my $usr = "$ENV{REMOTE_USER}";

my $stime = strftime("%Y-%m-%dT%H:%M:%S", localtime);

# document out 
# kasutatud muutujad 
print<<"axa";
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
    <link rel="stylesheet" type="text/css" href="/eelex.css" />
	<meta http-equiv="Content-type" content="text/html;charset=UTF-8" />
		<title>Sõnastike haldus</title>
	    <style type="text/css">


        </style>
	</head>
	<body>
	
	<h2>Sõnastike haldus</h2>
    <a href="shs_list.cgi">Sõnastike nimekiri</a></br>
  
     <br/>
    <br/>
    <br/>
    <br/>
        <a href="newdict">uus sõnastik</a>
    <br/>
      <br/>
    <br/>
    <form action="http://www.eki.ee/mantis/login.php" method="post" name="login_form">
        <input type="hidden" name="username" value="vaataja">
        <input type="hidden" name="password" value="vaataja">
        <input type="hidden" name="perm_login" value="vaataja">
        <input type="submit" value="Teata vigadest" class="button">
    </form>
    <br/>
    <br/>
    <br/>
    <br/>
    ip: $ra <br/>
    kasutaja: $usr<br/>
    aeg: $stime <br/>
    <a href="errlog.cgi">vead</a></br><br/>
  
	</body>
</html>
axa

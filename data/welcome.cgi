#!/usr/bin/perl -wT

use strict;
my $time = localtime;
my $remote_id = $ENV{REMOTE_HOST} || $ENV{REMOTE_ADDR};
my $admin_email = $ENV{SERVER_ADMIN};

print "Content-type: text\html\n\n";

print <<END_OF_PAGE;
<HTML>
<HEAD>
  <TITLE>Teretulemast Bolani andmebaasi</TITLE>
</HEAD>

<BODY BGCOLOR="#ffffff">
<P>Tere tulemast $remote_id!</P>
<P>Jooksev aeg serveris on $time</P>
</BODY>
</HTML>
END_OF_PAGE

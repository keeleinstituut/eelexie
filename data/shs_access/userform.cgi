#!/usr/bin/perl -T
# use strict;
use Encode 'decode_utf8';
use Data::UUID;
use CGI qw( -utf8 );

binmode(STDOUT, ":utf8");

$ENV{PATH} = '/usr/sbin:/sbin:/root/bin:/bin';
my $pwdir = '/var/www/EELex/shs_users';

my $q = new CGI;
$q->charset("utf-8");

my $uuid = new Data::UUID;
my $guid = $uuid->create_str();

print $q->header ( -charset => "utf-8" );
print $q->start_html(
    -title => 'EELex - new user',
    -style => { 'src' => '/eelex.css' },
);
print "<div style=\"margin-left:120px; margin-top:30px; width:600px;\"/>\n";

my $txrn = ' <span style="font:bold 24px; color:red">*</span>';
my $nurin_nimi = ($q->param('parisnimi') =~ /. ./ ? '' : $txrn);
my $nurin_meil = ($q->param('meil') =~ /^[a-z._\-]+\@[a-z._\-]+$/i ? '' : $txrn);
my $nurin_pass1 = ($q->param('parool1') =~ /^\s*$/ ? $txrn : '');
my $nurin_pass2 = ($q->param('parool1') eq $q->param('parool2') ? '' : $txrn);


print "<p style=\"text-align:right;\"/><a href=\"./ankeet.cgi\"><b>Ankeet eesti keeles</b></a></p>\n";

print $q->start_form (
    -method => 'POST',
);

print "<h2>Please enter your first and last name$nurin_nimi</h2>\n";
print $q->textfield ( 'parisnimi', '', 60, 80);
print "<h2>Please enter you e-mail address$nurin_meil</h2>\n";
print $q->textfield ( 'meil', '', 60, 80);
print "<h2>Please enter a password$nurin_pass1</h2>\n";
print $q->password_field ( 'parool1', '', 30, 80);
print "<h2>Please repeat the same password$nurin_pass2</h2>\n";
print $q->password_field ( 'parool2', '', 30, 80);
print "<p style=\"margin-left:240px;\"/>\n";
print $q->submit ( 'I want to register my EELex user account.' );

if ($nurin_nimi . $nurin_meil . $nurin_pass1 . $nurin_pass2) {
    print "<p style=\"margin-left:240px; color:red;\">Fields marked with <b>*</b> must be filled correctly.</p>\n";
}
else {
    print "<p>Please note that you cannot login immediately.</p>\n";
    print "<p>The form will be forwarded to EELex administrator(s), you are redirected to the front page.</p>\n";
    print "<h2><a href=\"../\">Back to EELex front page</a>.</h2>\n";
    salvestaankeet();
}

print $q->end_form;

print <<Lisateave;

<hr>
<h2>Lisateave</h2>
<ul>
<li> Your password will be stored uncrypted.
While only the server administrator has access to the password file,
we still advise not to use your 'everyday' password.</li>
<li> To change your password or working mail address, please fill
the same form once more and let EELex administrator know of this change
by mailing to eelex\@eki.e&#101;</li>
<li> EKI will never pass on your personal data to any 3rd party and
will use it only in strictly work-related occasions.</li>
</ul>

Lisateave

print "</div>\n";
print $q->end_html;

# -------------------------------------------------------------

sub salvestaankeet {
    my $append = (-e "$pwdir/ankeedid.txt" ? '>' : '');
    open (F, ">$append$pwdir/ankeedid.txt");
    binmode (F, ":utf8");
    print F $guid . "\t" . $q->param('parisnimi') . "\t" . $q->param('meil') . "\t" . $q->param('parool1') . "\n";
    close (F);
    &meiliteade;
    print '<script language="javascript" type="text/javascript"> window.setTimeout("window.location=\'../\';", 6000); </script>', "\n";
}

sub meiliteade {
    open  (M, "|/usr/sbin/sendmail -t") or die ('Viga meili saatmisel');
    print (M "To: eelex.admin\@eki.ee\n");
    print (M "From: eelex.admin\@eki.ee\n");
    print (M "Subject: EELEX: uus kasutaja vajab lisamist\n");
    print (M "Content-type: text/plain\n\n");
    print (M "Kasutaja " . $q->param('parisnimi') . " soovis saada EELexi kasutajaks.\n");
    print (M "Keda see teade puudutab, palun ajage asi jonksu.\n");
    print (M "Link on http://eelextest.eki.ee/shs_access/halda.cgi\n");
    close (M);
}

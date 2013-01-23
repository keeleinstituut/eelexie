
use utf8;

my $linksfile = './extLinks.txt';
my $maxlinks = 12;
my $puudu = 'puudub';
my %urls = ();
binmode (STDOUT, ":utf8");

sub loadlinks {
    return unless -e $linksfile;
    open (F, "<$linksfile");
    binmode (F, ":utf8");
    while (<F>) {
	chomp;
	next unless /^([^ ]*\d+):\t/;
	$urls{$1} = $';
    }
    close (F);
}

sub setlink {
    my ($dictid, $sone) = @_;
    my $vana = $urls{$dictid};
    if ($vana) {
	my ($link, $desc) = split (/\t+/, $urls{"$dictid"});
	$urls{$dictid} = $sone . "\t" . $desc;
    } else {
	$urls{$dictid} = "$sone\t$puudu";
    }
}

sub setdesc {
    my ($dictid, $sone) = @_;
    my $vana = $urls{$dictid};
    if ($vana) {
	my ($link, $desc) = split (/\t+/, $urls{"$dictid"});
	$urls{$dictid} = $link . "\t" . $sone;
    } else {
	$urls{$dictid} = "$puudu\t$sone";
    }
}

sub savelinks {
    open (F, ">$linksfile");
    binmode (F, ":utf8");
    foreach (sort keys %urls) {
	print F "$_:\t", $urls{$_}, "\n";
    }
    close (F);
}

sub printlinks {
    my ($dictid, $sone) = @_;

# nii palju linke kui on ja yks tyhi varuks
#    foreach $k (keys %urls) { $maxlinks = $2 if ($k =~ /^([^0-9]*)(\d+):/) and (($1 eq '') or ($1 eq $dictid)) and ($2 > $maxlinks); }
    $maxlinks = 1;
    while ( $urls{"$maxlinks"} ) { $maxlinks++; }
    while ( $urls{"$dictid$maxlinks"} ) { $maxlinks++; }

    print "<div id=\'yhisedlingid\'>\n";
#    print "<div id=\'yhisedlingidsisu\'>\n";
    print "<h2>\&Uuml;hised lingid</h2>\n";
    for (my $i=1; $i<=$maxlinks; $i++) { printlink ('', $i, $sone); }
#    print "</div>\n";
    print "</div>\n";
    return unless $dictid;

    print "<div id=\'erilisedlingid\'>\n";
#    print "<div id=\'erilisedlingidsisu\'>\n";
    print "<h2>Minu s\&otilde;nastiku lingid</h2>\n";
    for (my $i=1; $i<=$maxlinks; $i++) { printlink ($dictid, $i, $sone); }
#    print "</div>\n";
    print "</div>\n";
}

sub printlink {
    my ($id, $nr, $s) = @_;
    my ($link, $desc) = '';
    ($link, $desc) = split (/\t+/, $urls{"$id$nr"}) if $urls{"$id$nr"};
    print "<div id=\"div$id$nr\" class=\"lingidiv\">\n";
    print "<img width=\"24\" src=\"extLinks_editurl.png\" style=\"cursor:text\" alt=\"Muuda/lisa lingi URL\" title=\"Muuda/lisa lingi URL\" id=\"butteditlink$id$nr\" onclick=\"editlink(\'$id$nr\', \'$link\');\">\n";
    print "<img width=\"24\" src=\"extLinks_editdescription.png\" style=\"cursor:text\" alt=\"Muuda/lisa lingi kirjeldus\" title=\"Muuda/lisa lingi kirjeldus\" id=\"butteditdesc$id$nr\" onclick=\"editdesc(\'$id$nr\', \'$desc\');\">\n";
    print "<span id=\"editlink$id$nr\" class=\"editable\" style=\"display:none\">$link</span>\n";
    print "<span id=\"editdesc$id$nr\" class=\"editable\" style=\"display:none\">$desc</span>\n";
    $id = ($id ? 'L' : 'G');
    $link =~ s/{{sone}}/$s/g;
    print "<span id=\"showdesc$id$nr\" onclick=\"openlink(\'$id$nr\', \'$link\');\" class=\"hypatav\">$desc</span>\n";
    print "</div>\n";
}

1;


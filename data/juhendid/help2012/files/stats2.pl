#!/usr/local/bin/perl
use bytes;

# ------------ SIIN ON VÄÄRTUSED, MIDA VÕIB SOOVI KORRAL MUUTA -----------


$strpikkus = 3;		# nii pikk ja pikem string on struktuuris juba trellid

$stringieraldaja = '|';	# selle paneme väljastatava stringi ümber
			# esialgu on arvestatud ühe märgi, mitte stringiga

$amponlubatud = 1;	# kui 0, siis nuriseb tekstis &-märkide peale

$sordisagedust = 0;	# 0 - sordi tähestiku järgi, 1 - sageduse järgi
$sordipoordes = 0;	# 0 - ette väiksemad sagedused või tähestiku algus

$loendipiir = 10;	# terminaalse märgendi puhul suhe kokku/erinevaid,
			# üle selle on 'pigem loend'
			# mida suurem väärtus, seda vähem loendeid

$entiteedidstringis = 1;	# 0 - ei märgi
				# 1 - kõiki tähistame <&>-ga
				# 2 vm - kirjutame välja kujul <&nimi>

$uuefaililaiend = '.stats';

$lopetaparast = 0;	# 0 on kõik artiklid, muu väärtus teeb statistika
			# esimese n artikli kohta ja lõpetab. kasuta silumisel

$margendiette = 'Märgend: ';

# ------------------ SIIT EDASI ÄRA MUUDA --------------------------------


my $fn = shift;
die ("Kasuta: stats.pl failinimi") unless $fn;
die ("Statistikafaili laiend määramata!") unless $uuefaililaiend;

# korjame eelnevast statistikast (kui on) välja plussiga read (kui on)

my %grepout = ();

if ( -e $fn . $uuefaililaiend ) {
  my $mrg = '';
  open (TXT, "<$fn$uuefaililaiend");
  while (<TXT>) {
    chomp;
    # kohmakas, kuid Ülle stringieraldajad ajavad reg-avaldise muidu hulluks
    if (
      (m/^\+\t(\d+)\t(.)(.+)(.)$/) and
      ($2 eq $stringieraldaja) and
      ($4 eq $stringieraldaja)
    ) {
      $grepout{"$mrg:\t$3"} = $1;
    }
    elsif (/^$margendiette/) {
      $mrg = $';
    }
  }
  close TXT;
}


$/ = "";
$| = 1;

open (TXT, "<$fn");
open (STA, ">$fn$uuefaililaiend");

my %chars = ();
my %entities = ();
my %tags = ();
my ($reanr);
my %sisud = ();
my $artnr++;
my @grepitud = ();
my $art = '';

ART: while (<TXT>) {
  $reanr++;
  chomp;
  s/[\x0a\x0d]/ /sg;
  $artnr++ if $_;
  print "." unless $artnr % 1000;

  next if ($lopetaparast > 0) and ($artnr > $lopetaparast);

# Korjame välja kommentaarid
  s/\Q<!--\E(.*?)\Q-->\E//g;

# XML-laadsed <br/> märgendid tühjaks paariks <br></br>
  s/\<([a-zA-Z_0-9]+)( [^\>]+)?\/\>/\<\1\>\<\/\1\>/g;

# seda kasutame pärast sisu analüüsil
  $art = $_;

# Korjame välja märgendipaarid
  $pikkusenne = length;
  $pikkusparast = 0;
  while ( $pikkusenne > $pikkusparast ) {
    $pikkusenne = length;
    while ( m/\<([a-zA-Z_0-9]+)( [^\>]+)?\>([^\<\>]*)\<\/\1\>/ ) {
      $_ = $` . $3 . $';
      if ($1) { $tags{$1}++; } else
      {
        print STA "Rida $reanr: tühi märgend\n";
      }
    }
    $pikkusparast = length;
  }

# järelejäänud on vead
  while ( m/\<[^\<\>]+\>/ ) {
    $_ = $` . $';
    print STA "Rida $reanr paarsusviga: $art\n\n";
    next ART;
  }

# järelejäänud noolsulud on vead
  while ( m/[\<\>]/ ) {
    $_ = $` . $';
    print STA "Rida $reanr < ja > peavad olema \&lt; ja \&gt;: $art\n\n";
    next ART;
  }

# Loeme üle entiteedid
  while ( m/\&([a-zA-Z0-9_]+)\;/ ) {
    $_ = $` . $';
    $entities{$&}++;
  }

# järelejäänud ampersandid on vead
  if (! $amponlubatud ) {
    while ( m/\&/ ) {
      $_ = $` . $';
      print STA "Rida $reanr & peab olema \&amp;: $art\n\n";
      next ART;
    }
  }

# Loeme üle tähemärgid
  foreach $c ( split(//) ) {
    $chars{$c}++;
  }

  &dtdstuff ($art);
}
close TXT;


# ---------------------------------------------------------

sub sortfunc {
  my $href = shift;
  if ( $sordisagedust ) {
    if ( $sordipoordjarjestuses ) {
      return sort { $$href{$b} <=> $$href{$a} } keys %$href;
    } else {
      return sort { $$href{$a} <=> $$href{$b} } keys %$href;
    }
  } else {
    if ( $sordipoordjarjestuses ) {
      return sort { $b cmp $a } keys %$href;
    } else {
      return sort { $a cmp $b } keys %$href;
    }
  }
}

# rekursiivne, väljast sisse, @sisud list on globaalne

sub dtdstuff {
  my $ss = shift;
  my $margend = '';
  my $tulemus = '';

  return unless $ss =~ m/^\<([a-zA-Z_0-9]+)( [^\>]+)?\>(.*)\<\/\1\>$/;

  $margend = $1;
  $ss = $3;

  while ( $ss ) {
    # kui alguses on teksti
    if ($ss =~ /^([^\<]+)/) {
      $tulemus .= $&;
      $ss = $';
      next;
    }
    # kui alguses on märgend
    if ($ss =~ /^\<([a-zA-Z_0-9]+)( [^\>]+)?\>/) {
      my $teha = $&;
      my $poolelimargend = $1;
      $ss = $';

      # leiame talle lõpetava paarilise
      my $sygavus = 1;
      while ( $sygavus ) {
        if ($ss =~ /^([^\<]+)/) { $teha .= $&; $ss = $'; next; }
        if ($ss =~ /^\<([a-zA-Z_0-9]+)( [^\>]+)?\>/) {
          $sygavus++ if $1 eq $poolelimargend;
          $teha .= $&; $ss = $'; next;
        }
        if ($ss =~ /^\<\/([a-zA-Z_0-9]+)\>/) {
          $sygavus-- if $1 eq $poolelimargend;
          $teha .= $&; $ss = $'; next;
        }
      }

      $tulemus .= &dtdstuff ($teha);
      next;
    }
  }

  $sisud{"$margend:\t$tulemus"}++;

  # kui pidime greppima:
  $tulemus = "$margend:\t" . &karbiteksti ($tulemus);
  push @grepitud, "$tulemus\n$art\n" if $grepout{$tulemus};

  return '<' . $margend . '>';
}

# kärpimiseks nõutav min pikkus on globaalne muutuja
sub karbiteksti {
  my $ss = shift;

  if ( $entiteedidstringis == 0 ) {
    $ss =~ s/\&([a-zA-Z0-9_]+)\;/X/g;
  }
  elsif ( $entiteedidstringis == 1 ) {
    $ss =~ s/\&([a-zA-Z0-9_]+)\;/\<\&\>/g;
  }
  else {
    $ss =~ s/\&([a-zA-Z0-9_]+)\;/\<\&\1\>/g;
  }

  $ss =~ s/^[^\<\>]{$strpikkus,}/#/;
  $ss =~ s/\>([^\<\>]{$strpikkus,})\</\>#\</g;
  $ss =~ s/[^\<\>]{$strpikkus,}$/#/;

#  $ss =~ s/\<\&(.*?)\>/\&\1/g;

  return $ss;
}

sub margendisisu {
  my $ss = shift;
  my $hargnev = 0;

  my %h = ();
  my %sisaldab = ();
  foreach (keys %sisud) {
    next unless /^$ss:\t/;
    $h{$'} += $sisud{$_};
    $hargnev++ if /\</;
  }

  print STA "\n$margendiette$ss\n\t# ";
  print STA $hargnev ? "haru" : "leht";
  print STA ', erinevaid ', scalar(keys %h), ' kokku ', $tags{$ss}, "\n";

  # äkki on loend? kriteerium: kordusi kokku võttes võidab üle poole vms
  if ( ( !$hargnev ) and ( $tags{$ss} / scalar(keys %h) > $loendipiir ) ) {
    print STA "\t# pigem loend:\n";
    foreach ( &sortfunc (\%h) ) {
      print STA "\t$h{$_}\t$stringieraldaja$_$stringieraldaja\n";
    }
  }
  else {
    my %hh = ();
    my ($sss, $sssenne) = '';
    my $enneoli = 0;
    foreach $sss (keys %h) {
      $sssenne = $sss;
      $enneoli = $h{$sss};

      # kaks misiganes märki pole veel tekst, pikemad on
      $sss = &karbiteksti ($sss);

      $hh{$sss} += $enneoli;
      while ($sss =~ /^[^<>]*\<([^\<\>]+)\>/) {
        $sisaldab{$1} = 1;
        $sss = $';
      }
    }
    if ($hargnev) {
      print STA "\t# sisaldab märgendeid: ( ";
      foreach (sort keys %sisaldab) { print STA "$_ "; }
      print STA ")\n";
    }
    foreach ( &sortfunc (\%hh) ) {
      print STA "\t$hh{$_}\t$stringieraldaja$_$stringieraldaja\n";
    }
  }
}

# ---------------------------------------------------------

my $eraldaja = "\n# ------------------------------------------------------\n";

if ( scalar (keys %grepout) ) {
  print STA "Palusid leida artiklid, milles esineks struktuure:\n\n";
  foreach (sort keys %grepout) {
    print STA "$grepout{$_}\t$_\n";
  }
  print STA "\n\nSiin on need, mis leidsin:\n\n";
  foreach (@grepitud) {
    print STA "$_\n";
  }
}

print STA $eraldaja;

print STA "\nKasutatud märgendid\n\n";
foreach ( &sortfunc (\%tags) ) {
  print STA "$_\t$tags{$_}\n";
}

print STA $eraldaja;

print STA "\nMärgendite sisud. # on #PCDATA e lihtsalt tekstiosa, mis on pikem kui ... märki\n\n";
foreach my $k (sort keys %tags) {
  &margendisisu ($k);
}

print STA $eraldaja;

print STA "\nKasutatud entiteedid\n\n";
foreach ( &sortfunc (\%entities) ) {
  print STA "$_\t$entities{$_}\n";
}

print STA $eraldaja;

print STA "\nKasutatud märgid koodjärjestuses\n\n";
foreach (sort { ord($a) <=> ord($b) } keys %chars) {
  print STA ord($_), "\t$_\t$chars{$_}\n" if $chars{$_};
}

print STA "\nKasutatud märgid sagedusjärjestuses\n\n";
foreach (sort { $chars{$a} <=> $chars{$b} } keys %chars) {
  print STA ord($_), "\t$_\t$chars{$_}\n" if $chars{$_};
}

close STA;

#!/usr/local/bin/perl
use bytes;

# ------------ SIIN ON V��RTUSED, MIDA V�IB SOOVI KORRAL MUUTA -----------


$strpikkus = 3;		# nii pikk ja pikem string on struktuuris juba trellid

$stringieraldaja = '|';	# selle paneme v�ljastatava stringi �mber
			# esialgu on arvestatud �he m�rgi, mitte stringiga

$amponlubatud = 1;	# kui 0, siis nuriseb tekstis &-m�rkide peale

$sordisagedust = 0;	# 0 - sordi t�hestiku j�rgi, 1 - sageduse j�rgi
$sordipoordes = 0;	# 0 - ette v�iksemad sagedused v�i t�hestiku algus

$loendipiir = 10;	# terminaalse m�rgendi puhul suhe kokku/erinevaid,
			# �le selle on 'pigem loend'
			# mida suurem v��rtus, seda v�hem loendeid

$entiteedidstringis = 1;	# 0 - ei m�rgi
				# 1 - k�iki t�histame <&>-ga
				# 2 vm - kirjutame v�lja kujul <&nimi>

$uuefaililaiend = '.stats';

$lopetaparast = 0;	# 0 on k�ik artiklid, muu v��rtus teeb statistika
			# esimese n artikli kohta ja l�petab. kasuta silumisel

$margendiette = 'M�rgend: ';

# ------------------ SIIT EDASI �RA MUUDA --------------------------------


my $fn = shift;
die ("Kasuta: stats.pl failinimi") unless $fn;
die ("Statistikafaili laiend m��ramata!") unless $uuefaililaiend;

# korjame eelnevast statistikast (kui on) v�lja plussiga read (kui on)

my %grepout = ();

if ( -e $fn . $uuefaililaiend ) {
  my $mrg = '';
  open (TXT, "<$fn$uuefaililaiend");
  while (<TXT>) {
    chomp;
    # kohmakas, kuid �lle stringieraldajad ajavad reg-avaldise muidu hulluks
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

# Korjame v�lja kommentaarid
  s/\Q<!--\E(.*?)\Q-->\E//g;

# XML-laadsed <br/> m�rgendid t�hjaks paariks <br></br>
  s/\<([a-zA-Z_0-9]+)( [^\>]+)?\/\>/\<\1\>\<\/\1\>/g;

# seda kasutame p�rast sisu anal��sil
  $art = $_;

# Korjame v�lja m�rgendipaarid
  $pikkusenne = length;
  $pikkusparast = 0;
  while ( $pikkusenne > $pikkusparast ) {
    $pikkusenne = length;
    while ( m/\<([a-zA-Z_0-9]+)( [^\>]+)?\>([^\<\>]*)\<\/\1\>/ ) {
      $_ = $` . $3 . $';
      if ($1) { $tags{$1}++; } else
      {
        print STA "Rida $reanr: t�hi m�rgend\n";
      }
    }
    $pikkusparast = length;
  }

# j�relej��nud on vead
  while ( m/\<[^\<\>]+\>/ ) {
    $_ = $` . $';
    print STA "Rida $reanr paarsusviga: $art\n\n";
    next ART;
  }

# j�relej��nud noolsulud on vead
  while ( m/[\<\>]/ ) {
    $_ = $` . $';
    print STA "Rida $reanr < ja > peavad olema \&lt; ja \&gt;: $art\n\n";
    next ART;
  }

# Loeme �le entiteedid
  while ( m/\&([a-zA-Z0-9_]+)\;/ ) {
    $_ = $` . $';
    $entities{$&}++;
  }

# j�relej��nud ampersandid on vead
  if (! $amponlubatud ) {
    while ( m/\&/ ) {
      $_ = $` . $';
      print STA "Rida $reanr & peab olema \&amp;: $art\n\n";
      next ART;
    }
  }

# Loeme �le t�hem�rgid
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

# rekursiivne, v�ljast sisse, @sisud list on globaalne

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
    # kui alguses on m�rgend
    if ($ss =~ /^\<([a-zA-Z_0-9]+)( [^\>]+)?\>/) {
      my $teha = $&;
      my $poolelimargend = $1;
      $ss = $';

      # leiame talle l�petava paarilise
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

# k�rpimiseks n�utav min pikkus on globaalne muutuja
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

  # �kki on loend? kriteerium: kordusi kokku v�ttes v�idab �le poole vms
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

      # kaks misiganes m�rki pole veel tekst, pikemad on
      $sss = &karbiteksti ($sss);

      $hh{$sss} += $enneoli;
      while ($sss =~ /^[^<>]*\<([^\<\>]+)\>/) {
        $sisaldab{$1} = 1;
        $sss = $';
      }
    }
    if ($hargnev) {
      print STA "\t# sisaldab m�rgendeid: ( ";
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

print STA "\nKasutatud m�rgendid\n\n";
foreach ( &sortfunc (\%tags) ) {
  print STA "$_\t$tags{$_}\n";
}

print STA $eraldaja;

print STA "\nM�rgendite sisud. # on #PCDATA e lihtsalt tekstiosa, mis on pikem kui ... m�rki\n\n";
foreach my $k (sort keys %tags) {
  &margendisisu ($k);
}

print STA $eraldaja;

print STA "\nKasutatud entiteedid\n\n";
foreach ( &sortfunc (\%entities) ) {
  print STA "$_\t$entities{$_}\n";
}

print STA $eraldaja;

print STA "\nKasutatud m�rgid koodj�rjestuses\n\n";
foreach (sort { ord($a) <=> ord($b) } keys %chars) {
  print STA ord($_), "\t$_\t$chars{$_}\n" if $chars{$_};
}

print STA "\nKasutatud m�rgid sagedusj�rjestuses\n\n";
foreach (sort { $chars{$a} <=> $chars{$b} } keys %chars) {
  print STA ord($_), "\t$_\t$chars{$_}\n" if $chars{$_};
}

close STA;

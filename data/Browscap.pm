package HTTP::Browscap;

  use strict;
  use Carp;
  use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);                     
  require Exporter;

  @ISA=qw(Exporter);
  @EXPORT=qw();
  @EXPORT_OK=qw();
  $VERSION="1.1";

  %HTTP::Browscap::variables=(
    'browser'            => 'Browser name',
    'version'            => 'Browser version',
    'minorver'           => 'Browser minor version',
    'majorver'           => 'Browser major version',
    'platform'           => 'Platform',
    'platform_version'           => 'Platform_Version',
    'ismobiledevice'           => 'isMobileDevice',
    'authenticodeupdate' => '_authenticodeupdate',
    'css'                => 'CSS stylesheets support',
    'frames'             => 'Frames support',
    'iframes'            => 'Iframes support',
    'tables'             => 'Tables support',
    'cookies'            => 'Cookies support',
    'backgroundsounds'   => 'Sounds on background',
    'vbscript'           => 'Visual Basic Script support',
    'javascript'         => 'JavaScript support',
    'javaapplets'        => 'Java applets support',
    'javaappletsframes'  => 'Java applet frames support',
    'activexcontrols'    => 'ActiveX Controls',
    'width'              => 'Width',
    'height'             => 'Height',
    'ak'                 => '_ak',
    'sk'                 => '_sk',
    'cdf'                => '_cdf',
    'aol'                => 'AOL',
    'beta'               => 'Beta version',
    'win16'              => '_win16',
    'win32'              => '_win32',
    'win64'              => '_win64',
    'crawler'            => 'Crawler',
    'stripper'           => 'Website stripper',
    'wap'                => 'Wap support',
    'netclr'             => 'DotNet CLR',
    'parent'             => 'Parent browser',
  );

  sub new {
    my ($type, $file)=(shift, shift || '');
    $file || do { Carp::croak("Browscap filename must be set as a parameter"); return(undef); };

    my $self={};
    @{$self->{'errors'}}=();
    %{$self->{'agents'}}=();
    bless($self, $type);

    $self->parse($file) || return(undef);

    return($self);
  }

  sub parse {
    my($self, $file)=(shift, shift || '');
    $file || do { Carp::croak("Browscap file is not defined"); return(0); };
    open(BROWSCAP, $file) || do { Carp::croak("Cannot open browscap file '$file': $!"); return(0); };

    $self->free();

    my $agent;
    while(<BROWSCAP>) {
      /^;/ && next;
      s/[\r\n]+$//;
      length() || next;

      /^\[(.+)\]$/ && do { 
        $agent=$1;
        $self->{'agents'}{$agent}{'regexp'}=$agent;
        $self->{'agents'}{$agent}{'regexp'}=~s/\+/ /g;
        $self->{'agents'}{$agent}{'regexp'}=~s/\?/./g;
        $self->{'agents'}{$agent}{'regexp'}=~s/\*/.*/g;
        $self->{'agents'}{$agent}{'regexp'}=~s/([\/\(\)])/\\$1/g;
        next;
      };

      $agent || next;
      /^([^=]+)=(.+)$/ || do { push(@{$self->{'errors'}}, "Line $.: bad syntax"); next; };
      my($key, $value)=(lc($1), $2);
      $key=~s/ //g;
      defined($HTTP::Browscap::variables{$key}) || do { push(@{$self->{'errors'}}, "Line $.: unknown key '$key'"); next; };
      $self->{'agents'}{$agent}{$key}=$value;
    }

    close(BROWSCAP);
    keys(%{$self->{'agents'}}) || do { Carp::croak("Browscap file '$file' contains no valid data"); return(0); };

    return(1);
  }

  sub identify {
    my ($self, $id)=(shift, shift || '');
    $id || do { Carp::croak("Agent identificator was not set"); return(undef); };

    my $matching_agent='';
    foreach my $agent (keys %{$self->{'agents'}}) {
      my $regexp=$self->{'agents'}{$agent}{'regexp'};
      $id=~/^$regexp/ || next;
      (length($agent)>=length($matching_agent)) && ($matching_agent=$agent);
    }
    $matching_agent || do { Carp::croak("No agent in browscap file matches this identification"); return(undef); };

    defined($self->{'agents'}{$matching_agent}{'parent'}) && $self->fill_variables($matching_agent);
    return(\%{$self->{'agents'}{$matching_agent}});
  }

  sub identify_variable {
    my ($self, $id, $variable)=(shift, shift || '', shift || '');
    $id || do { Carp::croak("Agent identificator was not set"); return(undef); };
    $variable || do { Carp::croak("Variable name was not set"); return(undef); };
    defined($HTTP::Browscap::variables{$variable}) || do { Carp::croak("Variable name '$variable' is invalid"); return(undef); }; 

    my $matching_agent='';
    foreach my $agent (keys %{$self->{'agents'}}) {
      my $regexp=$self->{'agents'}{$agent}{'regexp'};
      $id=~/^$regexp/ || next;
      (length($agent)>=length($matching_agent)) && ($matching_agent=$agent);
    }
    $matching_agent || do { Carp::croak("No agent in browscap file matches this identification"); return(undef); };
    
    defined($self->{'agents'}{$matching_agent}{'parent'}) && $self->fill_variables($matching_agent);
    defined($self->{'agents'}{$matching_agent}{$variable}) || Carp::croak("Variable '$variable' is not set in browscap file");
    return($self->{'agents'}{$matching_agent}{$variable});
  }

  sub fill_variables {
    my($self, $agent)=(shift, shift || '');
    (my $parent=$self->{'agents'}{$agent}{'parent'}) || return(0);
    defined($self->{'agents'}{$parent}) || return(0);
    defined($self->{'agents'}{$parent}{'parent'}) && $self->fill_variables($parent);

    foreach my $variable (keys %HTTP::Browscap::variables) {
      ($variable eq 'parent') && next;
      defined($self->{'agents'}{$agent}{$variable}) && next;
      defined($self->{'agents'}{$parent}{$variable}) || next;
      $self->{'agents'}{$agent}{$variable}=$self->{'agents'}{$parent}{$variable};
    }
  }

  sub free {
    my $self=shift;
    @{$self->{'errors'}}=();
    %{$self->{'agents'}}=();
  }

1;

__END__

=head1 NAME

HTTP::Browscap - Get web browser information by specific browscap.ini file

=head1 SYNOPSYS

  use HTTP::Browscap;

  my $agent='Mozilla/4.8 [en] (X11; U; Linux 2.4.19 i686; Nav)';

  my $browscap = new HTTP::Browscap('/path/to/browscap.ini');
  $browscap || die("Browscap did not initialize: $!");
  if(length($browscap->{'errors'})) {
    print
      "Browscap file errors:\n".
      join("\n  ", @{$browscap->{'errors'}})."\n";
  }

  my $browser = $browscap->identify($agent);
  $browser || die("Error getting browser info: $!");
  print
    "Browser ".$browser->{'browser'}.
    " version ".$browser->{'version'}.
    " on platform ".$browser->{'platform'}."\n";

  $browscap->parse('/path/to/another/browscap.ini') ||
    die("Browscap did not initialize: $!");

  my $platform=$browscap->identify_variable($agent, 'platform');
  $platform || die("Cannot get browser platform: $!");
  print "Browser platform: $platform\n";

  $browscap->free();

=head1 DESCRIPTION

The HTTP::Browscap object tries to get as much information about
web browser comparing its User-Agent identification to a special
database in browscap.ini file. If calling a Perl script via CGI,
the browser identification string can be found in environmental
variable $ENV{'HTTP_USER_AGENT'}.

=head1 PACKAGE METHODS

=item new HTTP::Browscap ($browscap_file)

The constructor parses the given file and creates its own browser
tree. Any errors occuring while parsing the file are stored in
special array variable.
In case of errors (i.e. nonexistent file) returns undef and
error message can be found in "$!" variable.

=item parse ($browscap_file)

This method cleans stored browser tree, parses given file and
creates new browser tree. Variable holding parsing errors is
cleaned too and created again, if any errors occure.
In case of errors (i.e. nonexistent file) returns undef and
error message can be found in "$!" variable.

=item identify ($user_agent_identifictaion)

Returns a hash reference with known information about browser.
Returns undef in case of errors (i.e. browser not found in
database) and error message can be found in "$!" variable.

=item identify_variable ($user_agent_identification, $variable)

Returns string with the corresponding value of variable to
specified browser. Returns undef in case of errors (i.e. browser
not found in database or unknown variable or not set value) and
error message can be found in "$!" variable.

=item free ()

Cleans browser tree and error messages. Use this to free memory,
browscap files usually have more than 100 kB.

=head1 PACKAGE VARIABLES

=item @errors

An array containing errors while parsing the browscap file.

=item %HTTP::Browscap::variables

Anonymous hash containing variables which can be set to every
browser (plus special 'parent' variable). Variable names are
keys of this hash, variable description are values of this hash.

=head1 BROWSER SPECIFIC VARIABLES

Per browser can be set these variables: browser, version, minorver,
majorver, platform, authenticodeupdate, css, frames, iframes,
tables, cookies, backgroundsounds, vbscripts, javascript,
javaapplets, javaappletsframes, activexcontrols, height, width,
ak, sk, cdf, aol, beta, win16, netclr and special variable parent.

=head1 GETTING BROWSCAP.INI

You can find various browscap databases on the internet free for
download, for example on 
B<http://www.garykeith.com/browsers/downloads.asp> or
B<http://www.cyscape.com/browscap/>

You can of course try to find your own favourite on
B<http://www.google.com/> ;-)

=head1 SEE ALSO

Another Perl module HTTP::BrowserDetect.

=head1 HOMEPAGE

B<http://kyberdig.cz/projects/browscap/>

=head1 AUTHOR

C. McCohy <mccohy@kyberdigi.cz>
Feel free to report bugs, suggestions or comments.

=head1 COPYRIGHT

Copyright 2003 C. McCohy. This program is free soft, distribute
it and/or modify it under the terms as Perl itself.

=cut


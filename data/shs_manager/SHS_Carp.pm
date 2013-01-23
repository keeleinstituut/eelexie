package SHS_Carp;

use strict;
use warnings;

# Carp 'i versioon
our $VERSION = '1.20';

our $MaxEvalLen = 0;
our $Verbose    = 0;
our $SHS_CarpLevel  = 0;
our $MaxArgLen  = 64;    # How much of each argument to print. 0 = all.
our $MaxArgNums = 8;     # How many arguments to print. 0 = all.

our $LastMess = '';
our $LastErrLvl = '';
use Data::Dumper;

our @dumpdata;

require Exporter;
our @ISA       = ('Exporter');
our @EXPORT    = qw(carp_dl carp_ds carp_wl carp_ws carp_hdl carp_hds carp_hwl carp_hws);
our @EXPORT_OK = qw(carp_dl carp_ds carp_wl carp_ws carp_hdl carp_hds carp_hwl carp_hws);
our @EXPORT_FAIL = qw(verbose);    # hook to enable verbose mode

# The members of %Internal are packages that are internal to perl.
# SHS_Carp will not report errors from within these packages if it
# can.  The members of %SHS_CarpInternal are internal to Perl's warning
# system.  SHS_Carp will not report errors from within these packages
# either, and will not report calls *to* these packages for carp and
# croak.  They replace $SHS_CarpLevel, which is deprecated.    The
# $Max(EvalLen|(Arg(Len|Nums)) variables are used to specify how the eval
# text and function arguments should be formatted when printed.

our %SHS_CarpInternal;
our %Internal;

# disable these by default, so they can live w/o require SHS_Carp
$SHS_CarpInternal{Carp}++;

$SHS_CarpInternal{SHS_Carp}++;
$SHS_CarpInternal{warnings}++;
$Internal{Exporter}++;
$Internal{'Exporter::Heavy'}++;

# if the caller specifies verbose usage ("perl -MSHS_Carp=verbose script.pl")
# then the following method will be called by the Exporter which knows
# to do this thanks to @EXPORT_FAIL, above.  $_[1] will contain the word
# 'verbose'.

sub export_fail { shift; $Verbose = shift if $_[0] eq 'verbose'; @_ }

sub _cgc {
    no strict 'refs';
    return \&{"CORE::GLOBAL::caller"} if defined &{"CORE::GLOBAL::caller"};
    return;
}

sub longmess {
    # Icky backwards compatibility wrapper. :-(
    #
    # The story is that the original implementation hard-coded the
    # number of call levels to go back, so calls to longmess were off
    # by one.  Other code began calling longmess and expecting this
    # behaviour, so the replacement has to emulate that behaviour.
    my $cgc = _cgc();
    my $call_pack = $cgc ? $cgc->() : caller();
    if ( $Internal{$call_pack} or $SHS_CarpInternal{$call_pack} ) {
        return longmess_heavy(@_);
    }
    else {
        local $SHS_CarpLevel = $SHS_CarpLevel + 1;
        return longmess_heavy(@_);
    }
}

our @CARP_NOT;

sub shortmess {
    my $cgc = _cgc();

    # Icky backwards compatibility wrapper. :-(
    local @CARP_NOT = $cgc ? $cgc->() : caller();
    shortmess_heavy(@_);
}

sub elmess {
    my $time = time();
    log_event(longmess( @_),$time);
    return  '*shs_carp_id:'.$time.'* '.$LastMess;
}

sub esmess {
    my $time = time();
    log_event(shortmess( @_),$time);
     return  '*shs_carp_id:'.$time.'* '.$LastMess;
}
# ret_backtrace subis on kuidas nimekirjaga käituda, vist pole vaja siis

#signaalide jaoks
#signaalina lisatakse rida ja fail eraldi lõppu
#signaalist tulles on string juba valmis

#carpiga tülis
sub ehlmess {
$SIG{__DIE__}  = 'DEFAULT';
@dumpdata = @_;
my $tmp = shift @_;
    my $time = time();
    #  $LastMess = "$err at $i{file} line $i{line}' thread $tid'\n";
     # "^(.*) at .* line .*( thread .*)\n$";
    $tmp=~m/^(.*) at \//s;
    $tmp=($1||$tmp);

    log_event(longmess($tmp),$time);
  #  printerror($time,'Ettenägamatu viga');
    return  '[shs_carp_id:'.$time.'] '.$LastErrLvl.$LastMess;
}

sub ehsmess {
    my @tmp = @_;
    @dumpdata = @_;
    my $time = time();
    $tmp[-1]=~m/^(.*) at \//;
    $tmp[-1]=($1||$tmp[-1]);

    log_event(shortmess(@tmp ),$time);
    return  '[shs_carp_id:'.$time.'] '.$LastErrLvl.$LastMess;
}

sub carp_ds   { die esmess @_ }
sub carp_ws   { warn esmess @_ }
sub carp_dl   { die elmess @_ }
sub carp_wl   { warn elmess @_ }

sub carp_hds   { die ehsmess @_ }
sub carp_hws   { warn ehsmess @_ }

sub carp_hdl   {$LastErrLvl='die: '; die ehlmess @_ }
sub carp_hwl   {$LastErrLvl='warn: ';  warn ehlmess @_ }

sub caller_info {
    my $i = shift(@_) + 1;
    my %call_info;
    my $cgc = _cgc();
    {
        package DB;
        @DB::args = \$i;    # A sentinel, which no-one else has the address of
        @call_info{
            qw(pack file line sub has_args wantarray evaltext is_require) }
            = $cgc ? $cgc->($i) : caller($i);
    }

    unless ( defined $call_info{pack} ) {
        return ();
    }

    my $sub_name = SHS_Carp::get_subname( \%call_info );
    if ( $call_info{has_args} ) {
        my @args;
        if (   @DB::args == 1
            && ref $DB::args[0] eq ref \$i
            && $DB::args[0] == \$i ) {
            @DB::args = ();    # Don't let anyone see the address of $i
            local $@;
            my $where = eval {
                my $func    = $cgc or return '';
                my $gv      = B::svref_2object($func)->GV;
                my $package = $gv->STASH->NAME;
                my $subname = $gv->NAME;
                return unless defined $package && defined $subname;

                # returning CORE::GLOBAL::caller isn't useful for tracing the cause:
                return if $package eq 'CORE::GLOBAL' && $subname eq 'caller';
                " in &${package}::$subname";
            } // '';
            @args
                = "** Incomplete caller override detected$where; \@DB::args were not set **";
        }
        else {
            @args = map { SHS_Carp::format_arg($_) } @DB::args;
        }
        if ( $MaxArgNums and @args > $MaxArgNums )
        {    # More than we want to show?
            $#args = $MaxArgNums;
            push @args, '...';
        }

        # Push the args onto the subroutine
        $sub_name .= '(' . join( ', ', @args ) . ')';
    }
    $call_info{sub_name} = $sub_name;
    return wantarray() ? %call_info : \%call_info;
}

# Transform an argument to a function into a string.
sub format_arg {
    my $arg = shift;
    if ( ref($arg) ) {
        $arg = defined($overload::VERSION) ? overload::StrVal($arg) : "$arg";
    }
    if ( defined($arg) ) {
        $arg =~ s/'/\\'/g;
        $arg = str_len_trim( $arg, $MaxArgLen );

        # Quote it?
        $arg = "'$arg'" unless $arg =~ /^-?[0-9.]+\z/;
    }                                    # 0-9, not \d, as \d will try to
    else {                               # load Unicode tables
        $arg = 'undef';
    }

    # The following handling of "control chars" is direct from
    # the original code - it is broken on Unicode though.
    # Suggestions?
    utf8::is_utf8($arg)
        or $arg =~ s/([[:cntrl:]]|[[:^ascii:]])/sprintf("\\x{%x}",ord($1))/eg;
    return $arg;
}

# Takes an inheritance cache and a package and returns
# an anon hash of known inheritances and anon array of
# inheritances which consequences have not been figured
# for.
sub get_status {
    my $cache = shift;
    my $pkg   = shift;
    $cache->{$pkg} ||= [ { $pkg => $pkg }, [ trusts_directly($pkg) ] ];
    return @{ $cache->{$pkg} };
}

# Takes the info from caller() and figures out the name of
# the sub/require/eval
sub get_subname {
    my $info = shift;
    if ( defined( $info->{evaltext} ) ) {
        my $eval = $info->{evaltext};
        if ( $info->{is_require} ) {
            return "require $eval";
        }
        else {
            $eval =~ s/([\\\'])/\\$1/g;
            return "eval '" . str_len_trim( $eval, $MaxEvalLen ) . "'";
        }
    }

    return ( $info->{sub} eq '(eval)' ) ? 'eval {...}' : $info->{sub};
}

# Figures out what call (from the point of view of the caller)
# the long error backtrace should start at.
sub long_error_loc {
    my $i;
    my $lvl = $SHS_CarpLevel;
    {
        ++$i;
        my $cgc = _cgc();
        my $pkg = $cgc ? $cgc->($i) : caller($i);
        unless ( defined($pkg) ) {

            # This *shouldn't* happen.
            if (%Internal) {
                local %Internal;
                $i = long_error_loc();
                last;
            }
            else {

                # OK, now I am irritated.
                return 2;
            }
        }
        redo if $SHS_CarpInternal{$pkg};
        redo unless 0 > --$lvl;
        redo if $Internal{$pkg};
    }
    return $i - 1;
}

sub longmess_heavy {
    return @_ if ref( $_[0] );    # don't break references as exceptions
    my $i = long_error_loc();
    return ret_backtrace( $i, @_ );
}

# Returns a full stack backtrace starting from where it is
# told.
sub ret_backtrace {
    my ( $i, @error ) = @_;
    my $mess;
    my $err = join '', @error;
    $i++;

    my $tid_msg = '';
    if ( defined &threads::tid ) {
        my $tid = threads->tid;
        $tid_msg = " thread $tid" if $tid;
    }

    my %i = caller_info($i);
    $LastMess = "$err at $i{file} line $i{line}$tid_msg\n";
    
    $mess = $LastMess;
    while ( my %i = caller_info( ++$i ) ) {
        $mess .= "\t$i{sub_name} called at $i{file} line $i{line}$tid_msg\n";
    }

    return $mess;
}

sub ret_summary {
    my ( $i, @error ) = @_;
    my $err = join '', @error;
    $i++;

    my $tid_msg = '';
    if ( defined &threads::tid ) {
        my $tid = threads->tid;
        $tid_msg = " thread $tid" if $tid;
    }

    my %i = caller_info($i);
    $LastMess = "$err at $i{file} line $i{line}$tid_msg\n";
    return $LastMess;
}

sub short_error_loc {
    # You have to create your (hash)ref out here, rather than defaulting it
    # inside trusts *on a lexical*, as you want it to persist across calls.
    # (You can default it on $_[2], but that gets messy)
    my $cache = {};
    my $i     = 1;
    my $lvl   = $SHS_CarpLevel;
    {
        my $cgc = _cgc();
        my $called = $cgc ? $cgc->($i) : caller($i);
        $i++;
        my $caller = $cgc ? $cgc->($i) : caller($i);

        return 0 unless defined($caller);    # What happened?
        redo if $Internal{$caller};
        redo if $SHS_CarpInternal{$caller};
        redo if $SHS_CarpInternal{$called};
        redo if trusts( $called, $caller, $cache );
        redo if trusts( $caller, $called, $cache );
        redo unless 0 > --$lvl;
    }
    return $i - 1;
}

sub shortmess_heavy {
    return longmess_heavy(@_) if $Verbose;
    return @_ if ref( $_[0] );    # don't break references as exceptions
    my $i = short_error_loc();
    if ($i) {
        ret_summary( $i, @_ );
    }
    else {
        longmess_heavy(@_);
    }
}

# If a string is too long, trims it with ...
sub str_len_trim {
    my $str = shift;
    my $max = shift || 0;
    if ( 2 < $max and $max < length($str) ) {
        substr( $str, $max - 3 ) = '...';
    }
    return $str;
}

# Takes two packages and an optional cache.  Says whether the
# first inherits from the second.
#
# Recursive versions of this have to work to avoid certain
# possible endless loops, and when following long chains of
# inheritance are less efficient.
sub trusts {
    my $child  = shift;
    my $parent = shift;
    my $cache  = shift;
    my ( $known, $partial ) = get_status( $cache, $child );

    # Figure out consequences until we have an answer
    while ( @$partial and not exists $known->{$parent} ) {
        my $anc = shift @$partial;
        next if exists $known->{$anc};
        $known->{$anc}++;
        my ( $anc_knows, $anc_partial ) = get_status( $cache, $anc );
        my @found = keys %$anc_knows;
        @$known{@found} = ();
        push @$partial, @$anc_partial;
    }
    return exists $known->{$parent};
}

# Takes a package and gives a list of those trusted directly
sub trusts_directly {
    my $class = shift;
    no strict 'refs';
    no warnings 'once';
    return @{"$class\::CARP_NOT"}
        ? @{"$class\::CARP_NOT"}
        : @{"$class\::ISA"};
}

# korrastab logi
sub log_event {
    my $mis = shift;
    my $time = shift;
    
    write_log("***".$time."***\n".get_info().$mis.dump_info());
}

# kirjutab faili
sub write_log {
    my $mis = shift;
    
    open OUTPUT, ">>/var/www/EELex/data/sandbox/shs_carp.log";

    print OUTPUT $mis;

    close OUTPUT;


    
}

#  saamiseks
sub dump_info {

    my $info = "[dump]\n";
    
     $info.= $#dumpdata." els \n";
     
    $info.= Dumper(@dumpdata);
    $info.= '[/dump]';

    return $info."\n";
   

}

# Lisainfo saamiseks
sub get_info {
    # my $info = '[udata:dump][ip:192.168.8.40][user:EKudritski][time:2011-08-11T16:56:21]';
    my $info = '[udata:dump]';
      #  my $ua = $ENV{HTTP_USER_AGENT};
      #  my $ra = $ENV{REMOTE_ADDR};
      #  my $usr = "$ENV{REMOTE_USER}";
    
    $info .='[user:'.$ENV{REMOTE_USER} .']' if($ENV{REMOTE_USER} ne '');
    $info .='[ip:'.$ENV{REMOTE_ADDR} .']' if($ENV{REMOTE_ADDR} ne '');

    if($info eq '[udata:dump]'){
        return '';
    }else{
        return $info."\n";
    }

}

sub printerror {
    my $errid = shift @_;
    my $errmess = shift @_;
    
    print "Content-type: text/html; charset=utf-8\n";
    print "Status: 500 Internal server error\n\n";
    print "<h1>Viga: $errid</h1>";
    print "<hlr/>$errmess";

}


1;

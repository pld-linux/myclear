#!/usr/bin/perl

use strict;
use POSIX;
use Term::Cap;

my($p_name)   = $0 =~ m|/?([^/]+)$|;
my $p_version = "20030322.0";
my $p_usage   = "Usage: $p_name [--help] [--version]";
my $p_cp      = <<EOM;
Copyright (c) 2003
      John Jetmore <jj33\@pobox.com>.  All rights reserved.
This code freely redistributable provided my name and this copyright notice
are not removed.  Send email to the contact address if you use this program.
EOM
ext_usage();

$| = 1;
my $termios = POSIX::Termios->new();
   $termios->getattr;
my $tcap    = Term::Cap->Tgetent ({TERM=>undef,OSPEED=>$termios->getospeed()});
   $tcap->Trequire(qw(cl cm cd));
my $mr      = get_dim($tcap);
    
$tcap->Tputs('cl', 1, *STDOUT);             # clear screen
$tcap->Tgoto('cm', 0, $mr, *STDOUT);        # place cursor at (0,$maxrow)
$tcap->Tputs('cd', 1, *STDOUT);             # clear to end

exit;

sub get_dim {
  my $t = shift; # termcap ent - fallback method
  my $r = 24;

  if (try_load("Term::ReadKey")) {
    $r = (Term::ReadKey::GetTerminalSize())[1];
  } else {
    $r = $tcap->{_li};
  }
  return($r - 1);
}

sub try_load {
  my $mod = shift;

  eval("use $mod");

  if ($@) {
    return(0);
  } else {
    return(1);
  }
}

sub ext_usage {
  if ($ARGV[0] =~ /^--help$/i) {
    require Config;
    $ENV{PATH} .= ":" unless $ENV{PATH} eq "";
    $ENV{PATH} = "$ENV{PATH}$Config::Config{'installscript'}";
    exec("perldoc", "-F", "-U", $0) || exit 1;
    # make parser happy
    %Config::Config = ();
  } elsif ($ARGV[0] =~ /^--version$/i) {
    print "$p_name version $p_version\n\n$p_cp\n";
  } else {
    return;
  }

  exit(0);
}

__END__

=head1 NAME

myclear - Clear to bottom of terminal

=head1 USAGE

myclear [--help|--version]

=head1 OPTIONS

=over 4

=item --help

This screen.

=item --version

version info.

=back

=head1 COMMENTS

Isn't it so much nicer having the prompt at the bottom?

=head1 CONTACT

=item proj-myclear@jetmore.net

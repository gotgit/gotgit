package Term::TtyRec::Player;

use strict;
use vars qw($VERSION);
$VERSION = '0.03';

use Time::HiRes qw(sleep);
use Term::TtyRec;

sub new {
    my($proto, $io, $attr) = @_;
    my $class = ref $proto || $proto;
    my %attr = ( speed => 1, nowait => undef, %{$attr || {}} ); # default

    unless ($io->can('read')) {
	require Carp;
	Carp::croak('Usage: Term::TtyRec::Player->new($io)');
    }

    bless { ttyrec => Term::TtyRec->new($io), %attr }, $class;
}

sub play {
    my $self = shift;
    local $| = 1;

    my $prev;
    while (my($sec, $text) = $self->ttyrec->read_next) {
	my $wait = ($sec - $prev) / $self->speed if defined $prev;
	unless ($self->nowait or ! $prev) {
	    sleep $wait;
	}
	print $text;
	$prev = $sec;
    }
}

sub skip_all {
    my $self = shift;
    1 while $self->ttyrec->read_next;
}

sub peek {
    my $self = shift;
    $self->skip_all;

    while (1) {
	$self->play;
	sleep 0.25;
    }
}

### accessor
for my $attr (qw(ttyrec speed nowait)) {
    no strict 'refs';
    *{__PACKAGE__. "::$attr"} = sub {
	my $self = shift;
	$self->{$attr} = shift if @_;
	$self->{$attr};
    };
}


1;
__END__

=head1 NAME

Term::TtyRec::Player - playbacks ttyrec data

=head1 SYNOPSIS

  use Term::TtyRec::Player;
  use FileHandle;

  # $handle is any IO::* object
  my $handle = FileHandle->new('file.tty');
  my $player = Term::TtyRec::Player->new($handle);

  # options can be set as hashref
  my $player = Term::TtyRec::Player->new($handle, {
      speed => 1, nowait => undef,
  });

=head1 DESCRIPTION

Term::TtyRec::Player playbacks ttyrec recorded data. See L<pttyplay>
and L<Term::TtyRec> for details about ttyrec.

=head1 METHODS

=over 4

=item new

  $player = Term::TtyRec::Player->new($handle, \%attr);

constructs new Term::TtyRec::Player instance.

=item play

  $player->play();

Plays recorded data on your terminal.

=item peek

  $player->peek();

Plays live-recoded data to your terminal. This method implements
ttyplay -p option.

=back

=head1 AUTHOR

Tatsuhiko Miyagawa <miyagawa@bulknews.net>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Term::TtyRec>, L<pttyplay>, http://namazu.org/~satoru/ttyrec/

=cut

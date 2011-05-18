package Term::TtyRec;

use strict;
use vars qw($VERSION);
$VERSION = '0.03';

use IO::Handle;

sub new {
    my($proto, $io) = @_;
    my $class = ref $proto || $proto;
    unless ($io->can('read')) {
	require Carp;
	Carp::croak 'Usage: Term::TtyRec->new($io)';
    }
    bless { handle => $io }, $class;
}

sub read_next {
    my $self = shift;
    my($sec, $text);
    eval {
	($sec, my $length) = $self->_read_header;
	$self->{handle}->read($text, $length);
    };
    if ($@) {
	$self->{handle}->clearerr;
	return;
    }
    return $sec, $text;
}

sub _read_header {
    my $self = shift;
    $self->{handle}->read(my($data), 12) or die 'EOF';
    my($sec, $usec, $length) = unpack 'VVV', $data;
    return $sec + $usec / 1_000_000, $length;
}

1;
__END__

=head1 NAME

Term::TtyRec - handles ttyrec data

=head1 SYNOPSIS

  use Term::TtyRec;
  use FileHandle;

  # $handle is any IO::* object
  my $handle = FileHandle->new('file.tty');
  my $ttyrec = Term::TtyRec->new($handle);

  # iterates through datafile
  while (my($sec, $text) = $ttyrec->read_next) {
      do_some_stuff();
  }

=head1 DESCRIPTION

What is ttyrec?  Here is an excerpt.

  ttyrec is a tty recorder. Recorded data can be played back with the
  included ttyplay command. ttyrec is just a derivative of script
  command for recording timing information with microsecond accuracy
  as well. It can record emacs -nw, vi, lynx, or any programs running
  on tty.

See http://www.namazu.org/~satoru/ttyrec/ for details.

Term::TtyRec is a simple class for ttyrec recorded data. This module
provides a way to itertate through recorded from any IO. See
Term::TtyRec::Player for playing recorded data.

=head1 METHODS

=over 4

=item read_next

  ($sec, $text) = $ttyrec->read_next;

iterates data inside and returns number of second, textdata. Returns
empty list when it reaches end of data.

=back

=head1 ACKNOWLEDGEMENT

Almost all of its code are stolen from ruby-ttyplay.

=head1 AUTHOR

Tatsuhiko Miyagawa <miyagawa@bulknews.net>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Term::TtyRec::Player>, http://namazu.org/~satoru/ttyrec/

=cut

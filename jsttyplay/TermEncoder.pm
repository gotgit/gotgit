package TermEncoder;
use strict;

use Time::HiRes qw/ time /;

sub new {
    my ($class, %args) = @_;
    my $self = bless {}, $class;

    die unless exists $args{'term'};
    $self->{'term'} = delete $args{'term'};

    $self->{'frames'} = 0;
    $self->{'buffers'} = {
        d => ['as_string'],
        f => ['fg_as_string'],
        b => ['bg_as_string'],
        B => ['bold_as_string'],
        U => ['underline_as_string'],
    };

    return $self;
}

sub is_dirty {
    my ($self) = @_;

    return 1 if $self->{'frames'} == 0;

    for my $bufk ( keys %{$self->{'buffers'}} ) {
        my $buf = $self->{'buffers'}->{$bufk};
        my $fn = $buf->[0];
        return 1 if $buf->[1] ne $self->{'term'}->$fn;
    }

    return 0;
}

sub next_pframe {
    my ($self, $time) = @_;
    $time = time unless defined $time;

    return $self->next_iframe($time) if $self->{'frames'} == 0;

    my $fs = { t => $time+0, x => $self->{'term'}->curposx+0, y => $self->{'term'}->curposy+0 };

    for my $bufk ( keys %{$self->{'buffers'}} ) {
        my $buf = $self->{'buffers'}->{$bufk};
        my $fn = $buf->[0];
        my $new = $self->{'term'}->$fn;
        $fs->{$bufk} = $self->_compress_pframe_block( $buf->[1], $new )
            if $buf->[1] ne $new;
        $buf->[1] = $new;
    }

    $self->{'frames'}++;
    return $fs;
}

sub next_iframe {
    my ($self, $time) = @_;
    $time = time unless defined $time;

    my $fs = { t => $time+0, i => 1, x => $self->{'term'}->curposx+0, y => $self->{'term'}->curposy+0 };

    for my $bufk ( keys %{$self->{'buffers'}} ) {
        my $buf = $self->{'buffers'}->{$bufk};
        my $fn = $buf->[0];
        my $info = $self->{'term'}->$fn;
        $fs->{$bufk} = $self->_compress_iframe_block( $info );
        $buf->[1] = $info;
    }

    $self->{'frames'}++;
    return $fs;
}

sub _compress_iframe_block {
    my ($self, $block) = @_;

    my @out = ();
    my @rows = split /\n/, $block;

    my $lastrow = undef;
    for my $r ( @rows ) {
        if ( defined $lastrow and $lastrow eq $r ) {
            push @out, 'd'; # duplicate last row
        } else {
            if ( (substr($r,0,1) x length($r)) eq $r ) {
                push @out, ['a', substr($r,0,1)]; # one-char line
            } else {
                push @out, ['r', $r]; # raw line
            }
            # TODO: RLE line
        }
        $lastrow = $r;
    }
    
    return \@out;
}

sub _compress_pframe_block {
    my ($self, $old, $new) = @_;
    my @old = split /\n/, $old;
    my @new = split /\n/, $new;
    die if @old != @new;
    my @diff;
    MAINROW: for my $row ( 0 .. $#old ) { NEXTER: {
        if ( $new[$row] ne $old[$row] ) {
            for my $other ( 0 .. $#old ) {
                if ( $new[$row] eq $old[$other] ) {
                    # row copy mode
                    push @diff, ['cp', $other+0, $row+0];
                    last NEXTER;
                }
            }

            if ( substr($new[$row],0,1) x length($new[$row]) eq $new[$row] ) {
                # one char line mode
                push @diff, [$row+0, ['a', substr($new[$row],0,1).""]];
                last NEXTER;
            }

            my @off = map { substr($old[$row], $_, 1) ne substr($new[$row], $_, 1) } 0 .. length($old[$row])-1;
            my @offchunks = ();
            for my $i ( 0 .. $#off ) {
                if ( $off[$i] ) {
                    if ( @offchunks and $offchunks[-1][1] >= $i-4 ) { # coalesce if there's less than 3 chars between
                        $offchunks[-1][1] = $i;
                    } else {
                        push @offchunks, [$i,$i];
                    }
                }
            }

            for my $ch ( @offchunks ) {
                if ( $ch->[0] == $ch->[1] ) {
                    # char mode
                    push @diff, [$row+0, $ch->[0]+0, substr($new[$row], $ch->[0], 1).""];
                } else {
                    my $chunk = substr($new[$row], $ch->[0], $ch->[1]-$ch->[0]+1);
                    if ( substr($chunk,0,1) x length($chunk) eq $chunk ) {
                        # one char chunk mode
                        push @diff, [$row+0, $ch->[0]+0, $ch->[1]+0, ['a',substr($chunk,0,1).""]];
                    } else {
                        # chunk mode
                        push @diff, [$row+0, $ch->[0]+0, $ch->[1]+0, $chunk.""];
                    }
                }
            }
        }
        } # NEXTER
        $old[$row] = $new[$row];
    }
    return \@diff;
}

sub frames { $_[0]->{'frames'} }

1;


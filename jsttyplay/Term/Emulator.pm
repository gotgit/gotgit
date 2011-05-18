package Term::Emulator;
use strict;

use IO::Pty;
use IO::Tty qw/ TIOCSWINSZ TCGETA TCSETA ICANON ISIG IEXTEN ECHO ECHOE ECHOKE ECHOCTL PENDIN ICRNL IXON IXANY IMAXBEL BRKINT OPOST ONLCR TIOCGETP TIOCSETN /;
use Term::Emulator::Parser;

use IO::Handle;
use Carp;
use Time::HiRes qw/ time sleep /;

our $STDIN, $STDOUT, $STDERR;
open $STDIN, "<&=", \*STDIN or die;
open $STDOUT, ">&=", \*STDOUT or die;
open $STDERR, ">&=", \*STDERR or die;

sub new {
    my ($class, %args) = @_;
    my $self = bless {}, $class;

    my $width  = exists $args{'width'}  ? delete $args{'width'}  : 80;
    my $height = exists $args{'height'} ? delete $args{'height'} : 24;

    $self->{'term'} = Term::Emulator::Parser->new(width => $width, height => $height);
    $self->{'pty'}  = IO::Pty->new;
    $self->{'pid'}  = undef;

    $self->{'buffers'} = {
        ptysend => '',
    };

    $self->set_size($width, $height);

    return $self;
}

sub set_size {
    my ($self, $width, $height) = @_;

    # TODO - kill WINCH the subproccess
    # TODO - update the Term::Emulator::Parser size

    ioctl $self->pty->slave, TIOCSWINSZ, pack "S!S!S!S!", $height, $width, $height, $width;

    return $self;
}

sub spawn {
    # based on IO::Pty::Easy v0.03
    my ($self, @program) = @_;
    my $slave = $self->pty->slave;

    croak "Can't spawn a process when one is already running!"
        if $self->is_active;

    # for returning errors from the child process
    my ($readp, $writep);
    unless ( pipe($readp, $writep) ) {
        croak "Failed to create a pipe";
    }
    $writep->autoflush(1);

    # fork the child
    my $pid = fork;
    croak "Couldn't fork" unless defined $pid;

    unless ( $pid ) {
        # child process
        close $readp;

        $self->pty->make_slave_controlling_terminal;
        close $self->pty;
        $slave->set_raw;

        # reopen STD{IN,OUT,ERR} to use the pty
    eval {
        open($STDIN,  "<&", $slave->fileno) or croak "Couldn't reopen STDIN for reading: $!";
        open($STDOUT, ">&", $slave->fileno) or croak "Couldn't reopen STDOUT for writing: $!";
        open($STDERR, ">&", $slave->fileno) or croak "Couldn't reopen STDERR for writing: $!";
    };
    warn "t: $@" if $@;
    die "t: $@" if $@;

        close $slave;

        system("stty","sane");

        exec(@program);

        # exec failed, tell our parent what happened
        print $writep $! + 0;
        carp "Cannot exec(@program): $!";

        exit 1;
    }

    # parent process continues
    close $writep;
    $self->{'pid'} = $pid;

    $self->pty->close_slave;
    $self->pty->set_raw;

    # this will block until EOF (exec killed the filehandle) or we get the error (exec failed)
    my $errno;
    my $read_bytes = sysread($readp, $errno, 256);

    unless ( defined $read_bytes ) {
        # something went bad wrong with the sysread
        my $err = $!;
        kill TERM => $pid;
        close $readp;
        # wait up to 2 seconds for the process to die
        my $starttime = time;
        sleep 0.01 while time() - $starttime < 2 and $self->is_active;
        if ( time() - $starttime >= 2 ) { # harmless race condition
            # beat the living crap out of the process
            kill KILL => $pid;
        }
        croak "Cannot sync with child: $err";
    }

    close $readp;

    if ( $read_bytes > 0 ) {
        # child couldn't exec
        $errno = $errno + 0;
        $self->_wait_for_inactive;
        croak "Cannot exec(@program): $errno";
    }

    return $self;
}

sub userinput {
    my ($self, $input) = @_;
    $self->term->userinput($input);
    $self->_move_term_sendbuf;
    $self->work_for(0);
    return $self;
}

sub key {
    my ($self, $key) = @_;
    $self->term->key($key);
    $self->_move_term_sendbuf;
    $self->work_for(0);
    return $self;
}

sub work_for {
    my ($self, $time) = @_;
    my $start = time;
    my $ptyfn = fileno($self->pty);
    my $loops = 0;
    while ( 1 ) {
        my $readvec = '';
        vec($readvec, $ptyfn, 1) = 1;

        my $writevec = '';
        if ( length $self->{'buffers'}->{'ptysend'} ) {
            vec($writevec, $ptyfn, 1) = 1;
        }

        my $len = ($start + $time) - time;
        if ( $len < 0 ) {
            last if $loops;
            $len = 0;
        }
        my $nfound = select($readvec, $writevec, undef, $len);
        last unless $nfound; # if no handles have been written to, we've finished our time chunk

        # check for reads
        if ( vec($readvec, $ptyfn, 1) ) {
            # pty can read

            my $buf = '';
            my $n = sysread $self->pty, $buf, 16384;
            if ( $n == 0 ) {
                # EOF
                $self->kill if $self->is_active;
                last;
            }
            $self->term->parse($buf); # pass data sent from the pty slave to the terminal
            $self->_move_term_sendbuf;
        }

        # check for writes if we have outstanding buffers
        if ( vec($writevec, $ptyfn, 1) ) {
            my $nchars = syswrite $self->pty, $self->{'buffers'}->{'ptysend'};
            if ( $nchars ) {
                $self->{'buffers'}->{'ptysend'} = substr $self->{'buffers'}->{'ptysend'}, $nchars;
            }
        }

        # TODO: check for error conditions
        $loops++;
    }

    return $self;
}

sub _move_term_sendbuf {
    my ($self) = @_;
    my $buf = $self->term->output;
    if ( length $buf ) {
        $self->{'buffers'}->{'ptysend'} .= $buf;
        $self->term->output = '';
    }
}

sub is_active {
    my ($self) = @_;

    return 0 unless defined $self->{'pid'};
    if ( kill 0, $self->{'pid'} ) {
        return 1;
    } else {
        undef $self->{'pid'};
    }
}

sub kill {
    my ($self, $signal) = @_;
    $signal = "KILL" unless defined $signal;

    return 0 unless $self->is_active;
    return kill $signal, $self->{'pid'};
}

sub stop_it_in {
    my ($self, $maxtime) = @_;
    $maxtime = 5 unless defined $maxtime;
    return 0 unless $self->is_active;

    kill KILL => $self->{'pid'};
    my $killtime = time;
    while ( time() - $killtime < $maxtime ) {
        return 1 if not $self->is_active;
        sleep 0.05;
    }

    kill TERM => $self->{'pid'};

    sleep 0.01;
    return $self->is_active;
}

sub _wait_for_inactive {
    my ($self) = @_;
    sleep 0.01 while $self->is_active;
}

sub pty  { $_[0]->{'pty'}  }
sub term { $_[0]->{'term'} }

1;


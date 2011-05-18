#!/usr/bin/perl
use warnings;
use strict;
$| = 1;

my $readsize = 1;
my $skipto = 0;
my $wait = 0.01;

use Term::TtyRec;
use Term::Emulator::Parser;
use FileHandle;
use Time::HiRes qw/ time sleep /;
use Carp;

$SIG{INT} = sub { confess };

sub openRec {
    my ($fn) = @_;
    my $fh = FileHandle->new($fn, "r") or die;
    my $rec = Term::TtyRec->new($fh);
    return $rec;
}

my $buf = '';
my $lasttime;
sub parseFrame {
    my ($rec, $term) = @_;
    if ( length $buf < $readsize ) {
        my ($time, $data) = $rec->read_next;
        return () if not defined $time and not length $buf;
        if ( defined $time ) {
            $buf .= $data;
            $lasttime = $time;
        }
    }
    if ( $lasttime < $skipto ) {
        $term->parse($buf);
        $buf = '';
        goto &parseFrame;
    } else {
        $term->parse(substr $buf, 0, $readsize);
        substr($buf, 0, $readsize) = '';
        return $lasttime;
    }
}

###

my $width = 80;
my $height = 24;
my $term = Term::Emulator::Parser->new( width => $width, height => $height );
my $rec  = openRec($ARGV[0]);

system("clear");
while ( defined(my $time = parseFrame($rec, $term)) ) {
    print "\033[H".$term->as_termstring."--";
    sleep $wait if $time >= $skipto and $wait;
}


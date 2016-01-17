#!/usr/bin/perl
use warnings;
use strict;
$| = 1;

my $coalesce_time = 0.05;
my $iframe_frequency = 100;

use Term::TtyRec;
use Term::Emulator::Parser;
use TermEncoder;
use FileHandle;
use Time::HiRes qw/ time sleep /;
use JSON;
use Carp;

$SIG{INT} = sub { confess };

sub openRec {
    my ($fn) = @_;
    my $fh = FileHandle->new($fn, "r") or die; # wtf.
    my $rec = Term::TtyRec->new($fh);
    return $rec;
}

my $readframes = 0;
{
    my $lasttime = undef;
    my @data = ();
    sub parseFrame {
        my ($rec, $term) = @_;
        local $_;
        while ( not @data or (defined $lasttime and $data[-1]->[0] - $lasttime < $coalesce_time) ) {
            my ($time, $data) = $rec->read_next;
            last unless defined $time;
            push @data, [$time, $data];
            $readframes++;
        }
        if ( @data > 1 ) {
            my $ld = pop @data;
            $term->parse($_) for map $_->[1], @data;
            $lasttime = $data[-1][0];
            @data = ($ld);
            return $lasttime;
        } elsif ( @data ) {
            $term->parse($_) for map $_->[1], @data;
            $lasttime = $data[-1][0];
            @data = ();
            return $lasttime;
        } else {
            return;
        }
    }
}

###

print "setup\n";

my $width   = 80;
my $height  = 24;
my $term    = undef;
my $rec     = undef;
my $outfile = undef;

while ( @ARGV ) {
    my $ar = shift;
    if ( $ar eq "--width" or $ar eq "-w" ) {
        $width = shift;
    } elsif ( $ar eq "--height" or $ar eq "-h" ) {
        $height = shift;
    } elsif ( $ar eq "--size" or $ar eq "-s" ) {
        my $size = shift;
        my ($w,$h) = ($size =~ /^(\d+)x(\d+)$/);
        die "size argument is malformed, use WIDxHEI\n"
            unless defined $w and defined $h;
        $width = $w;
        $height = $h;
    } elsif ( not defined $rec ) {
        $rec = openRec($ar);
    } elsif ( not defined $outfile ) {
        die "won't overwrite an existing file $ar"
            if -e $ar;
        $outfile = $ar;
    } else {
        die "unknown argument or too many arguments: $ar\n";
    }
}

$term = Term::Emulator::Parser->new( width => $width, height => $height, output_enable => 0 );
my $encoder = TermEncoder->new( term => $term );

my @timeline;

print "parse... 0 \033[K";

my %buffers = (
    d => ['as_string'],
    f => ['fg_as_string'],
    b => ['bg_as_string'],
    B => ['bold_as_string'],
    U => ['underline_as_string'],
);

my $lastx = undef;
my $lasty = undef;

for my $k ( keys %buffers ) {
    my $f = $buffers{$k}->[0];
    push @{$buffers{$k}}, $term->$f;
}

my $starttime = undef;
while ( defined(my $time = parseFrame($rec, $term)) ) {
    push @timeline, $encoder->frames % $iframe_frequency == 0 ? $encoder->next_iframe($time) : $encoder->next_pframe($time);
    print "\rparse... ".$encoder->frames." ($readframes) \033[K";
}

print "\rparsed ".$encoder->frames." frames ($readframes from ttyrec)\033[K\n";
print "serialize\n";

open my $sf, ">", $outfile or die "Couldn't open $outfile for writing: $!";
print $sf to_json { timeline => \@timeline, width => $width, height => $height };
close $sf;

print "done\n";


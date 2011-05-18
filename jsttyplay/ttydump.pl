#!/usr/bin/perl
use warnings;
use strict;

open my $lf, "<", $ARGV[0] or die "Couldn't open $ARGV[0] for reading: $!";

while ( read $lf, my($buf), 12 ) {
    my ($time, $ftime, $len) = unpack "VVV", $buf;
    read $lf, my($contents), $len;
    $contents =~ s/((?!\\)[^[:print:] \n])/"\\x{".unpack("H*", $1)."}"/egs;
    $time += $ftime / 1_000_000;
    printf "%.4f: %s\n", $time, $contents;
}


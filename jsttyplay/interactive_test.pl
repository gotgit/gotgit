#!/usr/bin/perl
use warnings;
use strict;

$| = 1;

use Term::Emulator;
use Term::ReadKey;

sub key { ReadMode(4); my $key = ReadKey(-1); ReadMode(0); return $key; }
my $term = Term::Emulator->new;
$term->spawn("login");

my $inttimemin  = 0.02;
my $inttimemax  = 1.00;
my $inttimemultstep = 0.001;

my $inttime = $inttimemin;
my $inttimemult = 1.0;

while ( $term->is_active ) {
    $term->work_for($inttime);
    $inttime *= ($inttimemult += $inttimemultstep);
    $inttime = $inttimemax if $inttime > $inttimemax;
    print "\033[H" . $term->term->as_termstring . "--\n";
    my $key = key();
    if ( defined $key ) {
        $term->key($key);
        $term->key($key) while defined($key = key());
        $inttime = $inttimemin;
        $inttimemult = 1.0;
    }
}

print "\nexited\n";


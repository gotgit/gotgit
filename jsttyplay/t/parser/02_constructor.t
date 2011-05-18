#!/usr/bin/perl
use strict;
use warnings;

use Test::More tests => 5;
use Term::Emulator::Parser;

my $term = Term::Emulator::Parser->new;

is($term->width, 80);
is($term->height, 24);
my $str = join "\n", map { " " x 80 } 1 .. 24;
is($term->as_string, $str);

$term = Term::Emulator::Parser->new( width => 20, height => 10 );
is($term->width, 20);
is($term->height, 10);


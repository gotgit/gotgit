#!/usr/bin/perl
use warnings;
use strict;

use Test::More tests => 9;

use Term::Emulator::Parser;

my $term = Term::Emulator::Parser->new(width => 5, height => 2);

$term->parse("abc");
is($term->as_string, "abc  \n     ");
$term->parse("def");
is($term->as_string, "abcde\nf    ");
$term->parse("gh");
is($term->as_string, "abcde\nfgh  ");
$term->parse("ijklmn");
is($term->as_string, "fghij\nklmn ");
$term->parse("opq\012rst");
is($term->as_string, "pq   \nrst  ");
$term->parse("\015uv");
is($term->as_string, "pq   \nuvt  ");
$term->parse("\010w");
is($term->as_string, "pq   \nuwt  ");
$term->parse("\010\010x");
is($term->as_string, "pq   \nxwt  ");
$term->parse("\010\010y");
is($term->as_string, "pq   \nywt  ");


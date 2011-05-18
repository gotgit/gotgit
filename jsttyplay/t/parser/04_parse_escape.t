#!/usr/bin/perl
use warnings;
use strict;

use Test::More tests => 77;

use Term::Emulator::Parser;

my $term = Term::Emulator::Parser->new( width => 8, height => 4 );

is($term->as_string,           "        \n        \n        \n        ");
is($term->bold_as_string,      "00000000\n00000000\n00000000\n00000000");
is($term->underline_as_string, "00000000\n00000000\n00000000\n00000000");
is($term->fg_as_string,        "77777777\n77777777\n77777777\n77777777");
is($term->bg_as_string,        "00000000\n00000000\n00000000\n00000000");

$term->parse("a");
is($term->as_string, "a       \n        \n        \n        ");
is($term->curposx, 2);
is($term->curposy, 1);
$term->parse("\033[H");
is($term->as_string, "a       \n        \n        \n        ");
is($term->curposx, 1);
is($term->curposy, 1);
$term->parse("b");
is($term->as_string, "b       \n        \n        \n        ");
$term->parse("\010 ");
is($term->as_string, "        \n        \n        \n        ");
is($term->bold_as_string,      "00000000\n00000000\n00000000\n00000000");
is($term->underline_as_string, "00000000\n00000000\n00000000\n00000000");
is($term->fg_as_string,        "77777777\n77777777\n77777777\n77777777");
is($term->bg_as_string,        "00000000\n00000000\n00000000\n00000000");

$term->parse("\033[2;3H");
is($term->curposx, 3);
is($term->curposy, 2);
$term->parse("q");
is($term->as_string, "        \n  q     \n        \n        ");
$term->parse("\033[A");
is($term->curposx, 4);
is($term->curposy, 1);
$term->parse("z");
is($term->as_string, "   z    \n  q     \n        \n        ");
$term->parse("\033[2;3f");
is($term->curposx, 3);
is($term->curposy, 2);
$term->parse(" ");
is($term->as_string, "   z    \n        \n        \n        ");
$term->parse("\033[3A");
is($term->curposx, 4);
is($term->curposy, 1);
$term->parse(" ");
is($term->as_string, "        \n        \n        \n        ");
is($term->bold_as_string,      "00000000\n00000000\n00000000\n00000000");
is($term->underline_as_string, "00000000\n00000000\n00000000\n00000000");
is($term->fg_as_string,        "77777777\n77777777\n77777777\n77777777");
is($term->bg_as_string,        "00000000\n00000000\n00000000\n00000000");

$term->parse("\033[H");
is($term->curposx, 1);
is($term->curposy, 1);
$term->parse("\033[B");
is($term->curposx, 1);
is($term->curposy, 2);
$term->parse("\033[2B");
is($term->curposx, 1);
is($term->curposy, 4);
$term->parse("\033[A");
is($term->curposx, 1);
is($term->curposy, 3);
$term->parse("\033[19B");
is($term->curposx, 1);
is($term->curposy, 4);

$term->parse("\033[H\033[C");
is($term->curposx, 2);
is($term->curposy, 1);
$term->parse("\033[5C");
is($term->curposx, 7);
is($term->curposy, 1);
$term->parse("\033[93C");
is($term->curposx, 8);
is($term->curposy, 1);

$term->parse("\033[D");
is($term->curposx, 7);
is($term->curposy, 1);
$term->parse("\033[D");
is($term->curposx, 6);
is($term->curposy, 1);
$term->parse(" \033[D\033[D\033[D");
is($term->curposx, 4);
is($term->curposy, 1);

$term->parse("\033[Habc");
is($term->curposx, 4);
is($term->curposy, 1);
is($term->as_string, "abc     \n        \n        \n        ");
$term->parse("\n");
is($term->curposx, 1);
is($term->curposy, 2);

$term->parse("\033[0;0H ");
is($term->curposx, 2);
is($term->curposy, 1);
is($term->as_string, " bc     \n        \n        \n        ");
$term->parse("  ");
is($term->curposx, 4);
is($term->curposy, 1);
is($term->as_string, "        \n        \n        \n        ");

is($term->bold_as_string,      "00000000\n00000000\n00000000\n00000000");
is($term->underline_as_string, "00000000\n00000000\n00000000\n00000000");
is($term->fg_as_string,        "77777777\n77777777\n77777777\n77777777");
is($term->bg_as_string,        "00000000\n00000000\n00000000\n00000000");

$term->parse("\r");
is($term->curposx, 1);
is($term->curposy, 1);

$term->parse("  \033D");
is($term->curposx, 3);
is($term->curposy, 2);
$term->parse("\ra");
is($term->curposx, 2);
is($term->curposy, 2);
is($term->as_string, "        \na       \n        \n        ");


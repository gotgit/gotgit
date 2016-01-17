package Term::Emulator::Parser;
use strict;
use warnings;

use Carp;
use Storable qw/ dclone /;

sub ASSERTIONS_ENABLED { 0 }

# attribute indexes
sub FCOLOR  () { 0 }
sub BCOLOR  () { 1 }
sub BOLD    () { 2 }
sub ULINE   () { 3 }
sub REVERSE () { 4 }

sub new {
    my ($class, %args) = @_;
    my $self = bless {}, $class;

    my $width  = exists $args{'width'}  ? delete $args{'width'}  : 80;
    my $height = exists $args{'height'} ? delete $args{'height'} : 24;

    $self->{'width'} = $width;
    $self->{'height'} = $height;
    $self->{'extra_chars'} = ''; # buffer for incomplete escape codes
    $self->{'output'} = ''; # buffer for output
    $self->{'output_enable'} = exists $args{'output_enable'} ? delete $args{'output_enable'} : 1;
    $self->{'strict'} = exists $args{'strict'} ? delete $args{'strict'} : 0;

    $self->reset;

    return $self;
}

sub reset {
    my ($self) = @_;

    my $defattr = [];
    $defattr->[BCOLOR]  = 0;
    $defattr->[FCOLOR]  = 7;
    $defattr->[BOLD]    = 0;
    $defattr->[ULINE]   = 0;
    $defattr->[REVERSE] = 0;

    $self->{'buffers'} = [map +{
            data => [ map [map " ",         1 .. $self->width], 1 .. $self->height],
            attr => [ map [map [@$defattr], 1 .. $self->width], 1 .. $self->height],
            regionlow => 1,
            regionhi => $self->height,
            tabs => [ grep { $_ > 5 and $_ % 8 == 1 } 1 .. $self->width ], # 9, 17, ...
        }, 0..1];
    $self->{'active'} = 0;

    $self->{'curpos'} = [1,1];
    $self->{'cursorstack'} = [];
    $self->{'cursorattr'} = [@$defattr];
    $self->{'defaultattr'} = [@$defattr];

    $self->{'wrapnext'} = 0;
    $self->{'autowrap'} = 1;
    $self->{'originmode'} = 0;
    $self->{'linefeedback'} = 1;
    $self->{'insertmode'} = 0;
    $self->{'localecho'} = 0;
    $self->{'title'} = 'Term::Emulator';

    return $self;
}

sub softreset {
    my ($self) = @_;

    my $defattr = [];
    $defattr->[BCOLOR]  = 0;
    $defattr->[FCOLOR]  = 7;
    $defattr->[BOLD]    = 0;
    $defattr->[ULINE]   = 0;
    $defattr->[REVERSE] = 0;

    $self->{'curpos'} = [1,1];
    $self->{'cursorstack'} = [];
    $self->{'cursorattr'} = [@$defattr];
    $self->{'defaultattr'} = [@$defattr];

    $self->{'wrapnext'} = 0;
    $self->{'autowrap'} = 1;
    $self->{'originmode'} = 0;
    $self->{'linefeedback'} = 1;
    $self->{'insertmode'} = 0;
    $self->{'localecho'} = 0;

    return $self;
}

sub clear {
    my ($self) = @_;
    for my $y ( 0 .. $self->height-1 ) {
        for my $x ( 0 .. $self->width-1 ) {
            $self->data->[$y]->[$x] = ' ';
            $self->attr->[$y]->[$x] = $self->defaultattr;
        }
    }
}

sub switch_to_screen {
    my ($self, $index) = @_;
    die if $index < 0 or $index > $#{$self->{'buffers'}};
    $self->{'active'} = $index;
    $self->wrapnext = 0;
    return $self;
}

sub dowrap {
    my ($self) = @_;

    if ( $self->wrapnext ) {
        $self->curposx = 1;
    
        if ( $self->curposy == $self->regionhi ) {
            $self->scroll(1);
        } else {
            $self->curposy++;
        }
        
        $self->wrapnext = 0;
    }
}

sub key {
    my ($self, $key) = @_;
    die if length($key) > 1;
    if ( $key =~ /^[-0-9a-zA-Z<>,.\/?;:'"\[\]\{\}\\\|_=+~`!\@#\$\%^\&*\(\) \t\n]$/ ) {
        # printable ascii
        $self->output .= $key;
        $self->parse_char($key) if $self->localecho;
    } else {
        # unprintable ascii
        $self->output .= $key;
    }
}

sub userinput {
    my ($self, $input) = @_;
    for my $ch ( split //, $input ) {
        $self->key($ch);
    }
}

sub parse {
    my ($self, $string) = @_;

    # take our extra incomplete escape codes first
    $string = $self->{'extra_chars'} . $string;
    
    pos($string) = 0;
    while ( pos($string) != length($string) ) {
        if ( $string =~ /\G\033([-#()*+.\/].)/gc ) { # character set sequence (SCS)
            $self->parse_escape($1);

        } elsif ( $string =~ /\G\033(\].*?\007)/gc ) {
            $self->parse_escape($1);

        } elsif ( $string =~ /\G\033(\[.*?[a-zA-Z<>])/gc ) {
            $self->parse_escape($1);

        } elsif ( $string =~ /\G\033([^\[\]#()])/gc ) {
            $self->parse_escape($1);

        } elsif ( $string =~ /\G([^\033])/gcs ) {
            $self->parse_char($1);

        } else { last }
    }

    # save the incomplete escape codes for the next parse
    $self->{'extra_chars'} = substr $string, pos $string;

    return $self;
}

sub parse_escape {
    my ($self, $escape) = @_;

    if ( $escape =~ /^\[([0-9;]*)m$/ ) {
        $self->set_color($1);

    } elsif ( $escape =~ /^\]2;(.*)\007$/ ) {
        $self->title = $1; # window title

    } elsif ( $escape =~ /^\]1;(.*)\007$/ ) {
        # icon title

    } elsif ( $escape =~ /^\]0;(.*)\007$/ ) {
        $self->title = $1; # window and icon title

    } elsif ( $escape =~ /^\[(\??)(.+)h$/ ) {
        # set mode
        my ($q, $c) = ($1, $2);
        my @codes = map "$q$_", split /;/, $c;
        local $_;
        $self->set_mode($_) for @codes;

    } elsif ( $escape =~ /^\[(\??)(.+)l$/ ) {
        # reset mode
        my ($q, $c) = ($1, $2);
        my @codes = map "$q$_", split /;/, $c;
        local $_;
        $self->reset_mode($_) for @codes;

    } elsif ( 0
            or $escape eq "="    # keypad mode
            or $escape eq ">"    # keypad mode
            or $escape eq "[>"   # ???
            or $escape eq "#5"   # single-width single-height line
            or $escape =~ /^\[.q$/ # leds
            or $escape =~ /^[()*+].$/ # set character sets
      ) {
        # ignore

    } elsif ( $escape eq "[c" or $escape eq "[0c" ) {
        # report device attributes
        $self->output .= "\033[?1;2c"; # I am VT100 with advanced video option

    } elsif ( $escape eq "Z" ) {
        # identify terminal (report)
        $self->output .= "\033[/Z"; # I am VT52

    } elsif ( $escape eq "[5n" ) {
        # status report
        $self->output .= "\033[0n"; # OK - we'll never have hardware problems.

    } elsif ( $escape eq "[6n" ) {
        # report cursor position (CPR)
        $self->output .= "\033[".$self->curposy.";".$self->curposx."R";

    } elsif ( $escape eq "7" ) {
        # save cursor and attribute
        push @{$self->cursorstack}, {
            posx => $self->curposx,
            posy => $self->curposy,
        };

    } elsif ( $escape eq "8" ) {
        # restore cursor and attribute
        my $state = pop @{$self->cursorstack};
        if ( defined $state ) {
            $self->curposx = $state->{'posx'};
            $self->curposy = $state->{'posy'};
        }
        $self->wrapnext = 0;

    } elsif ( $escape =~ /^\[(\d+);(\d+)r$/ ) {
        # set margins
        my ($lo,$hi) = ($1,$2);
        $lo = 1 if $lo < 1;
        $hi = $self->height if $hi > $self->height;
        $self->regionlow = $lo;
        $self->regionhi  = $hi;

    } elsif ( $escape eq "[r" ) {
        # reset margins
        $self->regionlow = 1;
        $self->regionhi  = $self->height;

    } elsif ( $escape eq "[H" or $escape eq "[f" ) {
        # cursor home
        $self->curposx = 1;
        $self->curposy = 1;
        $self->wrapnext = 0;

    } elsif ( $escape =~ /^\[(\d+);(\d+)[Hf]$/ ) {
        # cursor set position
        my ($y,$x) = ($1,$2);
        $x = 1 if $x < 1; $x = $self->width  if $x > $self->width;
        $y = 1 if $y < 1; $y = $self->height if $y > $self->height;
        $self->curposx = $x;
        $self->curposy = $y;
        $self->wrapnext = 0;

    } elsif ( $escape eq "[K" or $escape eq "[0K" ) {
        # erase from cursor to end of line
        my $row = $self->data->[$self->curposy-1];
        my $arow = $self->attr->[$self->curposy-1];
        for my $x ( $self->curposx .. $self->width ) {
            $row->[$x-1] = ' ';
            $arow->[$x-1] = $self->defaultattr;
        }

    } elsif ( $escape eq "[1K" ) {
        # erase from start of line to cursor
        my $row = $self->data->[$self->curposy-1];
        my $arow = $self->attr->[$self->curposy-1];
        for my $x ( 1 .. $self->curposx ) {
            $row->[$x-1] = ' ';
            $arow->[$x-1] = $self->defaultattr;
        }

    } elsif ( $escape eq "[2K" ) {
        # erase line
        my $row = $self->data->[$self->curposy-1];
        @$row = map ' ', @$row;
        my $arow = $self->attr->[$self->curposy-1];
        @$arow = map { +$self->defaultattr } @$arow;

    } elsif ( $escape =~ /^\[(\d*)M$/ ) {
        # delete lines
        my $erase = $1;
        $erase = 1 if not length $erase;
        if ( $self->curposy >= $self->regionlow and $self->curposy <= $self->regionhi ) {
            $erase = $self->regionhi-$self->curposy+1 if $erase > $self->regionhi-$self->curposy+1;
            my $aclone = $self->attr->[$self->regionhi-1];
            splice @{$self->attr}, $self->curposy-1,         $erase;
            splice @{$self->attr}, $self->regionhi-$erase, 0, map {+ dclone $aclone } 1 .. $erase;
            splice @{$self->data}, $self->curposy-1,         $erase;
            splice @{$self->data}, $self->regionhi-$erase, 0, map [ (' ') x $self->width ], 1 .. $erase;
        }

    } elsif ( $escape =~ /^\[(\d*)L$/ ) {
        # insert lines
        my $insert = $1;
        $insert = 1 if not length $insert;
        if ( $self->curposy >= $self->regionlow and $self->curposy <= $self->regionhi ) {
            $insert = $self->regionhi-$self->curposy+1 if $insert > $self->regionhi-$self->curposy+1;
            splice @{$self->attr}, $self->curposy-1, 0, map [ map {+ $self->defaultattr } 1 .. $self->width ], 1 .. $insert;
            splice @{$self->attr}, $self->regionhi-$insert, $insert;
            splice @{$self->data}, $self->curposy-1, 0, map [ (' ') x $self->width ], 1 .. $insert;
            splice @{$self->data}, $self->regionhi-$insert, $insert;
        }

    } elsif ( $escape =~ /^\[(\d+)P$/ ) {
        # delete characters
        my $del = $1;
        my $row  = $self->data->[$self->curposy-1];
        my $arow = $self->attr->[$self->curposy-1];
        splice @$row, $self->curposx-1, $del;
        push @$row, (' ') x $del;
        splice @$arow, $self->curposx-1, $del;
        push @$arow, map {+ dclone($arow->[-1]) } 1 .. $del;

    } elsif ( $escape =~ /^\[.?J$/ ) {
        # erase display
        $self->clear;

    } elsif ( $escape eq "[g" or $escape eq "[0g" ) {
        # tab clear at cursor position
        $self->tabs = [ grep { $_ != $self->curposx } $self->tabs ];

    } elsif ( $escape eq "[3g" ) {
        # clear all tabs
        $self->tabs = [];

    } elsif ( $escape eq "H" ) {
        # set tab stop at cursor position
        $self->tabs = [ sort { $a <=> $b } keys %{{ map +($_,1), @{$self->tabs}, $self->curposx }} ];

    } elsif ( $escape =~ /^\[(\d*)A$/ ) {
        # cursor up
        my $n = $1;
        $n = 1 unless length $n;
        $self->curposy -= $n;
        $self->curposy = 1 if $self->curposy < 1;

    } elsif ( $escape =~ /^\[(\d*)B$/ ) {
        # cursor down
        my $n = $1;
        $n = 1 unless length $n;
        $self->curposy += $n;
        $self->curposy = $self->height if $self->curposy > $self->height;

    } elsif ( $escape =~ /^\[(\d*)C$/ ) {
        # cursor forward
        my $n = $1;
        $n = 1 unless length $n;
        $self->curposx += $n;
        $self->curposx = $self->width if $self->curposx > $self->width;

    } elsif ( $escape =~ /^\[(\d*)D$/ ) {
        # cursor backward
        my $n = $1;
        $n = 1 unless length $n;
        $self->curposx -= $n;
        $self->curposx = 1 if $self->curposx < 1;

    } elsif ( $escape eq "D" ) {
        # index
        $self->dowrap;
        $self->curposy++;
        if ( $self->curposy > $self->height ) {
            $self->curposy--;
            $self->scroll(1);
        }

    } elsif ( $escape eq "M" ) {
        # reverse index
        $self->dowrap;
        $self->curposy--;
        if ( $self->curposy < 1 ) {
            $self->curposy++;
            $self->scroll(-1);
        }

    } elsif ( $escape eq "[!p" ) {
        # soft terminal reset
        $self->softreset;

    } elsif ( $escape eq "c" ) {
        # hard terminal reset
        $self->reset;

    } else {
        die "unknown escape: '$escape' (".unpack("H*",$escape).")";
    }

    $self->assert;
}

sub set_mode {
    my ($self, $mode) = @_;

    if ( $mode eq "8"     # auto repeat
      or $mode eq "9"     # interlacing
      or $mode eq "0"     # newline mode or error
      or $mode eq "5"     # reverse video
      or $mode eq "?1"    # cursor keys
      or $mode eq "?4"    # smooth scrolling
      or $mode eq "?3"    # 132-column mode
      or $mode eq "?9"    # mouse tracking on button press
      or $mode eq "?1000" # mouse tracking on button press and release
      or $mode eq "7"     # ???
      or $mode eq "6"     # ???
      or $mode eq "?25"   # ???
      ) {
        # ignore

    } elsif ( $mode eq "?7" ) {
        $self->autowrap = 1;

    } elsif ( $mode eq "?6" ) {
        $self->originmode = 1;
        die "origin mode not supported";

    } elsif ( $mode eq "20" ) {
        $self->linefeedback = 1;

    } elsif ( $mode eq "4" ) {
        $self->insertmode = 1;

    } elsif ( $mode eq "?47" ) {
        $self->switch_to_screen(0); # primary

    } elsif ( $mode eq "12" ) {
        $self->localecho = 0;

    } else {
        die "unknown mode '$mode'";
    }

    $self->assert;
}

sub reset_mode {
    my ($self, $mode) = @_;

    if ( $mode eq "8"     # auto repeat
      or $mode eq "9"     # interlacing
      or $mode eq "0"     # newline mode or error
      or $mode eq "5"     # reverse video
      or $mode eq "?1"    # cursor keys
      or $mode eq "?4"    # smooth scrolling
      or $mode eq "?3"    # 80 column mode
      or $mode eq "?9"    # mouse tracking on button press
      or $mode eq "?1000" # mouse tracking on button press and release
      or $mode eq "7"     # ???
      or $mode eq "6"     # ???
      or $mode eq "?25"   # ???
      ) {
        # ignore

    } elsif ( $mode eq "?7" ) {
        $self->autowrap = 0;

    } elsif ( $mode eq "?6" ) {
        $self->originmode = 0;

    } elsif ( $mode eq "20" ) {
        $self->linefeedback = 0;

    } elsif ( $mode eq "4" ) {
        $self->insertmode = 0;

    } elsif ( $mode eq "?47" ) {
        $self->switch_to_screen(1); # secondary

    } elsif ( $mode eq "12" ) {
        $self->localecho = 1;

    } else {
        die "unknown mode '$mode'";
    }

    $self->assert;
}

sub set_color {
    my ($self, $colorstring) = @_;

    my $rev = $self->cursorattr->[REVERSE];

    for my $m ( length $colorstring ? split /;/, $colorstring : '' ) {
        if ( not length $m or $m == 0 ) {
            @{$self->cursorattr} = @{$self->defaultattr};

        } elsif ( $m == 1 ) {
            $self->cursorattr->[BOLD] = 1;

        } elsif ( $m == 4 ) {
            $self->cursorattr->[ULINE] = 1;

        } elsif ( $m >= 30 and $m <= 37 ) {
            $self->cursorattr->[$rev ? BCOLOR : FCOLOR] = $m-30;

        } elsif ( $m >= 40 and $m <= 47 ) {
            $self->cursorattr->[$rev ? FCOLOR : BCOLOR] = $m-40;

        } elsif ( $m == 7 ) {
            if ( ! $self->cursorattr->[REVERSE] ) {
                my $fg = $self->cursorattr->[FCOLOR];
                my $bg = $self->cursorattr->[BCOLOR];
                $self->cursorattr->[BCOLOR] = $fg;
                $self->cursorattr->[FCOLOR] = $bg;
            }
            $rev = $self->cursorattr->[REVERSE] = 1;

        } elsif ( $m == 22 ) {
            $self->cursorattr->[BOLD] = 0;

        } elsif ( $m == 24 ) {
            $self->cursorattr->[ULINE] = 0;

        } elsif ( $m == 27 ) {
            if ( $self->cursorattr->[REVERSE] ) {
                my $fg = $self->cursorattr->[FCOLOR];
                my $bg = $self->cursorattr->[BCOLOR];
                $self->cursorattr->[BCOLOR] = $fg;
                $self->cursorattr->[FCOLOR] = $bg;
            }
            $rev = $self->cursorattr->[REVERSE] = 0;

        } elsif ( $m == 5 ) {
            # blink, ignore

        } else {
            warn "unknown color mode $m";
        }
    }
}

sub parse_char {
    my ($self, $char) = @_;
    if ( $char eq "\015" ) { # carriage return
        $self->curposx = 1;
        $self->wrapnext = 0;

    } elsif ( $char eq "\012" or $char eq "\014" ) { # line feed / form feed
        $self->curposx = 1 if $self->linefeedback;
        $self->curposy++;
        $self->wrapnext = 0;
        if ( $self->curposy > $self->regionhi ) {
            $self->curposy = $self->regionhi;
            $self->scroll(1);
        }

    } elsif ( $char eq "\011" ) { # tab
        my $to = $self->tabpositionfrom($self->curposx);
        while ( $self->curposx != $to ) {
            $self->data->[$self->curposy-1]->[$self->curposx-1] = ' ';
            $self->attr->[$self->curposy-1]->[$self->curposx-1] = dclone $self->cursorattr;
            $self->curposx++;
        }

    } elsif ( $char eq "\010" ) { # backspace
        $self->curposx--;
        if ( $self->curposx == 0 ) {
            $self->curposx = 1;
        }

    } elsif ( $char =~ /[[:print:]]/ or ord $char > 127 ) {
        $self->dowrap if $self->wrapnext;

        if ( $self->insertmode ) {
            splice @{$self->data->[$self->curposy-1]}, $self->curposx-1, 0, $char;
            pop @{$self->data->[$self->curposy-1]};
            splice @{$self->attr->[$self->curposy-1]}, $self->curposx-1, 0, dclone $self->cursorattr;
            pop @{$self->attr->[$self->curposy-1]};
        } else {
            $self->data->[$self->curposy-1]->[$self->curposx-1] = $char;
            $self->attr->[$self->curposy-1]->[$self->curposx-1] = dclone $self->cursorattr;
        }

        my $pos = $self->curpos;
        $pos->[0]++;
        if ( $pos->[0] > $self->width ) {
            $pos->[0] = $self->width;
            $self->wrapnext = 1 if $self->autowrap;
        }

    } elsif (  ord $char == 0 # null
            or ord $char == 7 # bell
            or ord $char == 016 # shift out
            or ord $char == 017 # shift in
      ) {
        # ignore

    } else {
        # die ord $char;
        warn "Bad character ". ord $char;
    }

    $self->assert;
}

sub scroll {
    my ($self, $amt) = @_;

    my @part  = splice @{$self->data}, $self->regionlow-1, $self->regionhi-$self->regionlow+1;
    my @apart = splice @{$self->attr}, $self->regionlow-1, $self->regionhi-$self->regionlow+1;

    local $_;
    if ( $amt > 0 ) {
        shift @part for 1 .. $amt;
        shift @apart for 1 .. $amt;
        push @part, [ (' ') x $self->width ] for 1 .. $amt;
        push @apart, [ map {+ $self->defaultattr } 1 .. $self->width ] for 1 .. $amt;

    } elsif ( $amt < 0 ) {
        $amt = -$amt;
        pop @part for 1 .. $amt;
        pop @apart for 1 .. $amt;
        unshift @part, [ (' ') x $self->width ] for 1 .. $amt;
        unshift @apart, [ map {+ $self->defaultattr } 1 .. $self->width ] for 1 .. $amt;

    } else { die }

    splice @{$self->data}, $self->regionlow-1, 0, @part;
    splice @{$self->attr}, $self->regionlow-1, 0, @apart;
    
    $self->assert;
}

sub as_string { join "\n", map { join "", @$_ } @{$_[0]->data} }

sub fg_as_string        { join "\n", map { join "", map   $_->[FCOLOR],               @$_ } @{$_[0]->attr} }
sub bg_as_string        { join "\n", map { join "", map   $_->[BCOLOR],               @$_ } @{$_[0]->attr} }
sub bold_as_string      { join "\n", map { join "", map +($_->[BOLD] ? "1" : "0"),    @$_ } @{$_[0]->attr} }
sub underline_as_string { join "\n", map { join "", map +($_->[ULINE] ? "1" : "0"),   @$_ } @{$_[0]->attr} }

sub as_termstring {
    my ($self) = @_;
    
    my $defat = $self->defaultattr;

    my $str = "\033[m";
    for my $y ( 0 .. $self->height-1 ) {

        my $drow = $self->data->[$y];
        my $arow = $self->attr->[$y];

        my $lastattr = $self->defaultattr;

        for my $x ( 0 .. $self->width-1 ) {
            if ( join('/', @$lastattr) ne join('/', @{$arow->[$x]}) ) {

                my $at = $arow->[$x];

                $str .= "\033[".join(';', '',
                    ($at->[BOLD] ? "1" : ()),
                    ($at->[ULINE] ? "4" : ()),
                    ($at->[BCOLOR] != $defat->[BCOLOR] ? 4 . $at->[BCOLOR] : ()),
                    ($at->[FCOLOR] != $defat->[FCOLOR] ? 3 . $at->[FCOLOR] : ()),
                  )."m";

                $lastattr = $at;
            }

            $str .= $drow->[$x];
        }

        $str .= "\n\033[m";
    }
    return $str;
}

sub tabpositionfrom {
    my ($self, $pos) = @_;
    for my $tab ( @{$self->tabs} ) {
        return $tab if $tab > $pos;
    }
    return $self->width;
}

sub assert {
    my ($self) = @_;
    return unless ASSERTIONS_ENABLED;
    confess unless @{$self->{'buffers'}};
    confess if $self->{'active'} < 0;
    confess if $self->{'active'} > $#{$self->{'buffers'}};
    confess if $self->curposx <= 0;
    confess if $self->curposy <= 0;
    confess if $self->curposx > $self->width;
    confess if $self->curposy > $self->height;
    confess if $self->regionlow <= 0;
    confess if $self->regionlow > $self->height;
    confess if $self->regionhi <= 0;
    confess if $self->regionhi > $self->height;
    confess if $self->regionhi < $self->regionlow;

    for my $row ( 0 .. $self->height-1 ) {
        confess $row if @{$self->data->[$row]} != $self->width;
        confess $row if @{$self->attr->[$row]} != $self->width;

        for my $ch ( 0 .. $self->width-1 ) {
            confess "$row,$ch" if length $self->data->[$row]->[$ch] != 1;
            confess "$row,$ch" if not ref $self->attr->[$row]->[$ch];
            confess "$row,$ch" if $self->attr->[$row]->[$ch]->[FCOLOR] < 0;
            confess "$row,$ch" if $self->attr->[$row]->[$ch]->[BCOLOR] < 0;
            confess "$row,$ch" if $self->attr->[$row]->[$ch]->[FCOLOR] > 7;
            confess "$row,$ch" if $self->attr->[$row]->[$ch]->[BCOLOR] > 7;
        }
    }
}

sub active_buf { $_[0]{'buffers'}[$_[0]->{'active'}] }

sub data { $_[0]->active_buf->{'data'} }
sub attr { $_[0]->active_buf->{'attr'} }

sub width  { $_[0]->{'width'}  }
sub height { $_[0]->{'height'} }
sub defaultattr { [@{$_[0]->{'defaultattr'}}] }

sub curpos  { $_[0]->{'curpos'}    }
sub curposx :lvalue { $_[0]->{'curpos'}[0] }
sub curposy :lvalue { $_[0]->{'curpos'}[1] }
sub cursorstack { $_[0]->{'cursorstack'} }
sub cursorattr { $_[0]->{'cursorattr'} }

sub regionlow :lvalue { $_[0]->active_buf->{'regionlow'} }
sub regionhi  :lvalue { $_[0]->active_buf->{'regionhi'}  }

sub tabs :lvalue { $_[0]->active_buf->{'tabs'} }

sub autowrap :lvalue { $_[0]->{'autowrap'} }
sub wrapnext :lvalue { $_[0]->{'wrapnext'} }
sub originmode :lvalue { $_[0]->{'originmode'} }
sub linefeedback :lvalue { $_[0]->{'linefeedback'} }
sub localecho :lvalue { $_[0]->{'localecho'} }

sub insertmode :lvalue { $_[0]->{'insertmode'} }
sub title :lvalue { $_[0]->{'title'} }

sub output :lvalue { my $t = ''; $_[0]->{'output_enable'} ? $_[0]->{'output'} : $t }
sub output_enable { $_[0]->{'output_enable'} }

1;


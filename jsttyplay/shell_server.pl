#!/usr/bin/perl
use warnings;
use strict;

my $max_session_idle = 60; # more than a minute without a request

use Term::Emulator;
use TermEncoder;

use URI;
use URI::QueryParam;
use JSON;
use HTTP::Status;
use POSIX ':sys_wait_h';
use CGI::Fast;
use CGI;

while ( my $cgi = CGI::Fast->new ) {
    eval {
        my $uri = URI->new($ENV{REQUEST_URI});
        print STDERR "$uri\n";
        if ( $uri->path eq "/api" ) {
            api($uri);
        } else {
            static($uri);
        }
    };
    warn "error in handler: $@" if $@;
}

sub static {
    my ($uri) = @_;
    my $path = $uri->path;
    if ( $path eq "/" ) {
        print "status: 200\015\012Content-type: text/html\015\012\015\012";
        print <<EOF;
<html>
<head>
<script src="/streamtty.js"></script>
</head>
<body>
<div id="tty">Enable javascript, asshole</div>
<script>
startStreamTTY( document.getElementById("tty") );
</script>
</body>
</html>
EOF
        return;
    } elsif ( $path eq "/streamtty.js" ) {
        open my $lf, "<", "html/streamtty.js" or die $!;
        my $content = do { local $/; <$lf> };
        close $lf;
        print "status: 200\015\012content-type: text/javascript\015\012\015\012";
        print $content;
        return;
    } else {
        print "status: 404\015\012content-type: text/plain\015\012\015\012";
        print "Not found.";
        return;
    }
}

my %sessions = ();

sub reap {
    for my $id ( keys %sessions ) {
        if ( time() - $sessions{$id}{'last_active'} > $max_session_idle ) {
            print STDERR "reaped session: $id\n";
            my $s = delete $sessions{$id};
            $s->{'term'}->stop_it_in(1);
        }
    }
    1 while waitpid(-1, WNOHANG) > 0;
}

sub req_error {
    my ($msg) = @_;
    print "status: 500\015\012content-type: text/json\015\012\015\012";
    print to_json( { ok => 0, error => $msg } );
}

sub api {
    my ($uri) = @_;

    reap();

    if ( $uri->query_param("type") eq "create session" ) {
        my $id = new_session();
        print STDERR "new session: $id\n";
        $sessions{$id}->{'term'}->work_for(0.02);
        print "status: 200\015\012content-type: text/json\015\012\015\012";
        print to_json( { ok => 1, id => $id, iframe => $sessions{$id}->{'encoder'}->next_iframe } );
        return;

    } elsif ( $uri->query_param("type") eq "user input" ) {
        my $id = $uri->query_param("id");
        return req_error("No such session.") unless exists $sessions{$id};
        $sessions{$id}{'last_active'} = time;
        my ($term, $enc) = @{$sessions{$id}}{'term', 'encoder'};
        $term->userinput($uri->query_param("keys"));
        $term->work_for(0.02);
        print "status: 200\015\012content-type: text/json\015\012\015\012";
        print to_json( { ok => 1, id => $id, pframe => $enc->next_pframe } );
        return;

    } elsif ( $uri->query_param("type") eq "pframe" ) {
        my $id = $uri->query_param("id");
        return req_error("No such session.") unless exists $sessions{$id};
        $sessions{$id}{'last_active'} = time;
        my ($term, $enc) = @{$sessions{$id}}{'term', 'encoder'};
        $term->work_for(0.02);
        print "status: 200\015\012content-type: text/json\015\012\015\012";
        print to_json( { ok => 1, id => $id, pframe => $enc->next_pframe } );
        return;

    } elsif ( $uri->query_param("type") eq "close session" ) {
        my $id = $uri->query_param("id");
        return req_error("No such session.") unless exists $sessions{$id};
        my $s = delete $sessions{$id};
        my $term = $s->{'term'};
        $term->stop_it_in(1);
        print "status: 200\015\012content-type: text/json\015\012\015\012";
        print to_json( { ok => 1 } );
        return;

    } else {
        return req_error("Bad request: unknown request type");
    }
}

sub new_session {
    my $id = '';
    while ( not length $id or exists $sessions{$id} ) {
        $id = unpack "H*", join '', map chr rand 255, 1 .. 20;
    }
    my $term = Term::Emulator->new;
    $term->spawn("login");
    my $encoder = TermEncoder->new(term => $term->term);
    $sessions{$id} = {
        term => $term,
        encoder => $encoder,
        last_active => time,
    };
    return $id;
}


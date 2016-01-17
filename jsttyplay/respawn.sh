#!/bin/sh

killall lighttpd
lighttpd -f lighttpd.conf || exit 1
if [ -e fastcgi.pid ]; then
    kill `cat fastcgi.pid`;
    sleep 1;
    kill -9 `cat fastcgi.pid`;
    rm -f fastcgi.pid;
fi
spawn-fcgi -f ./shell_server.pl -P fastcgi.pid -p 1065


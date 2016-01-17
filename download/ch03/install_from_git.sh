#!/bin/sh

for ver in      \
    v1.5.0      \
    v1.7.3.5    \
    v1.7.4-rc1  \
; do
    echo "Begin install Git $ver.";
    git reset --hard
    git clean -fdx
    git checkout $ver || {
        echo "Checkout git $ver failed."; exit 1
    }
    make prefix=/opt/git/$ver all && \
    sudo make prefix=/opt/git/$ver install || {
        echo "Install git $ver failed."; exit 1
    }
    echo "Installed Git $ver."
done

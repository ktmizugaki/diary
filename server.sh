#!/bin/sh

USER=nginx

mkusrdir() {
    local dir=$1
    if [ -f $dir ]; then
        echo cannot create $dir. it is a file! >&2
        exit 1
    fi
    if ! [ -d $dir ]; then
        mkdir -p $dir || exit 1
        chown $USER.$USER $dir
    fi
}

mkusrdir tmp
mkusrdir data

su $USER -s /bin/bash -c 'eval $(perl -Mlocal::lib=$PWD/perl5);
exec plackup -s FCGI --listen tmp/diary.socket -R ./templates ./diary'

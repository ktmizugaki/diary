#!/bin/sh

if [ "$UID" = "0" ]; then
    USER=nginx
fi

mode=$1

mkusrdir() {
    local dir=$1
    if [ -f $dir ]; then
        echo cannot create $dir. it is a file! >&2
        exit 1
    fi
    if ! [ -d $dir ]; then
        mkdir -p $dir || exit 1
    fi
    chown -R $USER:$USER $dir || exit 1
}

mkusrdir tmp
mkusrdir log
mkusrdir data

if [ x$mode = xstop ]; then
    if [ -r tmp/diary.pid ]; then
        kill -TERM $(cat tmp/diary.pid)
    fi
    exit $?
fi

options=
if [ x$mode = xdaemon ]; then
    if [ -f tmp/diary.pid ]; then
        echo try to stop running proccess >&2
        kill -TERM $(cat tmp/diary.pid)
    fi
    options="--pid tmp/diary.pid -D -E deployment"
else
    options="--access-log log/access.log -R ./lib,./lib/Diary,./templates,./templates/layouts"
fi

exec su $USER -s /bin/bash -c 'eval $(perl -Mlocal::lib=$PWD/perl5);
exec plackup -s FCGI -l tmp/diary.socket '"$options"' ./diary'

#!/bin/sh

install() {
    cpanm --local-lib=$PWD/perl5 --notest $1
}

install Plack
install FCGI::ProcManager
install Linux::Inotify2
install Mojolicious

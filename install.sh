#!/bin/sh

export PERL_USE_UNSAFE_INC=1

install() {
    cpanm --local-lib=$PWD/perl5 --notest $1
}

install Plack
install FCGI
install FCGI::ProcManager
install Linux::Inotify2
install Mojolicious

package Diary;
use strict;
use warnings;
use Diary::Entry;

sub years {
    [qw/2014 2013 2012 2011/];
}

sub entries {
    my ($year) = @_;
    return [Diary::Entry->new("${year}0615", "2100"), Diary::Entry->new("${year}1231", "2100"), Diary::Entry->new(($year+1)."0101", "2100"), ];
}

1;

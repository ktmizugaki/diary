package Diary;
use strict;
use warnings;
use Time::Piece;
use Diary::Entry;
use Diary::Date qw/index_year/;

sub dir_entries {
    my ($dir, $reg) = @_;
    my @entries = ();
    if (opendir my $dh, $dir) {
        @entries = grep { ! /^\.{1,2}$/ && /$reg/ } readdir($dh);
        closedir($dh);
    }
    return @entries;
}

my $last_checked_year = 0;
my $last_years;

sub years {
    my $t = localtime;
    my $year = index_year($t->year, $t->mon, $t->mday);
    if (!defined($last_years) || $year != $last_checked_year) {
        my @dirs = sort { -($a cmp $b) } dir_entries("data", qr/^\d{4}$/);
        $last_years = \@dirs;
        $last_checked_year = $year;
    }
    return $last_years;
}

sub entries {
    my ($year) = @_;
    return [Diary::Entry->new("${year}0615", "2100"), Diary::Entry->new("${year}1231", "2100"), Diary::Entry->new(($year+1)."0101", "2100"), ];
}

1;

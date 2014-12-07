package Diary;
use strict;
use warnings;
use Time::Piece;
use Diary::Entry;
use Diary::Date qw/index_year/;

sub now {
    my $t = localtime;
    my $date = sprintf "%04d%02d%02d", $t->year, $t->mon, $t->mday;
    my $time = sprintf "%02d%02d", $t->hour, $t->min;
    return ($date, $time);
}

my $last_checked_year = 0;
my $last_years;

sub years {
    my $t = localtime;
    my $year = index_year($t->year, $t->mon, $t->mday);
    if (!defined($last_years) || $year != $last_checked_year) {
        my @dirs = sort { -($a cmp $b) } map { substr($_, 5, 4) } glob("data/????/");
        $last_years = \@dirs;
        $last_checked_year = $year;
    }
    return $last_years;
}

sub entries {
    my ($year) = @_;
    my @files = glob("data/$year/??????/????????????.txt");
    my @entries = ();
    unless (@files) {
        die "files not found";
    }
    for my $file (@files) {
        if (my $entry = Diary::Entry->load($file)) {
            unshift @entries, $entry;
        }
    }
    return \@entries;
}

1;

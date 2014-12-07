package Diary;
use strict;
use warnings;
use Time::Piece;
use Diary::Entry;
use Diary::Date qw/index_year/;
use File::Path qw/make_path/;

sub is_date {
    my ($validation, $name, $value) = @_;
    return 1 unless $value =~ /\A\d{4}(\d{2})(\d{2})\z/;
    my ($month, $date) = ($1, $2);
    return 1 unless $month >= 1 && $month <= 12;
    return 1 unless $date >= 1 && $date <= 31;
    return undef;
}

sub is_time {
    my ($validation, $name, $value) = @_;
    return 1 unless $value =~ /\A(\d{2})(\d{2})\z/;
    my ($hour, $min) = ($1, $2);
    return 1 unless $hour >= 0 && $hour <= 32;
    return 1 unless $min >= 0 && $min < 60;
    return undef;
}

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

sub post {
    my ($date, $time, $text) = @_;
    my $d = Diary::Date->new($date);
    my $dir = sprintf "data/%04d/%04d%02d", index_year($d), $d->year, $d->month;
    my $name = sprintf "%04d%02d%02d%04d.txt", $d->year, $d->month, $d->mday, $time;
    make_path $dir;
    return Diary::Entry->save($dir."/".$name, $date, $time, $text);
}

1;

package Diary::Entry;
use utf8;
use strict;
use warnings;
use Diary::Date qw/isYYYYMMDD/;

sub new {
    my ($class, $date, $time) = @_;
    die "invalid date: $date" unless isYYYYMMDD($date);
    die "invalid time: $time" unless $time =~ /\A\d{4}\z/;
    bless {date => Diary::Date->new($date), time => $time}, $class;
}

sub year {
    $_[0]->{date}->{year};
}

sub month {
    $_[0]->{date}->{month};
}

sub mday {
    $_[0]->{date}->{mday};
}

sub time {
    $_[0]->{time};
}

sub text {
    my ($self) = @_;
    if ($self->month == 1 && $self->mday == 1) {
        return ["明けましておめでとうございます！"];
    }
    if ($self->month == 12 && $self->mday == 31) {
        return ["今日は大晦日"];
    }
    return ["なんでもない日ばんざい", "なんでもない日ばんざい"];
}

1;

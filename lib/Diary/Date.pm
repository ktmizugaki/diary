package Diary::Date;
use strict;
use warnings;
use Exporter qw/import/;
our @EXPORT_OK = qw/index_year isYYYYMMDD isYYYYMM/;

sub new {
    my $class = shift;
    my ($year, $month, $mday) = args_to_array(@_);
    return unless defined($year) || defined($month) || defined($mday);
    bless {year=>$year, month=>$month, mday=>$mday}, $class;
}

# instance methods
sub year {
    $_[0]->{year};
}

sub month {
    $_[0]->{month};
}

sub mday {
    $_[0]->{mday};
}

# class methods
sub index_year {
    my ($year, $month, $mday) = args_to_array(@_);
    return $month < 4 ? $year-1: $year;
}

sub args_to_array {
    if ($#_ == 0) {
        my $date = shift;
        my @ret;
        if (ref($date) eq 'HASH') {
            return ($date->{year}, $date->{month}, $date->{mday});
        } elsif (ref($date)) {
            return ($date->year, $date->month, $date->mday);
        } elsif (@ret = isYYYYMMDD($date)) {
            return @ret;
        } elsif (@ret = isYYYYMM($date)) {
            return @ret;
        }
    }
    if ($#_ == 2) {
        return @_;
    }
}

sub isYYYYMM {
    my $date = shift;
    if ($date =~ /\A(\d{4})(\d{2})\z/) {
        return ($1, $2, '01');
    }
    return;
}

sub isYYYYMMDD {
    my $date = shift;
    if ($date =~ /\A(\d{4})(\d{2})(\d{2})\z/) {
        return ($1, $2, $3);
    }
    return;
}

1;

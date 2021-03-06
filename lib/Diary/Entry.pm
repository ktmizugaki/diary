package Diary::Entry;
use strict;
use warnings;
use Diary::Date qw/isYYYYMMDD/;
use Encode qw/encode decode/;

sub new {
    my ($class, $date, $time, $text) = @_;
    die "invalid date: $date" unless isYYYYMMDD($date);
    die "invalid time: $time" unless $time =~ /\A\d{4}\z/;
    bless {date=>Diary::Date->new($date), time=>$time, text=>$text}, $class;
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

sub date {
    my $date = $_[0]->{date};
    $date->year.$date->month.$date->mday;
}

sub time {
    $_[0]->{time};
}

sub text {
    $_[0]->{text};
}

sub load {
    my ($self, $file) = @_;
    my ($date, $time, $text);
    if ($file =~ m#/\d{6}/(\d{8})(\d{4})\.txt\z#) {
        ($date, $time) = ($1, $2);
    } else {
        die "invalid file: $file";
        return;
    }
    if (open my $fh, "<", $file) {
        my @text = map { chomp; decode("utf-8", $_) } <$fh>;
        $text = \@text;
        close($fh);
    } else {
        die "cant read file: $file";
        return;
    }
    return $self->new($date, $time, $text);
}

sub save {
    my ($self, $file, $date, $time, $text) = @_;
    $text =~ s/[\r\n]+\z//g;
    $text =~ s/\r\n/\n/g;
    unless ($file =~ m#/\d{6}/\d{8}\d{4}\.txt\z#) {
        die "invalid file: $file";
        return;
    }
    if (open my $fh, ">", $file) {
        print $fh encode("utf-8", $text);
        close($fh);
    } else {
        die "cant write file: $file";
        return;
    }
    return $self->new($date, $time, [split /\n/, $text]);
}

1;

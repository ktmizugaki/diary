use strict;
use warnings;
use lib "lib";
use Test::More;
use Test::Mojo;

use Diary::Entry;

my $entry = Diary::Entry->new("20140101", "2100");
print "entry is ", $entry, "\n";

is($entry->year, "2014", "chekc date->year");
is($entry->month, "01", "chekc date->month");
is($entry->mday, "01", "chekc date->date");
is($entry->time, "2100", "chekc date->date");

done_testing();

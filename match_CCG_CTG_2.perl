#!/usr/bin/env perl

use strict;
use warnings;

my $input_file = "merge_counts_output.txt";
my $output_file = "percent_modified.output";

open my $in, '<', $input_file or die "Cannot open $input_file: $!";
my $header = <$in>; # skip header

my %ccg_sequences;

while (my $line = <$in>) {
  chomp $line;
  my ($seq, @values) = split /\t/, $line;

  if ($seq =~ /CCG/) {
    $ccg_sequences{$seq} = \@values;
  }
}

close $in;

my $num_matches = 0;

open my $out, '>', $output_file or die "Cannot open $output_file: $!";

print $out "CCG_sequence\tCTG_sequence\t", $header;
while (my ($ccg_seq, $ccg_values) = each %ccg_sequences) {
  my $ctg_seq = $ccg_seq;
  $ctg_seq =~ s/CCG/CTG/;

  if ($ctg_seq ne $ccg_seq) {
    foreach my $line (qx(grep $ctg_seq $input_file)) {
      chomp $line;
      my ($seq, @values) = split /\t/, $line;

      if ($seq eq $ctg_seq) {
        print $out "$ccg_seq\t$ctg_seq\t", join("\t", @$ccg_values), "\t", join("\t", @values), "\n";
        $num_matches++;
        last;
      }
    }
  }
}

close $out;

print "Number of matches found: $num_matches\n";

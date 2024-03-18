#!/usr/bin/perl

use strict;
use warnings;

my $unique_seq_file = "unique.sequences.txt";

# Get all input files ending in ".txt"
my @input_files = glob("*.txt");

# Initialize hash to store count of matching sequences
my %counts;

# Read unique sequences into an array
open(my $unique_seq_fh, "<", $unique_seq_file) or die "Cannot open file '$unique_seq_file': $!";
chomp(my @unique_seqs = <$unique_seq_fh>);
close($unique_seq_fh);

# Loop over input files
foreach my $input_file (@input_files) {
    my %seq_counts;

    # Read sequences and counts from input file into hash
    open(my $input_fh, "<", $input_file) or die "Cannot open file '$input_file': $!";
    while (my $line = <$input_fh>) {
        chomp $line;
        my ($seq, $count) = split(/\t/, $line);
        $seq_counts{$seq} = $count;
    }
    close($input_fh);

    # Increment count of matching sequences
    foreach my $seq (@unique_seqs) {
        my $count = $seq_counts{$seq} || 0;
        $counts{$seq}{$input_file} = $count;
    }
}

# Output counts to tab-delimited file
my $output_file = "merge_counts_output.txt";
open(my $output_fh, ">", $output_file) or die "Cannot open file '$output_file': $!";

# Output header row
print $output_fh "sequence\t";
foreach my $input_file (@input_files) {
    print $output_fh "$input_file\t";
}
print $output_fh "\n";

# Output count data
foreach my $seq (@unique_seqs) {
    print $output_fh "$seq\t";
    foreach my $input_file (@input_files) {
        my $count = $counts{$seq}{$input_file} || 0;
        print $output_fh "$count\t";
    }
    print $output_fh "\n";
}

close($output_fh);
print "Output written to $output_file\n";


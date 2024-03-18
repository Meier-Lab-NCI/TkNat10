≈∑#!/usr/bin/perl

use strict;
use warnings;

# Get the length of sequences to count from the command line
my $seq_length = shift || die "Usage: $0 <sequence_length>\n";
die "Invalid sequence length: $seq_length\n" unless $seq_length =~ /^\d+$/;

# Process each .txt file in the directory
foreach my $input_file (glob "*.txt") {
    # Open the input file
    open my $input_fh, "<", $input_file or die "Cannot open input file: $!";

    # Initialize a hash to store the count of each unique sequence
    my %counts;

    # Read each sequence in the input file and count its occurrences
    while (my $line = <$input_fh>) {
        # Remove any whitespace characters from the line
        $line =~ s/\s//g;

        # Skip sequences that are not the specified length or contain invalid characters
        next unless $line =~ /^[ATCG]{$seq_length}$/;

        # Increment the count for the current sequence
        $counts{$line}++;
    }

    # Close the input file
    close $input_fh;

    # Output the counts of each unique sequence to a file
    my $output_file = $input_file;
    $output_file =~ s/\.txt$/.$seq_length.txt/;
    open my $output_fh, ">", $output_file or die "Cannot create output file: $!";
    foreach my $seq (sort {$counts{$b} <=> $counts{$a}} keys %counts) {
        my $count = $counts{$seq};
        next if $count < 20; # Skip sequences with count less than 20
        print $output_fh "$seq\t$count\n";
    }
    close $output_fh;

    # Print a message indicating the output file was created
    print "Created $output_file\n";
}


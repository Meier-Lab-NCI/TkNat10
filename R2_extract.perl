#!/usr/bin/perl

use strict;
use warnings;

# User-defined flanking sequences
my $left_flank = "CTCCCTTAATGATC";
my $right_flank = "CCTTGTTACGAC";

# Process each fastq file in the directory
foreach my $input_file (glob "*.fastq") {

    # Output file name
    my $output_file = "R2_$input_file.output";

    # Open input and output files
    open my $in_fh, "<", $input_file or die "Cannot open input file: $!";
    open my $out_fh, ">", $output_file or die "Cannot create output file: $!";

    # Initialize variables
    my $seq = "";
    my $count = 0;

    # Process fastq file
    while (my $line = <$in_fh>) {
        # Remove newline character
        chomp $line;
        # If line starts with '@', it's a sequence header
        if ($line =~ /^@/) {
            # Clear the sequence variable
            $seq = "";
        }
        # If line starts with '+', it's a quality header (ignore it)
        elsif ($line =~ /^\+/) {
            next;
        }
        # Otherwise, it's a sequence line
        else {
            # Concatenate the sequence to the variable
            $seq .= $line;
            # If the sequence contains both flanking sequences
            if ($seq =~ /$left_flank(.+)$right_flank/) {
                # Extract the sequence between the flanking sequences
                my $extracted_seq = $1;
                # Write the extracted sequence to the output file
                print $out_fh "$extracted_seq\n";
                # Increment the count of extracted sequences
                $count++;
            }
        }
    }

    # Close input and output files
    close $in_fh;
    close $out_fh;

    # Print the count of extracted sequences for each input file
    print "Extracted $count sequences from $input_file\n";
}


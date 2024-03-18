#!/usr/bin/perl

use strict;
use warnings;

# User-defined left flanking sequence
my $left_flank = "GTCGTAACAAGG";
# Maximum extracted sequence length starting from flank
my $max_length = 24;

# Process each fastq file in the directory
foreach my $input_file (glob "*.fastq") {

    # Output file name
    my $output_file = "R1_$input_file.output";

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
            # If the sequence contains the left flanking sequence
            if ($seq =~ /$left_flank(.+)/) {
                # Extract the sequence to the right of the left flanking sequence
                my $extracted_seq = $1;
                # Remove any characters after ";" or "-" in the extracted sequence
                $extracted_seq =~ s/[;-].*//;
                # Trim the extracted sequence to the maximum length
                $extracted_seq = substr($extracted_seq, 0, $max_length);
                # Write the extracted sequence to the output file if it's not empty
                if ($extracted_seq =~ /\S/) {
                    print $out_fh "$extracted_seq\n";
                    # Increment the count of extracted sequences
                    $count++;
                }
            }
        }
    }

    # Close input and output files
    close $in_fh;
    close $out_fh;

    # Print the count of extracted sequences for each input file
    print "Extracted $count sequences from $input_file\n";
}


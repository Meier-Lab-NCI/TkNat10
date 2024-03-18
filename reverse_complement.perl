#!/usr/bin/perl

use strict;
use warnings;

# Process each input file in the directory
foreach my $input_file (glob "*.output") {
    # Output file name
    my $output_file = $input_file;
    $output_file =~ s/\.output$/.rcoutput/;

    # Open input and output files
    open my $in_fh, "<", $input_file or die "Cannot open input file: $!";
    open my $out_fh, ">", $output_file or die "Cannot create output file: $!";

    # Process each sequence in the input file
    while (my $sequence = <$in_fh>) {
        # Remove newline character
        chomp $sequence;
        # Reverse the sequence
        my $revseq = reverse $sequence;
        # Complement the sequence
        $revseq =~ tr/ATCGatcg/TAGCtagc/;
        # Write the reverse complement sequence to the output file
        print $out_fh "$revseq\n";
    }

    # Close input and output files
    close $in_fh;
    close $out_fh;

    # Print a message indicating the output file was created
    print "Created $output_file\n";
}


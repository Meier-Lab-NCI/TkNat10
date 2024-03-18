#!/usr/bin/perl

use strict;
use warnings;

# Process each R1 file in the directory
foreach my $r1_file (glob "R1*.fastq.output") {
    # Extract the character 3-11 substring from the filename
    my $match = substr($r1_file, 2, 9);

    # Find the corresponding R2 file
    my $r2_file = "R2_" . substr($r1_file, 3);
    $r2_file =~ s/\.output/.rcoutput/;
    $r2_file =~ s/R1/R2/;
    $r2_file =~ s/_h/_h/;
    print "R1 file: $r1_file\n";
    print "R2 file: $r2_file\n";

    # Output file name
    my $output_file = $match . ".txt";

    # Open input and output files
    open my $r1_fh, "<", $r1_file or die "Cannot open input file: $!";
    open my $r2_fh, "<", $r2_file or die "Cannot open input file: $!";
    open my $out_fh, ">", $output_file or die "Cannot create output file: $!";

    # Copy R1 file to output file
    while (my $line = <$r1_fh>) {
        print $out_fh $line;
    }

    # Copy R2 file to output file
    while (my $line = <$r2_fh>) {
        print $out_fh $line;
    }

    # Close input and output files
    close $r1_fh;
    close $r2_fh;
    close $out_fh;

    # Print a message indicating the output file was created
    print "Created $output_file\n";
}


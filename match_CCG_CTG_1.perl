#!/usr/bin/perl

use strict;
use warnings;

my $input_file = "3.txt";
my $output_file = "perl4.output";

my $ccg_regex = "CCG";

open(my $in, "<", $input_file) or die "Cannot open input file $input_file: 
$!";
open(my $out, ">", $output_file) or die "Cannot open output file 
$output_file: $!";

# Print header row to output file
print $out "CCG Sequence\tCTG Sequence\t", join("\t", 1..28), "\t", 
join("\t", 1..28), "\n";

# Read through input file and look for CCG sequences
my @ccg_lines;
while (my $line = <$in>) {
    chomp $line;
    my ($seq, @counts) = split(/\t/, $line);
    if ($seq =~ /$ccg_regex/) {
        push @ccg_lines, $line;
    }
}

# Loop through CCG sequences and look for matching CTG sequences
my $num_ccg = scalar(@ccg_lines);
my $num_processed = 0;
for my $ccg_line (@ccg_lines) {
    my ($ccg_seq, @ccg_counts) = split(/\t/, $ccg_line);
    my $ctg_seq = $ccg_seq;
    $ctg_seq =~ s/CCG/CTG/;

    # Search for matching CTG sequence
    my $matching_line = "";
    seek $in, 0, 0;
    while (my $line = <$in>) {
        chomp $line;
        my ($seq, @counts) = split(/\t/, $line);
        if ($seq eq $ctg_seq) {
            $matching_line = $line;
            last;
        }
    }

    # Print out matching CCG/CTG sequences and counts to output file
    if ($matching_line) {
        print $out "$ccg_seq\t$ctg_seq\t", join("\t", @ccg_counts), "\t", 
join("\t", (split(/\t/, $matching_line))[1..28]), "\n";
    }

    # Print out estimate of percent completion every 10,000 lines
    $num_processed++;
    if ($num_processed % 10000 == 0) {
        my $percent_complete = int(($num_processed/$num_ccg)*100);
        print "Processed $num_processed of $num_ccg CCG sequences 
($percent_complete% complete)\n";
    }
}

close $in;
close $out;

print "Done\n";


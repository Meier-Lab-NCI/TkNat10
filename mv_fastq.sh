#!/bin/bash

# Main directory
main_dir="/Users/meierjl/Desktop/Flowcell_AACJKH3M5"

# Find all .fastq files in subfolders and move them to the main directory
find "$main_dir" -type f -name "*.fastq" -exec mv {} "$main_dir" \;


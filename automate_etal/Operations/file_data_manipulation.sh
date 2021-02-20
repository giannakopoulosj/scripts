#!/bin/bash

#check column legth and print file name with separator ","
awk -F',' '{ if(length($1) < 1) {print FILENAME}}' foo.bar.file

#remove duplicate rows from file and create a new one.
#-u = unique
#-m = merges (used not to sort the file)
#-f'|' = speparator is '|'
#-k2,2 = 2nd column 2 duplicates
sort -um -t'|' -k2,2 your.file

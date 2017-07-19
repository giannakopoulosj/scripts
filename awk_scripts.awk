#!/usr/bin/awk

#check column legth and print file name with separator ","
awk -F',' '{ if(length($1) < 1) {print FILENAME}}' foo.bar.file

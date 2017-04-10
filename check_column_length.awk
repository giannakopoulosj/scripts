#!/usr/bin/awk


awk -F',' '{ if(length($1) < 1) {print FILENAME}}' foo.bar.file

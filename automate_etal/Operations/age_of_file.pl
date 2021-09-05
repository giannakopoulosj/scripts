#!/usr/bin/env perl

use warnings;
use strict;
use diagnostics;

sub warning {
  print "$_[0] \n";
  exit 1;

}

sub error {
  print "$_[0] \n";
  exit 2;
}

my $dir = $ARGV[0];
my $threshold = $ARGV[1];
my $pattern = $ARGV[2];

if (!-d $dir) {
  print "Directory $dir does not exist.\n";
  exit 2;
}

my @files = glob($dir.'/'.$pattern);
foreach(@files) {

  my $last_modified = (stat($_))[9];
  if ($last_modified <= (time() - $threshold)) {
    print "$_ ";
    print "$last_modified\n\n";
    print "The age of file $_ is grater than $threshold\n";
    exit 2;
  } else {
    print "The age of files in directory $dir is less than threshold $threshold seconds.\n";
    exit 0;

  }

}

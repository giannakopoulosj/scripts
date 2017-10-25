#!/usr/bin/perl
use warnings;
use strict;
use File::stat;
use diagnostics;

my $threshold=$ARGV[1];
my $dir=$ARGV[0];

if (-d $dir){
print "its a directory..\n";
}

my $stats=stat($dir);
my $my_time=$stats->mtime;

print  "Input Directory: ".$ARGV[0]."\n";
print "Directory age: ".$my_time."\n";
print "Now: ".time()."\n";

my $diff_time=time()-$my_time;
print "Diff:  $diff_time \n";

if ($diff_time > $threshold){
print "I will exit due to: $diff_time seconds inacitiviy \n\n";
exit 1;
}

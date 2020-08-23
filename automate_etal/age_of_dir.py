#!/usr/bin/python


from os import stat,path
from time import time
from sys import argv,exit


if len(argv) < 2:
    print "You must set argument!!! Usage: ",path.basename(__file__),"<path> <threashold>"


file_age_date=stat(argv[1]).st_mtime
threashold=int(argv[2])

age_file=time()-file_age_date

if age_file>threashold:
    print "File is older than ",threashold,"seconds"
    exit(1)
else:
    print "File is less than ",threashold,"seconds"
    exit(0)

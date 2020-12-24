#!/usr/bin/python

import multiprocessing
import os, subprocess
import time
import shutil
#from pprint import pprint

current_time = time.time()
unrar = "unrar e -inul -o+ -p%s %s /tmp/%s/"
rarfile = "WORKING.rar"
finished = multiprocessing.Value('i', 0)


with open('workfile', 'r') as passfile:
    data = passfile.read().split("\n")
del data[-1]
passfile.closed

def split(arr, count=4):
    return [arr[i::count] for i in range(count)]
data = split(data)

def worker(data, finished):
    while data and not finished.value:
        #print os.getpid(), finished.value
        passwd = data.pop(0)
        command = unrar % (passwd,rarfile,os.getpid())
        print command
        ret = subprocess.call(command.split())
        if ret == 0:
            print passwd
            shutil.copytree("/tmp/%s"%os.getpid(), "./"+rarfile.split(".")[0])
            finished.value = 1

jobs = []
for i in xrange(4):
    p = multiprocessing.Process(target=worker, args=(data[i],finished))
    jobs.append(p)

for p in jobs:
    p.start()

for p in jobs:
    p.join()

total_time = time.time()-current_time


print total_time

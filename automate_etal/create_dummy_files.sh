#!/bin/bash

#Will create 5 files of 50MegaByte each with name 1.txt 2.txt etc.
for i in {1..5}; do head -c 50M /dev/urandom > file"$i".txt; done

#!/bin/bash

set -e

scriptname=$(basename $0)
lock="../${scriptname}"

exec 200>$lock
flock -n 200 || (echo "Running..." && exit 1)

## The code:
pid=$$
echo $pid 1>&200
sleep 60
echo "Hello world"

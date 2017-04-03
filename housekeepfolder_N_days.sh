#!/bin/bash

_HDIR=/foo/bas
_NDAYS="100"
_PATTERN="*.csv"
_SUPPORT="FOO BAR"

echo "In case of failure please contact $_SUPPORT"

cd "$_HDIR" || (echo "No $_HDIR found" && exit 1)

echo -e "Before Housekeeping of $_HDIR\n\n"
df -m "$_HDIR"

find "$_HDIR" -name "$_PATTERN" -mtime +"$_NDAYS"-exec rm -rf {} \;

echo -e "\n\nAfter Housekeeping of  $_HDIR"
df -m "$_HDIR"

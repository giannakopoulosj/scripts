#!/bin/bash

_FILE='/pat/to/your/bar.csv'
_HEADER=$(head -1 $_FILE)

if [ "$_HEADER" != *"H|"* ]
then
    echo "No Header inserted"
    exit 1
fi

#!/bin/bash

if [ $(date +%w) -ne 0 ]&&[ $(date +%w) -ne 6 ]
then

echo "$(date) is a working date (Not Saturday nor Sunday)"

fi

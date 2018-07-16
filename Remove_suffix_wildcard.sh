#!/bin/bash

#Rationalize & more examples:
#http://tldp.org/LDP/abs/html/parameter-substitution.html
#remove suffix

for file in *.old; do mv "$file" "${file%%.old}"; done

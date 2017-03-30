#!/bin/bash

#Rationalize & more examples:
#http://tldp.org/LDP/abs/html/parameter-substitution.html

for file in *.old; do mv "$file" "${file%%.old}";

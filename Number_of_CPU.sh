#!/bin/bash
#No Linux.

psrinfo -v | grep ^Status | tail -1 | awk '{x = $5 + 1; print "CPUs: " x;}'

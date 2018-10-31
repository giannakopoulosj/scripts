#!/bin/bash

echo "\x1b\r" | telnet a.b.c.d	22 2>&1 | grep Connected &

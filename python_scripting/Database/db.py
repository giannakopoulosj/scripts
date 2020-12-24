#!/usr/bin/python
# -*- coding: utf-8 -*-

##Useing MySQL-python 1.2.3 from pip

import MySQLdb as mdb

con = mdb.connect('localhost', 'root', 'asdf1234');

with con: 
    cur = con.cursor()
    cur.execute("SHOW DATABASES")

#    rows = list(cur.fetchall())
rows = cur.fetchall()
#print type( rows),"ROWS"
#rows = list(rows)

#print type(rows),"ROWS2"
#print rows
for row in rows:
    row = str(row)
    row = row[2:-3]
    print row

print type(row)

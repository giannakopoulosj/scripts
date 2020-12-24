#!/usr/bin/python
# -*- coding: utf-8 -*-

##Useing MySQL-python 1.2.3 from pip
import pprint
import MySQLdb as mdb

con = mdb.connect('localhost', 'root', 'asdf1234');

with con: 
    cur = con.cursor()
    cur.execute("SHOW DATABASES")

rows = cur.fetchall()

for row in rows:
    print row[0]


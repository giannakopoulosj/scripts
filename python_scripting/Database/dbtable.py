#!/usr/bin/python
# -*- coding: utf-8 -*-

import MySQLdb as mdb
import _mysql_exceptions

host = "localhost"
user = "root"
pwd = "asdf1234"
db_create = "CREATE DATABASE "
db_name = "test"

con = mdb.connect(host, user, pwd);


try:
    with con:
        cur = con.cursor()
        cur.execute(db_create+db_name)
        rows = cur.fetchall()
except _mysql_exceptions.ProgrammingError as e:
    print "Can not Create DB with Name %s Already exist" % (db_name)

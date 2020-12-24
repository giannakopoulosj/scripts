#!/usr/bin/python

import bitlyapi
import argparse


#Credentials for bitlyapi
login = "xxxxxx"
key = "xxxxxxxxxxxxxxx"

parser = argparse.ArgumentParser(description="Gets input a long url and return a short url")
parser.add_argument("arg1", help="Take the URL for minimize")
parser.add_argument("-l","--long", help="Return and the Long URL", action="store_true")
args = parser.parse_args()

#Create URL for The api    
URL = args.arg1

#Connect and Take short URL back
connection = bitlyapi.BitLy(login, key)
shorten = connection.shorten(longUrl=URL)

#Output
print shorten["url"]
if args.long:
    print shorten["long_url"]

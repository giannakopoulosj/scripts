#!/usr/bin/python
#Author John Giannakopoulos <giannakopoulosj@gmail.com>
#The httplib2 can be installed via pip

"""Google ShorURL with out API
by using httplib2 that can be 
installed by pip
"""
import argparse
import json
import httplib2

#Static Values for Google ShortURL 
apiUrl = 'https://www.googleapis.com/urlshortener/v1/url'
headers = {"Content-type": "application/json"}

parser = argparse.ArgumentParser(description='Gets input a long url and return a short url from google https:\\\ is mandatory')
parser.add_argument("arg1", help="http://exapmle.com")
parser.add_argument("-l","--long", help="Print Long URL too", action="store_true")
args = parser.parse_args()

#Create URL
URL = args.arg1
#Check for valid argument
if not "http://" in URL:
    print "Enter URL with http://"
    raise SystemExit()

#URL for The API
longUrl = "%s"%URL
data = {"longUrl": longUrl}

h = httplib2.Http('.cache')
#Get Headers and Response From Google
headers, response = h.request(apiUrl, "POST", json.dumps(data), headers)

#Decode json
encoded_data = json.loads(response)
if args.long:
    print longUrl
print encoded_data["id"]

#!/usr/bin/python
import smtplib
import argparse

parser = argparse.ArgumentParser(description="""Send Mail through Gmail 
by reading a txt file in the same directory""")
parser.add_argument("fromaddress",help="username@gmail.com")
parser.add_argument("destenation",help="user@example.tld")
parser.add_argument("password", help="123456")
parser.add_argument("msg", help="Enter the file that contain Message")
args = parser.parse_args()

#Check for the user mail
if not "@gmail.com" in args.fromaddress:
    fromaddress = "%s@gmail.com"%args.fromaddress
else:
    fromaddress = "%s"%args.fromaddress

#Destanation Address
toaddress = "%s"%args.destenation

msg = "%s"%args.msg
with open("msg","r") as txt:
   msg = txt.read()
txt.close()

#Gmail Credentials
username = "%s"%fromaddress
password = "%s"%args.password

#Mail Mechanism
server = smtplib.SMTP("smtp.gmail.com:25")
server.starttls()
server.login(username,password)
server.sendmail(fromaddress,toaddress, msn)
server.quit()

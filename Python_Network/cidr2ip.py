import ipaddress
import os

myuser = str(os.getlogin())
mydesktoppath = "C:/Users/" + myuser + "/OneDrive - Accenture/Desktop/"
myinputfile = mydesktoppath + "myipsubnets.txt"
myoutputfile = mydesktoppath + "myoutput.txt"

#Read my source
file1 = open(myinputfile, 'r') 
Lines =  file1.read().splitlines()
file1.close()

#Write my output
file2 = open(myoutputfile, 'w') 
for line in Lines:
    #network = ipaddress.IPv4Network(line)
    ##print(ipaddress.IPv4Network(line).prefixlen)
    #for subnet in network.subnets(prefixlen_diff=prefixdiff-int(ipaddress.IPv4Network(line).prefixlen)):
    #    file2.write(str(subnet)+"\n")
    ##for host in network.hosts():  file2.write(str(host)+"\n")
    for ip in ipaddress.IPv4Network(line):
        file2.write(str(ip)+"\n")
file2.close() 

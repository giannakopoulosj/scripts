import ipaddress
import os

myuser = str(os.getlogin())
mydesktoppath = "C:/Users/" + myuser + "/OneDrive - Accenture/Desktop/"
myinputfile = mydesktoppath + "myipsubnets.txt"
myoutputfile = mydesktoppath + "myoutput.txt"
count = 0


#Read my source
file1 = open(myinputfile, 'r') 
Lines =  file1.read().splitlines()
file1.close()

#Write my output
file2 = open(myoutputfile, 'w') 
for line in Lines: 
    #print(line)
    network = ipaddress.IPv4Network(line)
    #print(network)
    for host in network.hosts():  file2.write(str(host)+"\n")
file2.close()
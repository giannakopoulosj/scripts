#import dns.resolver
import sys
sys.path.append("C:\Applications\Scripts\libs")
import dns.resolver

with open('input/dns_check.txt') as fin:
    for line in fin:
        domain = line.strip()
        try:
            nameservers = dns.resolver.query(domain, 'A')
        except:
            print str(domain) + ",null"
        else:
            for data in nameservers:
                print str(domain) + "," + str(data)

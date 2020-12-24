#!/usr/bin/python
import ConfigParser

config = ConfigParser.RawConfigParser(allow_no_value=True)
config.read('./test')
config.set("Section1","baz","hello world")
with open("./test","wb") as configfile:
    config.write(configfile)

print config.get("Section1", "baz")
print config.get("Section1","bar") 

#import ConfigParser

#config = ConfigParser.RawConfigParser()

#config.add_section('Section1')
#config.set('Section1', 'an_int', '15')
#config.set('Section1', 'a_bool', 'true')
#config.set('Section1', 'a_float', '3.1415')
#config.set('Section1', 'baz', 'fun')
#config.set('Section1', 'bar', 'Python')
#config.set('Section1', 'foo', '%(bar)s is %(baz)s!')

# Writing our configuration file to 'example.cfg'
#with open('./test', 'wb') as configfile:
#    config.write(configfile)

#!/usr/bin/python
#-*- coding: utf-8 -*-

import mechanize

br = mechanize.Browser()
response = br.open("http://eclass.teimes.gr/eclass")
#print response.read()

#for form in br.forms():
#    print "Form Name:",form.name
#    print form

br.form = list(br.forms())[2]
#print br.form

#for control in br.form.controls:
 #   print control
 #   print "type=%s, name=%s value=%s" % (control.type, control.name, br[control.name])

control = br.form.find_control("uname")
control2 = br.form.find_control("pass")
control.value = "XXXXXX"
control2.value = "XXXXX"
#print control
#print control2
response = br.submit()
#print response.read()

for link in br.links():
    if not "[IMG]" in link.text:
            if not "Έξοδος" in link.text:
                if not "Πληροφορίες Πνευματικών Δικαιωμάτων" in link.text:
                    print link.text

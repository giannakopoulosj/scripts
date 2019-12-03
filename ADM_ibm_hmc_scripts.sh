#!/bin/bash

#Virtual FC
for x in $(lssyscfg -r sys -F name); 
do 
lshwres -r virtualio -m $x --rsubtype fc --level lpar -F lpar_name,slot_num,wwpns --header |grep -v null;
done

#Physical FC
for x in $(lssyscfg -r sys -F name); 
do 
lshwres -r io -m $x --rsubtype slotchildren -F lpar_name,wwpn | grep -v null;
done

#Network MAC
for x in $(lssyscfg -r sys -F name);  do
lshwres -r virtualio --rsubtype eth --level lpar -m $x -F lpar_name,mac_addr; 
done

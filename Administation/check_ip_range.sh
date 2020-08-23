#!/bin/bash 
for ((i=$1; i<=$2; i++))#i in "{$1..$2}"
do
     for y in {1..255}
       do
         echo "$(host 10.41.$i.$y) has IP address: 10.41.$i.$y" >> $3.txt
       done
done


#for i in {2..3}; do for y in {1..255}; do host 10.41.15$i.$y >> test.txt; done; done

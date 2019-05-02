awk -F, '   BEGIN{OFS=FS}   NR==FNR {a[$1]; next}   $4 in a {$7 = "24:00:00"}   1 ' input.txt modify.csv


#cat input.txt
#TATAMOTORS
#TCS
#RELIANCE
#MARUTI
#HELLO
#THIS

#cat modify.csv
#124,1940000,792,TATAMOTORS,172.1.1.21,mode1,12:00:00,1,21,0,23,23,014,1000,alive,1,17,23
#124,1940000,792,hello,172.1.1.21,mode1,12:00:00,1,21,0,23,23,014,1000,alive,1,17,23
#124,1940000,792,TCS,172.1.1.21,mode1,12:00:00,1,21,0,23,23,014,1000,alive,1,17,23

#OUTPUT will mach names from first file to 4th colum of second file and if there is a match then 7th colum will be changed.
#124,1940000,792,TATAMOTORS,172.1.1.21,mode1,24:00:00,1,21,0,23,23,014,1000,alive,1,17,23
#124,1940000,792,hello,172.1.1.21,mode1,12:00:00,1,21,0,23,23,014,1000,alive,1,17,23
#124,1940000,792,TCS,172.1.1.21,mode1,24:00:00,1,21,0,23,23,014,1000,alive,1,17,23

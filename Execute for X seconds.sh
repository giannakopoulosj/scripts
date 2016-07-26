
#1h -> 60m -> 12x5m -> 300sec
#5h -> 300m -> 60x5m


for i in {1..60}
do
  echo -ne "$(date)\t hello" >> your_file_here
  cmd >> your_file_here
  sleep 300 #sleep 300sec (5min)
done


#For Old ksh shell (ksh88) use bellow

c=1
while [[ $c -le 60 ]]
do
   echo -ne "$(date)\t" >> your_file_here
   ls -ltr /patern/gose/here/* >> your_file_here
   let c=c+1
   sleep 300 #sleep 300sec (5min)
done

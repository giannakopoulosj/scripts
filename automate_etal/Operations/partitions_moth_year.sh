#/bin/bash

for year in {2019..2021};do
for month in {01..12};do 
#echo "01 - $(cal $month $year | egrep "28|29|30|31" |tail -1 |awk '{print $NF}') $month $year"
mkdir -p /data/$year/$month/
lvcteate -L +1G -n $month_$year datavg
echo "/dev/mapper/datavg-$moth_$year /data/$year/$month/ xfs defaults 0 0" >>/etc/fstab
done
done

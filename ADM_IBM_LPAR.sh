#Alt_root_vg & fix
#check active bootlist
bootlist -m normal -o
#make copy
alt_disk_copy -d hdisk1 -b update_all -l /fixes/DownloadDirector 2>&1 | tee root_vg.log
#clean old copy
alt_disk_install -X altinst_rootvg

#Find MAC
lscfg -vpl ent(X) |grep "Network Address"
entstat -d ent(X) |grep "Hardware Address:"

#Find WWPN/FC
for i in $(lsdev -Cc adapter |grep fcs | awk '{print $1}'); do
echo -n $i; lscfg -vl $i | grep Network
done
#or
pcmpath query wwpn

#Find Disk/SERIAL
pcmpath query device | egrep "DEV|SERIAL"| paste - - | awk '{print $5" "$12}'
#Flush cache systems
vmo -o minperm%=1 -o maxperm%=1 -o strict_maxperm=1 -o maxclient%=1
 
#Restore-----------------------------------------------------------------
vmo -p -o minperm%=3 -o maxperm%=90 -o strict_maxperm=0  -o maxclient%=90

#Delete FCS Defined Adapters
for i in $(lsdev -Ccadapter | grep Defined | grep fcs | awk '{print $1}');do 
    rmdev -dl $i -R
done
#Del en* Defined Adapters
#delete ent, en and et Defined Adapters
for i in $(lsdev -Ccadapter | grep Defined | grep ent| awk '{print $1}'|awk -F't' '{print $2}');do
    rmdev -dl en$i; rmdev -dl ent$i ; rmdev -dl et$i
done

#FSCK all mount points
#!/bin/bash
 
pids="" 
mount_my_fs="rootvg"
 
for my_fs in $(lsvg -l $mount_my_fs | egrep -v ":|MOUNT POINT|N\/A"| awk '{print $7}');do
    fsck -y $my_fs &
    pids+=" $!"
    echo "PID of $my_fs is: $(echo $pids|awk '{print $NF}')"
done
 
 
for p in $pids; do
    if wait $p; then
        echo "Process $p success"
    else
        echo "Process $p fail"
        exit 1
    fi
done

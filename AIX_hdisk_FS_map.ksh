#!/bin/ksh
#THNX @https://www.ibm.com/developerworks/community/blogs/brian/entry/show_which_hdisk_s_each_of_your_filesystems_reside_on_for_aix1

for vg in `lsvg -o`; do 
        for fs in `lsvgfs $vg`; do 
                printf "%-22s" $fs; 
                for disk in `lsvg -p $vg | tail +3 | awk '{print $1}'`; do
                        lspv -l $disk | grep -q " ${fs}$" && printf "%-8s" $disk; 
                done; 
                echo
        done; 
done


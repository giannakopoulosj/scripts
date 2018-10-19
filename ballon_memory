#Ballon memory investigation


#Show balloon memory
vmware-toolbox-cmd stat balloon

# check balloon driver
# vmmemctl->VMware driver 
#vmware_balloon-->RHEL driver
lsmod | grep -E 'vmmemctl|vmware_balloon'


#memory utilization
ps axo user,pcpu,pmem,rss --no-heading | awk '{pCPU[$1]+=$2; pMEM[$1]+=$3; sRSS[$1]+=$4} END {for (user in pCPU) if (pCPU[user]>0 || sRSS[user]>10240) printf "%s:@%.1f%% of total CPU,@%.1f%% of total MEM@(%.2f GiB used)\n", user, pCPU[user], pMEM[user], sRSS[user]/1024/1024}' | column -ts@ | sort -rnk2

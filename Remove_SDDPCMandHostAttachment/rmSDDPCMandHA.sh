#!/bin/ksh
#
#   FUNCTIONS: This script will put Virtual Target Devices to defined state,
#	       unmount file systems and deactivate the volume groups that 
#              are created with SDDPCM devices
#              unmount all corresponding file systems,
#	       remove all the SDDPCM devices, 
#              remove ALL SDDPCM package(s) and SDDPCM FCP and SAS Host Attachment if installed
#
#              This script works on SAN boot or non-SAN boot host
#
#   DEPARTMENT: Multipath Subsystem Device Driver (San Jose, CA)
#
#   ORIGINS: 27
#
#
#   (C) COPYRIGHT International Business Machines Corp. 1998
#   All Rights Reserved
#
#   Licensed Materials - Property of IBM
#
#   US Government Users Restricted Rights - Use, duplication or
#   disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
#
# static char sccsid[] = "@(#)63  1.3  migration/PCM2PCM_OS_SAN/rmSDDPCMandHA.sh, pcm.aix.tools, sddpcm_26xx_aix 7/16/12 04:28:23";

#
#set -xv


DEBUG="./rmSDDPCMandHA.out"
INST_LOG=${DEBUG%.out}.instlog
FILE="./lvm.cfg"
BACKUP="./failed.cfg"

RECORD=1
FORCED_MIGRATION=0

################# function display_usage() ########################
display_usage()
{
  echo "\nUSAGE: $0 [-f]"
  echo "       $0 migrates SDDPCM before an Operating Systems or Virtual I/O Server migration"
  echo "       -f is an optional flag to skip all SDDPCM related device and logical volume migration\n"
  exit -1
}

################# function fail() ########################
fail()
{
   if [ $RECORD -eq 1 ]
   then
        cp $FILE $BACKUP
   fi
   exit 1
}


################# function cleanup_a() ########################
cleanup_a()
{
    trap '' 0 1 2 15

    getlvodm -R
    if [ $? = 0 ]
    then
	savebase  		#save the database to the ipl_device
    fi

    exit $EXIT_CODE
}



################ function validate_vg #####################
#
# Check if this vg is supported for migration
#
validate_vg()
{
#set -xv

VGNAME=$1

#
# Get device names and their pvid's 
#
VGID=$( getlvodm -v $VGNAME 2>/dev/null )
if [[ -z "$VGID" ]] ; then
   return 1
fi

#
# To take care of the worst case where user removed devices and
# forgot to export the associated volume group
#
getlvodm -w $VGID > /dev/null
if [ $? -ne 0 ]; then
   echo "WARNING! One or more physical device(s) for $VGNAME is not found."
   echo "         Configuration for $VGNAME may not be removed completely"
   echo "         and will not be restored. Manually restore $VGNAME if necessary."
   echo "WARNING! One or more physical device(s) for $VGNAME is not found." >> $DEBUG 2>&1
   return 0
else
   PVNMID=$( getlvodm -w $VGID 2>/dev/null )
fi

PVLIST=$( echo "$PVNMID" | awk '{ print $2 }' )
echo "$VGNAME contains following devices and pvids" >> $DEBUG 2>&1
echo "   $PVNMID" >> $DEBUG 2>&1

# Flags for indicating the existence of non-SDDPCM or SDDPCM devices in a volume group
NON_SDD=0
SDD=0
let PV_NUM=0
for pvdev in $PVLIST
do
    let PV_NUM=PV_NUM+1

    is_PCM_device=$( lsdev -Cc disk | awk "/$pvdev /"'&& (/IBM MPIO FC 2105/ || /IBM MPIO FC 2107/ || /IBM MPIO FC 1750/ || /SAN Volume Controller MPIO Device/ || /MPIO FC 2145/ || /IBM MPIO DS/  || /IBM MPIO SAS 1820/ )' )
    if [ -z "$is_PCM_device" ]
    then
        NON_SDD=1
    else
        SDD=1
    fi
done

#
# Compare number of physical device and number of pvid returned by getlvodm
# to check if some/all physical devices are mistakenly deleted (AIX 5.2 only)
#
PVID_NUM=$( echo "$PVNMID" | awk '{ print $2 }' | wc -l )
if [ $PV_NUM -ne $PVID_NUM ]; then
   echo "WARNING! One or more physical device(s) for $VGNAME is not found."
   echo "         Configuration for $VGNAME may not be removed completely"
   echo "         and will not be restored. Manually restore $VGNAME if necessary."
   echo "WARNING! One or more physical device(s) for $VGNAME is not found." >> $DEBUG 2>&1
   return 0
fi

if [ $SDD -eq 0 ]; then
    echo "$VGNAME is not created with any SDDPCM devices. Skip!" >> $DEBUG 2>&1
    return 0
else
    if [ $NON_SDD -eq 0 ]; then
	echo "$VGNAME is created with SDDPCM devices only. Continue..." >> $DEBUG 2>&1
	migrate_vg $VGNAME
	if [ $? = 0 ]; then
	   return 0
	else
	   return 1
	fi
    else
	echo "\n\n$VGNAME has a mixed of SDDPCM and non-SDDPCM devices." >> $DEBUG 2>&1
	echo "\n\n$VGNAME is not saved. $VGNAME needs manual migration.\n" >> $DEBUG 2>&1
	echo "\n\n$VGNAME has a mixed of SDDPCM and non-SDDPCM devices."
	echo "\n\n$VGNAME is not saved. $VGNAME needs manual migration.\n"
	return 1
    fi
fi
}


################ function migrate_vg ######################
#
# 
#

migrate_vg()
{

VGNAME=$1

echo "\n\nRECORD = $RECORD" >> $DEBUG 2>&1

#
# Denote the beginning of the information of a volume group
# Serves as a delimiator between volume groups
#
if [ $RECORD -eq 1 ]
then
   echo "VOLUME_GROUP" >> $FILE
   echo "===============" >> $FILE
fi

#
# Collect information on characteristics of the volume group
#
VG_CHAR="$VGNAME"
VARYON="true"


#
# Check whether the volume group is initially varied on
#
date >> $DEBUG 2>&1
if lsvg -o | egrep -x "$VGNAME" >> $DEBUG 2>&1
then
   VG_CHAR="$VG_CHAR\tvaryon"
   
    #
    # Check if the volume group is CONCURRENT_VOLUME_GROUP
    #
    vgtype=$(odmget -q "value=$VGNAME" HACMPresource 2>/dev/null |
                egrep name |
                awk '{print $3}' |
                sed -e 's/"//g' )

    if [ -n "$vgtype" ]; then
        echo "vgtype=$vgtype" >> $DEBUG 2>&1
    fi

    if [ "$vgtype" != "CONCURRENT_VOLUME_GROUP" ] ; then
       # Just an ordinary volume group
       VG_CHAR="$VG_CHAR\tnonconcurrent"
    else
        if [ $(lqueryvg -g $(getlvodm -v $VGNAME) -C) -eq 1 ]; then
            # The volume group is defined as enhanced concurrent mode
            VG_CHAR="$VG_CHAR\tenhance"
        else
            # The volume group is not enhance concurrent, but used
            # in concurrent fashion
            VG_CHAR="$VG_CHAR\tconcurrent"
        fi
    fi

else
   VARYON="false"
   VG_CHAR="$VG_CHAR\tvaryoff\t\t"
fi

if [ $RECORD -eq 1 ]
then
   echo $VG_CHAR >> $FILE
fi

# If the volume group is varied on, check for paging space and file system

if [ "$VARYON" = "true" ]
then
    #
    # Check if any file systems are still mounted on the volume group
    # of if any logical volumes are open
    #
    VGFS=$( lsvgfs $VGNAME )

    if [ -n "$VGFS" ]
    then
	if [ $RECORD -eq 1 ]
	then
	    echo "FILE_SYSTEM: " >> $FILE
	fi
    fi

    #
    # A flag to indicate whether "umount" has
    # ever failed
    #
    UNMOUNT_FAILED=0
 
    for vgfs in $VGFS ; do
	VGMTFS="unmount"
	MOUNTFS=$( mount | grep $vgfs  | awk '{ print $2 }')
	for mountfs in $MOUNTFS ; do
	    if [ "$vgfs" = "$mountfs" ] ; then
		VGMTFS="mount"
		date >> $DEBUG 2>&1
		if umount $vgfs >> $DEBUG 2>&1
		then
		    echo "$vgfs for $VGNAME is unmounted successfully!" >> $DEBUG 2>&1
		    echo "$vgfs for $VGNAME is unmounted successfully!" 
		else
		    echo "\n\nError, Cannot unmount $vgfs\n" >> $DEBUG 2>&1
		    echo "\n\nError, Cannot unmount $vgfs\n" 
		    UNMOUNT_FAILED=1
		fi 
	    fi
	done
 
	if [ $RECORD -eq 1 ]
	then
	    echo "$vgfs\t\t$VGMTFS" >> $FILE
	fi
    done

    if [ $RECORD -eq 1 ]
    then
	echo "" >> $FILE
    fi

    #
    # Check if any ACTIVE paging space is created with this volume group
    #
    VGPS=$( lsps -a | grep $VGNAME | awk '{ print $6 }')

    for vgps in $VGPS; do
        # Check whether paging space is active
        if [ "$vgps" = "yes" ]
        then
            echo "\n\nError, $VGNAME has an active paging space." >> $DEBUG 2>&1
            echo "\n\nError, $VGNAME has an active paging space."
            echo "Deactivate the active paging space before running migration." >> $DEBUG 2>&1
            echo "Deactivate the active paging space before running migration."
            return 1
        fi
    done

    #
    # If "umount" failed
    #
    if [ $UNMOUNT_FAILED -eq 1 ]
    then
	return 1
    fi

    #
    # Vary off SDDPCM volume group
    #
    date >> $DEBUG 2>&1
    if /usr/sbin/varyoffvg $VGNAME >> $DEBUG 2>&1
    then
	echo "$VGNAME is varied off successfully!" >> $DEBUG 2>&1
	echo "$VGNAME is varied off successfully!" 
    else
	echo "\n\nError, Cannot varyoffvg $VGNAME\n" >> $DEBUG 2>&1
	echo "\n\nError, Cannot varyoffvg $VGNAME\n"
	return 1
    fi
fi # End if for if [ "$VARYON" = "true" ]

return 0
}

########################################################
# function vrmfcmp()
# vrmfcmp vrmf1 vrmf2
# return:
# 1 - vrmf1 is lower than vrmf2
# 2 - vrmf1 is higher or equal to vrmf2
vrmfcmp()
{
V1=`echo $1 |awk -F "." '{print $1}'`
R1=`echo $1 |awk -F "." '{print $2}'`
M1=`echo $1 |awk -F "." '{print $3}'`
F1=`echo $1 |awk -F "." '{print $4}'`

V2=`echo $2 |awk -F "." '{print $1}'`
R2=`echo $2 |awk -F "." '{print $2}'`
M2=`echo $2 |awk -F "." '{print $3}'`
F2=`echo $2 |awk -F "." '{print $4}'`


if [ "$V1" -lt "$V2" ]; then
return 1
elif [ "$V1" -gt "$V2" ]; then
return 2
elif [ "$R1" -lt "$R2" ]; then
return 1
elif [ "$R1" -gt "$R2" ]; then
return 2
elif [ "$M1" -lt "$M2" ]; then
return 1
elif [ "$M1" -gt "$M2" ]; then
return 2
elif [ "$F1" -lt "$F2" ]; then
return 1
elif [ "$F1" -gt "$F2" ]; then
return 2
else
return 2
fi
}
##################################   main   ################################
# 
#

echo "****************************************************************************************"
echo
echo "      Checking prerequisites of this script to deinstall SDDPCM and Host Attachment"
echo
echo "****************************************************************************************"

#
# This script needs to be executed by super user
#
user=`whoami`
MYNAME=`basename $0`
if [ "$user" != "root" ]; then
    echo "You have to be a super user to run $MYNAME"
    exit 1
fi

#
# Trap on exit/interrup/break to clean up
#
trap 'cleanup_a' 0 1 2 15

#
# Make sure we have enough space in / and /tmp directory before
# attempting conversion.
#
fspc=`df -k / 2>/dev/null | egrep "/" | awk '{ print $3 }'`
if [ $fspc -lt 40 ] ; then
    echo "\n\nError, Insufficient free space in / filesystem\n" >> $DEBUG 2>&1
    echo "\n\nError, Insufficient free space in / filesystem\n"
    exit 1
fi
fspc=`df -k /tmp 2>/dev/null | egrep "/tmp" | awk '{ print $3 }'`
if [ $fspc -lt 40 ] ; then
    echo "\n\nError, Insufficient free space in /tmp filesystem\n" >> $DEBUG 2>&1
    echo "\n\nError, Insufficient free space in /tmp filesystem\n"
    exit 1
fi

#
# Find out the oslevel
#
OS=$(oslevel -r | awk '{ printf("%s",substr($1,1,2)) }')
if [ $? != 0 ]
then
        echo "oslevel: failed to get OS level of host system" >> $DEBUG 2>&1
        echo "oslevel: failed to get OS level of host system"
        echo "please fix the problem and re-run this script"
        exit 1
fi


#
# Check whether the backup file exists, if it exists,
# stop recording the current LVM conifguration 
# 
ls -la $BACKUP >> $DEBUG 2>&1
if [ $? = 0 ]; then
   RECORD=0
fi

#
# Clean up the debug file so that it will
# not keep increasing in size
#
ls -la $DEBUG >> /dev/null 2>&1
if [ $? = 0 ]; then
    /usr/bin/rm $DEBUG
fi
/usr/bin/touch $DEBUG

#
# Save host data
#
set -A cmds "pcmpath query device" "lspv" "lsdev -Cc disk" "bootlist -m normal -o" "lspath" "df" "ls -i /dev/ipldevice" "odmget PdPathAt" "/usr/ios/cli/ioscli lsmap -all" "oslevel -s"
y=0
while [ $y -lt 10 ]
do
    echo "***************************************" >> $DEBUG 2>&1
    echo ${cmds[$y]} >> $DEBUG 2>&1
    ${cmds[$y]} >> $DEBUG 2>&1
    (( y=y+1 ))
done

#
# Release scsi-2 reserve on boot devices in case it was not released before
#
if relbootrsv >> $DEBUG 2>&1
then
    echo "relbootrsv completed successfully" >> $DEBUG 2>&1
else
    echo "relbootrsv failed! rc=$?" >> $DEBUG 2>&1
fi
echo "\n\n****************************************************************************************"
echo
echo "      Starting deinstall SDDPCM and Host Attachment" 
echo
echo "****************************************************************************************"

#
# Save current ODMDIR
#
OLDODMDIR=$ODMDIR
ODMDIR=/etc/objrepos
export ODMDIR

#
# Remove the previous record file
#
ls -la $FILE >> $DEBUG 2>&1
if [ $? = 0 ]; then
    /usr/bin/rm $FILE
fi
/usr/bin/touch $FILE

#
# Initialize variables used
#
FAILED=0
VGVARYON=0
EXIT_CODE=1

############################################## Beginning of -f #################################################################################
#
# If FORCED_MIGRATION is not set, continue, else, skip all the configuration removal process
#
if [ $FORCED_MIGRATION -eq 0 ] 
then

#
# Put all the Virtual Target Devices to Defined
#
date >> $DEBUG 2>&1
VTDS=$( lsdev | awk '/Virtual Target Device/ {print $1}' )
for VTD in $VTDS ; do
	rmdev -l $VTD >> $DEBUG 2>&1
	if [ $? = 0 ]; then
	   echo "Virtual target device $VTD is put to Defined state"
	else
	   Banner "ERROR"
	   echo "Failed to put virtual target device $VTD to Defined state" >> $DEBUG 2>&1
	   echo "Failed to put virtual target device $VTD to Defined state"
	   echo "Make sure you have disabled the path to this VIO Server on the VIO Client before the migration then re-run this script"
	   exit 1
	fi
done

#
# Umount file systems and varyoff volume groups
#
date >> $DEBUG 2>&1
for VGS in `lsvg` ; do
    if [ "$VGS" != "rootvg" ]; then
	validate_vg $VGS
	if [ $? = 0 ]; then
           echo "Configuration of $VGS is saved and removed successfully!\n" >> $DEBUG 2>&1
        elif [ $? = 1 ]; then
	   echo "\n\nError, configuration of $VGS may not be removed completely\n" >> $DEBUG 2>&1
           echo "\n\nError, configuration of $VGS may not be removed completely\n"
           FAILED=1
	elif [ $? = 2 ]; then
	   echo "Skipped $VGS" >> $DEBUG 2>&1
        fi
    fi
done

#
# If there is any failing during the umount
# or varyoffvg or etc, save the lvm config
# file to a backup file and exit
#
if [ $FAILED -eq 1 ]
then
    fail
fi

#
# If migration was successful, continue and 
# check whether SDDPCM Server is active, 
# if so, stop it
# Added checking for TPC/IP port
#

#Check if pcmsrv is respawned in /etc/inittab
if [[ -n "$( cat /etc/inittab | grep pcmsrv | grep respawn )" ]]; then
     echo "remove pcmsrv respawn entry in inittab" >> $DEBUG 2>&1
     rmitab "srv"
     telinit q
fi

SERVER="inactive"

if LANG=C lssrc -s pcmsrv | grep -iqw active
then
   SERVER="stopsrc -f -s pcmsrv"
elif [[ -n "$( ps -ef | grep -v grep | grep /usr/sbin/pcmsrv )" ]]
then
   echo "Subsystem pcmsrv is not active but /usr/sbin/pcmsrv process is running" >> $DEBUG 2>&1
   SERVER="kill -15 $(ps -ef | grep -v grep | grep /usr/sbin/pcmsrv | awk '{print $2}')"
fi

echo "SERVER=$SERVER" >> $DEBUG 2>&1
if [ "$SERVER" != "inactive" ]
then
WAIT=0
   date >> $DEBUG 2>&1
   if $SERVER >> $DEBUG 2>&1
   then
      #
      # Even if stopsrc or kill command was successful,
      # we still need to check whether pcmsrv is really
      # stopped or hanging there (i.e. with the Status
      # of "stopping"
      #
      while [[ $WAIT -lt 30 ]]
      do
         if [[ -n "$( ps -ef | grep -v grep | grep /usr/sbin/pcmsrv )" ]]
         then
            #
            # If it is not completely stopped, give it a
            # some more time
            #
	    sleep 1
            let WAIT=WAIT+1
            echo "WAIT $WAIT second..." >> $DEBUG 2>&1
         else
            #
            # Set WAIT to a value larger than 30
            #
            WAIT=31
            echo "pcmsrv has successfully stopped!" >> $DEBUG 2>&1
         fi
      done
      #
      # If WAIT=30, that means after 30 seconds, pcmsrv is still not stopped.
      # kill the pcmsrv daemon manually, if the TCP/IP port is enabled.
      #
      if [[ $WAIT -eq 30 ]]
      then
                # if tcp/ip port is opened, we should kill the pcmsrv daemon
                grep "^enableport" /etc/pcmsrv.conf | grep -i true
                if [[ $? -eq 0 ]]
                then
                        SDDSRVPIDQUERY=`ps -ef |  grep -v grep | grep /usr/sbin/pcmsrv | awk '{print $2}'`
                        [ "$SDDSRVPIDQUERY" ] && kill -15 $SDDSRVPIDQUERY
			echo "TPC/IP port is opened" >> $DEBUG 2>&1
                fi
                #
                # Wait for MAX 30 seconds to allow pcmsrv shutdown gracefully
                #
                WAIT=0
                while [[ $WAIT -lt 30 ]]
                do
                        if [[ -n "$( ps -ef |  grep -v grep | grep /usr/sbin/pcmsrv)" ]]
                        then
                                # If it is not completely stopped, give it
                                # some more time
                                sleep 1
                                let WAIT=WAIT+1
                        else
                                # pcmsrv stopped successfully, so we can restart it
                                # also set WAIT to a value larger than 30 to end loop
                                WAIT=31
                        fi
                done
                #
                # If WAIT=30, that means after 60 seconds, pcmsrv is still not
                # stopped. Notify user to check the status of pcmsrv daemon and
                # stop it
                #
                if [[ $WAIT -eq 30 ]]
                then
			date >> $DEBUG 2>&1
                        banner "Warning"
                        print "pcmsrv process did not stop within the allotted time." >> $DEBUG 2>&1
                        print "pcmsrv process did not stop within the allotted time."
                        print "Run 'lssrc -s pcmsrv' to check if the process "
                        print "becomes inactive and then re-run this script.\n\n"
                        fail
                fi
        fi
   else
      echo "\n\nError, $SERVER failed\n" >> $DEBUG 2>&1
      echo "\n\nError, $SERVER failed\n"
      fail
   fi
fi
 
 
#
# Remove SDDPCM devices.
# First check whether SDDPCM device is present, if so, remove
# them.
#
VPSTATE=$( lsdev -Cc disk |  awk '(/IBM MPIO FC 2105/ || /IBM MPIO FC 2107/ || /IBM MPIO FC 1750/ || /SAN Volume Controller MPIO Device/ || /MPIO FC 2145/ || /IBM MPIO DS/ || /IBM MPIO SAS 1820/ ) && /Available/ { print $2 }' | sort -u )

if [ "$VPSTATE" = "Available" ]
then
   date >> $DEBUG 2>&1

   SAN_HDISKS=$(lsvg -p rootvg | grep active | awk '{print $1}' | sort -u)

   echo "List of SAN boot devices:" >> $DEBUG 2>&1
   echo $SAN_HDISKS >> $DEBUG 2>&1

   #
   # Append a delimiter
   #
   PCM_HDISKS="$(lsdev -Cc disk |  awk '(/IBM MPIO FC 2105/ || /IBM MPIO FC 2107/ || /IBM MPIO FC 1750/ || /SAN Volume Controller MPIO Device/ || /MPIO FC 2145/ || /IBM MPIO DS/ || /IBM MPIO SAS 1820/ ) && /Available/ { print $1 }' | sort -u) EOF"

   echo "List of PCM devices:" >> $DEBUG 2>&1
   echo $PCM_HDISKS >> $DEBUG 2>&1

   for san_hdisk in $SAN_HDISKS
   do
	echo "**** pcmquerypr -Vh /dev/$san_hdisk ****" >> $DEBUG 2>&1
	pcmquerypr -Vh /dev/$san_hdisk >> $DEBUG 2>&1
	echo "**** ls -i /dev/r$san_hdisk ****" >> $DEBUG 2>&1
	ls -i /dev/r$san_hdisk >> $DEBUG 2>&1
        echo "san_hdisk=$san_hdisk"
        PCM_HDISKS=$( echo $PCM_HDISKS | sed "s/$san_hdisk / /" )
   done

   echo "List of NON-SAN PCM devices (Before removing delimiter):" >> $DEBUG 2>&1
   echo $PCM_HDISKS >> $DEBUG 2>&1

   #
   # Remove the delimiter
   #
   PCM_HDISKS=$( echo $PCM_HDISKS | sed "s/EOF/ /" )
   echo "List of NON-SAN PCM devices (After removing delimiter):" >> $DEBUG 2>&1
   echo $PCM_HDISKS >> $DEBUG 2>&1

   for hdisk in $PCM_HDISKS
   do
        if rmdev -dl $hdisk >> $DEBUG 2>&1
	then
	    echo "$hdisk removed successfully" 
	else
	    echo "$hdisk fails to remove" >> $DEBUG 2>&1
	    echo "$hdisk fails to remove" 
	    fail
	fi
   done
fi

date >> $DEBUG 2>&1

#
# All operations are performed successfully
# If backup file does exist (i.e. this script
# failed before, remove this file
#
if [ $RECORD -eq 0 ]; then
    cp $BACKUP $FILE
    /usr/bin/rm $BACKUP
fi

# 
# do tricky thing with ODM so that we can remove SDDPCM package 
# without removing the active SAN boot devices
#
odmget -q "PdDvLn like disk/fcp/2105*" CuDv | sed "s/\"disk\/fcp\/2105.*\"/\"disk\/fcp\/mpioosdisk\"/">./2105cudv.out
odmdelete -q "PdDvLn like disk/fcp/2105*" -o CuDv
odmadd ./2105cudv.out

odmget -q "PdDvLn like disk/fcp/2107*" CuDv | sed "s/\"disk\/fcp\/2107.*\"/\"disk\/fcp\/mpioosdisk\"/">./2107cudv.out
odmdelete -q "PdDvLn like disk/fcp/2107*" -o CuDv
odmadd ./2107cudv.out

odmget -q "PdDvLn like disk/fcp/1750*" CuDv | sed "s/\"disk\/fcp\/1750.*\"/\"disk\/fcp\/mpioosdisk\"/">./1750cudv.out
odmdelete -q "PdDvLn like disk/fcp/1750*" -o CuDv
odmadd ./1750cudv.out

odmget -q "PdDvLn like disk/fcp/2145*" CuDv | sed "s/\"disk\/fcp\/2145.*\"/\"disk\/fcp\/mpioosdisk\"/">./2145cudv.out
odmdelete -q "PdDvLn like disk/fcp/2145*" -o CuDv
odmadd ./2145cudv.out

odmget -q "PdDvLn like disk/fcp/DS4100*" CuDv | sed "s/\"disk\/fcp\/DS4100.*\"/\"disk\/fcp\/mpioapdisk\"/">./DS4100cudv.out
odmdelete -q "PdDvLn like disk/fcp/DS4100*" -o CuDv
odmadd ./DS4100cudv.out

odmget -q "PdDvLn like disk/fcp/DS4200*" CuDv | sed "s/\"disk\/fcp\/DS4200.*\"/\"disk\/fcp\/mpioapdisk\"/">./DS4200cudv.out
odmdelete -q "PdDvLn like disk/fcp/DS4200*" -o CuDv
odmadd ./DS4200cudv.out

odmget -q "PdDvLn like disk/fcp/DS4300*" CuDv | sed "s/\"disk\/fcp\/DS4300.*\"/\"disk\/fcp\/mpioapdisk\"/">./DS4300cudv.out
odmdelete -q "PdDvLn like disk/fcp/DS4300*" -o CuDv
odmadd ./DS4300cudv.out

odmget -q "PdDvLn like disk/fcp/DS4500*" CuDv | sed "s/\"disk\/fcp\/DS4500.*\"/\"disk\/fcp\/mpioapdisk\"/">./DS4500cudv.out
odmdelete -q "PdDvLn like disk/fcp/DS4500*" -o CuDv
odmadd ./DS4500cudv.out

odmget -q "PdDvLn like disk/fcp/DS4700*" CuDv | sed "s/\"disk\/fcp\/DS4700.*\"/\"disk\/fcp\/mpioapdisk\"/">./DS4700cudv.out
odmdelete -q "PdDvLn like disk/fcp/DS4700*" -o CuDv
odmadd ./DS4700cudv.out

odmget -q "PdDvLn like disk/fcp/DS4800*" CuDv | sed "s/\"disk\/fcp\/DS4800.*\"/\"disk\/fcp\/mpioapdisk\"/">./DS4800cudv.out
odmdelete -q "PdDvLn like disk/fcp/DS4800*" -o CuDv
odmadd ./DS4800cudv.out

odmget -q "PdDvLn like disk/fcp/DS4900*" CuDv | sed "s/\"disk\/fcp\/DS4900.*\"/\"disk\/fcp\/mpioapdisk\"/">./DS4900cudv.out
odmdelete -q "PdDvLn like disk/fcp/DS4900*" -o CuDv
odmadd ./DS4900cudv.out

odmget -q "PdDvLn like disk/fcp/DS5100*" CuDv | sed "s/\"disk\/fcp\/DS5100.*\"/\"disk\/fcp\/mpioapdisk\"/">./DS5100cudv.out
odmdelete -q "PdDvLn like disk/fcp/DS5100*" -o CuDv
odmadd ./DS5100cudv.out

odmget -q "PdDvLn like disk/fcp/DS5300*" CuDv | sed "s/\"disk\/fcp\/DS5300.*\"/\"disk\/fcp\/mpioapdisk\"/">./DS5300cudv.out
odmdelete -q "PdDvLn like disk/fcp/DS5300*" -o CuDv
odmadd ./DS5300cudv.out

odmget -q "PdDvLn like disk/fcp/DS5000*" CuDv | sed "s/\"disk\/fcp\/DS5000.*\"/\"disk\/fcp\/mpioapdisk\"/">./DS5000cudv.out
odmdelete -q "PdDvLn like disk/fcp/DS5000*" -o CuDv
odmadd ./DS5000cudv.out

odmget -q "PdDvLn like disk/fcp/DS3950*" CuDv | sed "s/\"disk\/fcp\/DS3950.*\"/\"disk\/fcp\/mpioapdisk\"/">./DS3950cudv.out
odmdelete -q "PdDvLn like disk/fcp/DS3950*" -o CuDv
odmadd ./DS3950cudv.out

odmget -q "PdDvLn like disk/sas/1820*" CuDv | sed "s/\"disk\/sas\/1820.*\"/\"disk\/sas\/mpioosdisk\"/">./1820cudv.out
odmdelete -q "PdDvLn like disk/sas/1820*" -o CuDv
odmadd ./1820cudv.out

odmget -q "PdDvLn like disk/fcp/DS5020*" CuDv | sed "s/\"disk\/fcp\/DS5020.*\"/\"disk\/fcp\/mpioapdisk\"/">./DS5020cudv.out
odmdelete -q "PdDvLn like disk/fcp/DS5020*" -o CuDv
odmadd ./DS5020cudv.out

echo "**** After ODM change ****" >> $DEBUG 2>&1
lsdev -Cc disk >> $DEBUG 2>&1

fi
# If FORCED_MIGRATION is not set. This is end of all configuration removal process. 
############################################## End of -f #####################################################################################

#
# deinstall SDDPCM package for AIX 52, AIX 53, AIX 61, and AIX 71 if installed
#
for OS in 52 53 61 71
do
    lslpp -l devices.sddpcm.$OS.rte > /dev/null 2>&1 
    if [ $? == 0 ]
    then
       echo "\n\n***************************************************************" >> $DEBUG 2>&1
       echo "deinstallation of devices.sddpcm.$OS.rte  package" >> $DEBUG 2>&1
       echo "***************************************************************" >> $DEBUG 2>&1
       echo "deinstallation of devices.sddpcm.$OS.rte  package" 
       installp -ug devices.sddpcm.$OS.rte >$INST_LOG 2>&1
       installp_ret_code=$?
       cat $INST_LOG | tee -a $DEBUG
       if [ $installp_ret_code != 0 ]
       then
           banner "ERROR"
           echo "deinstallation of devices.sddpcm.$OS.rte failed" >> $DEBUG 2>&1
           echo "deinstallation of devices.sddpcm.$OS.rte failed"
           echo "please fix the problem and then re-run this script"
          fail
       fi
    fi
done

#
# deinstall devices.fcp.disk.ibm.mpio.rte
#
lslpp -l devices.fcp.disk.ibm.mpio.rte  >/dev/null 2>&1 
if [ $? == 0 ]
then
   echo "\n\n***************************************************************" >> $DEBUG 2>&1
   echo "deinstallation of devices.fcp.disk.ibm.mpio.rte package" >> $DEBUG 2>&1
   echo "***************************************************************" >> $DEBUG 2>&1
   echo "deinstallation of devices.fcp.disk.ibm.mpio.rte package" 
   installp -ug devices.fcp.disk.ibm.mpio.rte >$INST_LOG 2>&1
   installp_ret_code=$?
   cat $INST_LOG | tee -a $DEBUG
   if [ $installp_ret_code != 0 ]
   then
        banner "ERROR"
        echo "deinstallation of devices.fcp.disk.ibm.mpio.rte failed" >> $DEBUG 2>&1
        echo "deinstallation of devices.fcp.disk.ibm.mpio.rte failed"
        echo "please fix the problem and then restart this script"
        fail
   fi
fi

#
# deinstall devices.sas.disk.ibm.mpio.rte
#
lslpp -l devices.sas.disk.ibm.mpio.rte >/dev/null 2>&1 
if [ $? == 0 ]
then
   echo "\n\n***************************************************************" >> $DEBUG 2>&1
   echo "deinstallation of devices.fcp.disk.ibm.mpio.rte package" >> $DEBUG 2>&1
   echo "***************************************************************" >> $DEBUG 2>&1
   echo "deinstallation of devices.sas.disk.ibm.mpio.rte package" >> $DEBUG 2>&1
   echo "deinstallation of devices.sas.disk.ibm.mpio.rte package" 
   installp -ug devices.sas.disk.ibm.mpio.rte >$INST_LOG 2>&1
   installp_ret_code=$?
   cat $INST_LOG | tee -a $DEBUG
   if [ $installp_ret_code != 0 ]
   then
        banner "ERROR"
        echo "deinstallation of devices.sas.disk.ibm.mpio.rte failed" >> $DEBUG 2>&1
        echo "deinstallation of devices.sas.disk.ibm.mpio.rte failed"
        echo "please fix the problem and then restart this script"
        fail
   fi
fi

#
# Save data after all the installations
#
date >> $DEBUG 2>&1
lslpp -l | grep devices.sddpcm >> $DEBUG 2>&1
lslpp -l | grep devices.fcp.disk.ibm.mpio.rte >> $DEBUG 2>&1
lslpp -l | grep devices.sas.disk.ibm.mpio.rte >> $DEBUG 2>&1

#
# bosboot and sync 
#
bosboot -ad /dev/ipldevice 2>&1 | tee -a $DEBUG 
if [ $? != 0 ]
then
    banner "ERROR"
    echo "bosboot failed" >> $DEBUG 2>&1
    echo "bosboot failed"
    echo "Please fix the bosboot problem before reboot system"
    fail
fi

sync; sync; sync

echo "\n\n"
banner "ATTENTION"
echo "Script completed successfully!"
echo "Please verify all installed SDDPCM and SDDPCM Host Attachment packages are de-installed"
echo "by running the following commands"
echo "    lslpp -l | grep sddpcm"
echo "    lslpp -l devices.sas.disk.ibm.mpio.rte" 
echo "    lslpp -l devices.fcp.disk.ibm.mpio.rte"
echo 
echo "    The following packages should NOT be installed"
echo "    devices.sddpcm.*.rte"              
echo "    devices.fcp.disk.ibm.mpio.rte"
echo "    devices.sas.disk.ibm.mpio.rte"
echo "\nAfter verification, you can either"
echo "1. proceed to install appropriate SDDPCM and SDDPCM Host Attachment packages"
echo "              OR"
echo "2. reboot the system to switch to native AIX PCM"


EXIT_CODE=0
exit 0


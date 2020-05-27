rmSDDPCMandHA script de-install all installed SDDPCM and SDDPCM Host Attachment packages 
from AIX machine with AIX5.2, AIX5.3, AIX6.1, or AIX7.1 OS installed or from VIO server

                               Version 1.2                				

                               Mar 2, 2011


Purpose
_______

Script rmSDDPCMandHA.sh can be used to remove SDDPCM and SDDPCM Host Attachment
packages for the following scenarios. The script supports AIX machine or VIOS
booting from internal disk or SAN boot disk for all SDDPCM supported storage types. 


1. To recover AIX Operating Systems or Virtual I/O Server after OS migration without
   migrating SDDPCM for the new OS level. For SDDPCM supported SAN boot AIX system or
   Virtual I/O sever, mismateched SDDPCM package should be removed or migrated to the
   version matching to the new OS. Otherwise, the rootvg device(s) will be 
   managed by mismatched SDDPCM driver. This script allows customer to remove the
   mismatched SDDPCM and Host Attachment packages and then update the SDDPCM and 
   Host Attachment packages if the aforementioned procedure was not followed.

2. To downlevel SDDPCM Host Attachment or re-install same SDDPCM Host Attachment 
   e.g. to downlevel SDDPCM FCP Host Attachment from version 2.0.0.1 to version 
        1.0.0.21

3. To de-install SDDPCM and SDDPCM Host Attachment packages to switch to native
   AIX PCM


Script Description
___________________

rmSDDPCMandHA.sh script will automatically:
     1. Put all the virtual target devices in Defined state
     2. Unmount file systems and deactivate the volume groups that are created with 
        SDDPCM devices
     3. Remove all the SDDPCM devices
     4. Stop the SDDPCM server
     5. de-install all SDDPCM and all SDDPM Host Attachment packages
        Note: 
        a. if machines have multiple SDDPCM packages for different OS levels
           installed by mistakes, the script will de-install all the SDDPCM packages
        b. the script de-installs both SDDPCM FCP and/or SAS Host Attachment
           packages if installed



Detail procedures
__________________

Steps to be taken before running the script 
        a) If running dual VIOS, the paths to this VIOS on the VIO Clients are already
           put to Defined with "rmdev -l vscsi# -R" command. If running single VIOS,
           VIO Clients are already shutdown
        b) If running HACMP or other clustering software, it should be
           gracefully shutdown and volume groups are not reserved by any hosts
        c) Host system is not running SANFS
        d) All applications on host system are stopped
        e) Host system can be rebooted if required



Scenario 1
   To recover AIX Operating Systems or Virtual I/O Server after OS migration without
   migrating SDDPCM for the new OS level and install appropriate SDDPCM and SDDPCM
   Host Attachment packages

       a) Create a directory /usr/sys/inst.images/Update_SDDPCM
       b) Copy rmSDDPCMandHA.sh into the
          /usr/sys/inst.images/Update_SDDPCM directory and change the
          permissions of the script files to allow execution
       c) Copy the appropriate SDDPCM Host Attachment and SDDPCM packages
          into the same directory
       d) Run rmSDDPCMandHA.sh
          *** Important: Do not reboot the system. ***
       e) After the script is successfully run, verify SDDPCM and Host Attachment
          packages are de-installed successfully by the following commands
            i. "lslpp -l | grep sddpcm" 
           Ii. "lslpp -l devices.fcp.disk.ibm.mpio.rte"
           Iii."lslpp -l devices.sas.disk.ibm.mpio.rte" 
          
	  The following packages should NOT be installed
               devices.sddpcm.*.rte 
               devices.fcp.disk.ibm.mpio.rte
               devices.sas.disk.ibm.mpio.rte
                                
       f) If your system is booting from SAN disk, run "lsdev -Cc disk" to check if
          your SAN disk is now displayed as "MPIO Other FC SCSI Disk Drive" or
          "MPIO other SAS IBM 1820 Disk".
       g) Install SDDPCM and SDDPCM Host Attachment packages
       h) After install SDDPCM and SDDPCM Host Attachment packages successfully,
          reboot the host
       i) When host system comes back from the reboot, check that all
          hdisks are configured as "IBM MPIO FC 2105" or "IBM MPIO FC 2107"
          or "SAN Volume Controller MPIO Device" or "MPIO FC 2145" or "IBM DS*"
          or "IBM MPIO SAS 1820" from the output of "lsdev -Cc disk"


Scenario 2
   To downlevel SDDPCM Host Attachment or re-install same SDDPCM Host Attachment 
      Follow the same procedure listed in Scenario 1



Scenario 3
   To de-install SDDPCM and SDDPCM host attachment packages to switch to native AIX PCM
       a) Create a directory /usr/sys/inst.images/Update_SDDPCM.
       b) Copy rmSDDPCMandHA.sh into the
          /usr/sys/inst.images/Update_SDDPCM directory and change the
          permissions of the script files to allow execution.
       c) Run rmSDDPCMandHA.sh
       d) After the script is successfully run, verify SDDPCM and Host Attachment
          packages are de-installed successfully as described in Scenario 1 step e
       e) If your system is booting from SAN disk, run "lsdev -Cc disk" to check if
          your SAN disk is now displayed as "MPIO Other FC SCSI Disk Drive" or
          "MPIO other SAS IBM 1820 Disk".
       f) reboot the system
       g) When host system comes back from the reboot, check that all
          hdisks are configured by native AIX PCM from the output of "lsdev -Cc disk"

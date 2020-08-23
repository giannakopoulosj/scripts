#!/bin/bash
# utilitymenu.sh - A sample shell script to display menus on screen
# Store menu options selected by the user
INPUT=/tmp/menu_test.sh.$$
MENUPROD=/usr/bin/menu_prod.sh
# Storage file for displaying cal and date command output
OUTPUT=/tmp/output.sh.$$ 
NAME=$(/bin/hostname)
# trap and delete temp files
trap "rm $OUTPUT; rm $INPUT; exit" SIGHUP SIGINT SIGTERM

function setpxy(){
/usr/bin/pxy.sh
}
#
# set infinite loop
#
while true
do
### display main menu ###
dialog --clear --nocancel --backtitle "MySystem - SYSTEM NAME: $NAME" \
--title "[ SWS - M A I N - M E N U - T E S T]" \
--menu "Please select an action" 17 80 10 \
1Register "Register for automatic updates" \
2Config "Config networking and password" \
3Update "Install updates" \
4Proxy "Config a NTLM proxy" \
5Restart_jboss "Restart jboss service" \
6Restart_osad "Restart osad service" \
7Reboot "Restart the system" \
8Shutdown "Shutdown the system" \
9Logout "Logout from console" \
10Exit "Exit to shell" 2>"${INPUT}" 
menuitem=$(<"${INPUT}")
 
 
# make decsion 
case $menuitem in
	1Register) register;;
	2Config) setpar;;
	3Update) update;;
	4Proxy) setpxy;;
	5Restart_jboss) jrestart;;
	6Restart_osad) orestart;;
	7Reboot) reboot;;
	8Shutdown) shut;;
	9Logout) logout;;
	10Exit) echo "Bye"; break;;
esac
 
done
 
# if temp files found, delete em
[ -f $OUTPUT ] && rm $OUTPUT
[ -f $INPUT ] && rm $INPUT

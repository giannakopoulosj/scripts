#!/bin/bash

DATE=$(date +"%Y/%m/%d")

#FAILED=$(hammer task list |grep "Scheduled Synchronization" | grep $DATE | grep -v success | wc -l)

if [ $FAILED -ne 0 ]; then
	echo "Found failed synced repositories. Aborting!"
#	exit 1
fi

DESCR="Automatically published on $(date +"%d/%m/%Y %H:%M:%S")"

declare -a my_content_view=("Redhat 5 ELS" "Redhat 6" "Redhat 7" "zLinux Redhat 6" "zLinux Redhat 7")

function my_publish() {
                echo "Publishing $1"
                hammer content-view publish --organization "My_Org" --name "$1" --description "$DESCR"
                return $?
}

function my_promote_uat() {
                echo "Promoting $1 to UAT"
		ENVIRON="UAT Servers"
		case "$1" in 
		"zLinux Redhat 6")
			ENVIRON="zLinux UAT Servers"
		;;
		"zLinux Redhat 7")
			ENVIRON="zLinux UAT Servers"
		;;
		*)
			ENVIRON="UAT Servers"
		;;
		esac
			
                hammer content-view version promote --organization "My_Org" --content-view "$1" --to-lifecycle-environment "$ENVIRON" --from-lifecycle-environment Library
		return $?
}

function my_promote_prod() {
                echo "Promoting $1 to Production"
		case "$1" in 
		"OpenShift")
			ENVIRON="OpenShift Production Servers"
		;;
		"SAP HANA 4yrs")
			ENVIRON="SAP HANA 4yrs Production Servers"
		;;
		"SAPHANA_EUS")
			ENVIRON="SAPHANA Production Servers"
		;;
		"zLinux Redhat 6")
			ENVIRON="zLinux Production Servers"
		;;
		"zLinux Redhat 7")
			ENVIRON="zLinux Production Servers"
		;;
		*)
			ENVIRON="Production Servers"
		;;
		esac
                hammer content-view version promote --organization "My_Org" --content-view "$1" --to-lifecycle-environment "$ENVIRON" --from-lifecycle-environment Library
                return $?
}

function verify_action(){
if [ $1 -ne 0 ];
then
echo -e "$3 of $2 exited with code $1 \n"
else 
echo -e "$3 of $2 completed with Success \n"
fi

}

for i in "${my_content_view[@]}"
do

my_publish "$i"
verify_action $? Publish $i


my_promote_uat "$i"
verify_action $? UAT_Promote "$i"


my_promote_prod "$i"
verify_action $? Prod_Promote "$i"

echo -e "\n\n\n"

done

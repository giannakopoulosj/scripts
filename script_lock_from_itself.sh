# stop on errors
set -e
 
scriptname=$(basename $0)
pidfile="/var/tmp/${scriptname}"
 
# lock it
exec 200>$pidfile
flock -n 200 || exit 1
pid=$$
echo $pid 1>&200
 
## Your code:

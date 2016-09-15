# stop on errors
set -e
 
_SCRIPTNAME=$(basename $0)
_PIDFILE="/var/tmp/${_SCRIPTNAME}"
 
# lock it
exec 200>"$_PIDFILE"
flock -n 200 || exit 1
_PID=$$
echo "$_PID" 1>&200
 
## Your code:

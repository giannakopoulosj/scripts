#!/bin/bash
_USER=IN_prd
_REMOTE=pro01.foo.bar
_REMOTE_PATH="/home/xXx/user"
_LOCAL_PATH="/apps/xXx/user"
_FILE="*.txt"
_COMMAND_FILE=commands.sftp
_ACTION=get


############################SANITY CHECKS
if [ -d $_LOCAL_PATH  ]
then
    echo "Local Directory exist"
else
    echo "Local Directory does not exist"
    exit 1
fi

echo "bye" > "$_COMMAND_FILE"
sftp -b "$_COMMAND_FILE" $_USER@$_REMOTE > "$0.log"
vreturn=$?

if [ $vreturn -eq 0 ]
then
    echo "Connection tested to sftp $_USER@$_REMOTE and will continue to transfer..."
else
    echo "There is no connection to sftp $_USER@$_REMOTE "
    exit 1
fi


############################ACTIONS LISTING
echo "" > "$_COMMAND_FILE"
{
echo "lcd $_LOCAL_PATH"
echo "cd $_REMOTE_PATH"
} >> "$_COMMAND_FILE"

if [ "$_ACTION" == 'send' ] ############################SEND FILES TO REMOTE
then
    for _F in $(cd "$_LOCAL_PATH"||exit 1;ls $_FILE);
    do
        echo "mput $_F $_F.partial" >> "$_COMMAND_FILE"
        echo "rename $_REMOTE_PATH/$_F.partial $_REMOTE_PATH/$_F" >> "$_COMMAND_FILE"
    done

elif [ "$_ACTION" == 'sendclean' ]  ############################SEND AND CLEAN LOCAL FILES
then

    for _F in $(cd "$_LOCAL_PATH"||exit 1;ls $_FILE);
    do
        echo "mput $_F $_F.partial" >> "$_COMMAND_FILE"
        echo "rename $_REMOTE_PATH/$_F.partial $_REMOTE_PATH/$_F" >> "$_COMMAND_FILE"
        echo "!rm $_LOCAL_PATH/$_F" >> "$_COMMAND_FILE"
    done
elif [ "$_ACTION" == 'get' ] ############################ GET FILES FROM THE REMOTE
then

#    for _F in $_FILE;
#   do
#       echo "mget $_F $_F.partial" >> "$_COMMAND_FILE"
#   done
echo "lmkdir temp" >> "$_COMMAND_FILE"
echo "lcd temp" >> "$_COMMAND_FILE"
echo "mget $_FILE" >> "$_COMMAND_FILE"
echo "lcd $_LOCAL_PATH" >> "$_COMMAND_FILE"
echo "!mv temp/* $_LOCAL_PATH" >> "$_COMMAND_FILE"
echo "!rmdir temp" >> "$_COMMAND_FILE"
#   for _F in $_FILE;
#   do
#       mv "$_LOCAL_PATH/$_F.partial" "$_LOCAL_PATH/$_F"
#   done

else

echo "NO SUPPORTED ACTION PLZ RAISE A REQUEST"

fi


############################EXECUTE & VERIFICATION OF SFTP
sftp -b "$_COMMAND_FILE" $_USER@$_REMOTE > "$0.log"
vreturn=$?

if [ $vreturn -ne 0 ]
then
    echo "sftp step failed check log file..."
exit 1

fi

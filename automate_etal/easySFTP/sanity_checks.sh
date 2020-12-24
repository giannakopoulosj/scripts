############################SANITY CHECKS

local_dir_check () {
local LOCAL_PATH=$1

if [ -d $LOCAL_PATH  ]
then
    echo "Local Directory exist"
else
    echo "Local Directory does not exist"
    return 1
fi
}

check_sftp_connectivity () {

local USER=$1
local REMOTE=$2
local CONNECTIVITY_TEST=".TEST_CONNECTIVITY_SFTP"

echo "bye" > "$CONNECTIVITY_TEST"
sftp -b "$CONNECTIVITY_TEST" $USER@$REMOTE
local VRETRURN=$?

if [ $VRETRURN -eq 0 ]
then
    echo "Connection tested to sftp $USER@$REMOTE and will continue to transfer..."
    rm "$CONNECTIVITY_TEST"
    return 0
else
    echo "There is no connection to sftp $USER@$REMOTE "
    rm "$CONNECTIVITY_TEST"
    return 1
fi
}


check_sftp_remote () {

local USER=$1
local REMOTE=$2
local REMOTE_PATH=$3
local CONNECTIVITY_TEST=".TEST_CONNECTIVITY_SFTP"

echo "cd $REMOTE_PATH">"$CONNECTIVITY_TEST"
echo "bye" >> "$CONNECTIVITY_TEST"
sftp -b "$CONNECTIVITY_TEST" $USER@$REMOTE
local VRETRURN=$?

if [ $VRETRURN -eq 0 ]
then
    echo "Remote path $REMOTE_PATH tested to sftp $USER@$REMOTE and will continue to transfer..."
    rm "$CONNECTIVITY_TEST"
    return 0
else
    echo "There is no $REMOTE_PATH to sftp $USER@$REMOTE "
    rm "$CONNECTIVITY_TEST"
    return 1
fi
}

start_sanity_checks(){
local USER=$1
local REMOTE=$2
local REMOTE_PATH=$3
local LOCAL_PATH=$4

local_dir_check $LOCAL_PATH
check_sftp_connectivity $USER $REMOTE
check_sftp_remote $USER $REMOTE $REMOTE_PATH
}

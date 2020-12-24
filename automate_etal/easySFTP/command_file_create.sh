############################ACTIONS LISTING
send(){

local COMMAND_FILE=$1
local LOCAL_PATH=$2
local REMOTE_PATH=$3
local FILE="$4"

echo "" > "$COMMAND_FILE"
echo "lcd $LOCAL_PATH">> "$COMMAND_FILE"
echo "cd $REMOTE_PATH">> "$COMMAND_FILE"

for F in $(cd "$LOCAL_PATH"||exit 1;ls $FILE);
    do
        echo "mput $F $F.partial" >> "$COMMAND_FILE"
        echo "rename $REMOTE_PATH/$F.partial $REMOTE_PATH/$F" >> "$COMMAND_FILE"
    done
echo "bye" >> "$COMMAND_FILE"
}

sendclean(){

local COMMAND_FILE=$1
local LOCAL_PATH=$2
local REMOTE_PATH=$3
local FILE="$4"

echo "" > "$COMMAND_FILE"
echo "lcd $LOCAL_PATH">> "$COMMAND_FILE"
echo "cd $REMOTE_PATH">> "$COMMAND_FILE"

for F in $(cd "$LOCAL_PATH"||exit 1;ls $FILE);
    do
        echo "mput $F $F.partial" >> "$COMMAND_FILE"
        echo "rename $REMOTE_PATH/$F.partial $REMOTE_PATH/$F" >> "$COMMAND_FILE"
        echo "!rm $LOCAL_PATH/$F" >> "$COMMAND_FILE"
    done
echo "bye" >> "$COMMAND_FILE"

}

get(){
local COMMAND_FILE=$1
local LOCAL_PATH=$2
local REMOTE_PATH=$3
local FILE="$4"
local temp_dir=temp_dir$$

echo "" > "$COMMAND_FILE"
echo "lcd $LOCAL_PATH">> "$COMMAND_FILE"
echo "cd $REMOTE_PATH">> "$COMMAND_FILE"

echo "lmkdir $temp_dir" >> "$COMMAND_FILE"
echo "lcd $temp_dir" >> "$COMMAND_FILE"
echo "mget $FILE" >> "$COMMAND_FILE"
echo "lcd $LOCAL_PATH" >> "$COMMAND_FILE"
echo "!mv $temp_dir/* $LOCAL_PATH" >> "$COMMAND_FILE"
echo "!rmdir $temp_dir" >> "$COMMAND_FILE"
}

#!/bin/bash

#############################################FUNCTION_CODE_HERE

function error_banner ()
{

    echo "----------------------------"
    echo "|   In case his job fails  |"
    echo "|     Please contact       |"
    echo "|          XXX XXX         |"
    echo "----------------------------"
}

function completed_banner ()
{

    echo "----------------------------"
    echo "|      Execution was       |"
    echo "|  completed successfully  |"
    echo "----------------------------"
}

status_chk ()
{
case $1 in
    0)
    completed_banner
    echo "script stopped at $(date)"
    exit 0
  ;;
    1)
    error_banner
    echo "Exit code was 1..."
    echo "script stopped at $(date)"
    exit 1
  ;;
    8)
    if [ $2='sftp' ] && [ $3='ignore_no_file' ]
    then
    completed_banner
    exit 0
    fi
    error_banner
    echo "script stopped at $(date)"
    exit 1
  ;;
    *)
    error_banner
    echo "script stopped at $(date)"
    exit 99
  ;;
esac
}

#####################################MAIN_CODE_HERE
status_chk 8 sftp ignore_no_file


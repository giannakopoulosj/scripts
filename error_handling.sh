#!/bin/bash

#FUNCTION_CODE_HERE

function error {

    echo "----------------------------"
    echo "|   In case his job fails  |"
    echo "|     Please contact       |"
    echo "|          XXX XXX         |"
    echo "----------------------------"               
}

function completed {

    echo "----------------------------"
    echo "|      Execution was       |"
    echo "|  completed successfully  |"
    echo "----------------------------"               
}


#MAIN_CODE_HERE

function main {


return $exit_code
}

main
error_validation=$?
if [ $error_validation -ne 0 ]
then
error
else 
completed
exit 0
fi

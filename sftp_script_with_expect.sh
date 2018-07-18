#!/bin/bash

/usr/bin/expect <<eol
spawn sftp -oIdentityFile=$HOME/.ssh/my_ssh_key USER@SERVER
expect "USER@SERVER\'s password:" 
send "MY_PASSWORD\r"
expect "sftp>"
send "lcd local/path\r"
expect "sftp>"
send "get *\r"
expect "sftp>"
send "bye\r"
interact
eol

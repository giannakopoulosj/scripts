#!/bin/bash

msg_from="FROM_EMAIL_ADDRESS"
mailhost='mail-off01'
msg_to="TO_EMAIL_ADDRESS"
msg_cc="CC_EMAIL_ADDRESS"

export ORACLE_HOME=""
echo "Creating..."

sqlplus -s /nolog << EOF_SQL
connect user/pass@SID

SET PAGES 5000
SET TERM OFF
SET verify off
SET feedback off
SET MARKUP HTML ON SPOOL ON PREFORMAT OFF ENTMAP ON-
HEAD "<STYLE type='text/css'> <!-- BODY {background: #FFFFFF} --> </STYLE>"-
TABLE 'text-align="left" border="1"'

spool out.html

select * from dual;

spool off;

EXIT;
EOF_SQL

echo "Sending..."
echo "<!DOCTYPE html><html><body>Deal all,<br><br>MAIN BODY EMAIL<br><br>" > report.html
cat out.html >> report.html
echo "<br><br>Best Regards,<br>Your Team</body></html>" >> report.html
mailx -r "$msg_from" -s "THIS IS THE SUBJECT
MIME-Version: 1.0
Content-Type: text/html" -c "$msg_cc" "$msg_to" < report.html

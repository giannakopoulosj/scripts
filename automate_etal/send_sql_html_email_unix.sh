#!/bin/bash
echo "Creating..."
DB_RESULT=$(sqlplus -s /nolog <<EOD
connect xxxx/xxxxx@xxx

SET PAGES 5000
set TERM OFF
set verify off
set feedback off
set entmap off
set PREFORMAT OFF
set markup html on
spool out.html

select * from DUAL;

set markup html off
spool off
exit
EOD
)

echo "Sending..."
echo "Subject: my_subject" > report.html
echo "FROM: from@email.list" >> report.html
echo "To: to@email.list">> report.html
echo "Content-Type: text/html; charset=us-ascii" >> report.html
echo "<html>" >> report.html
echo "<p>" >> report.html
echo "Hello all <br> this email is automated email<br></p>">>report.html
cat out.html >> report.html
echo "Best Regards,<br>Team</body></html>" >> report.html
sendmail xxxx@xxxx.xxx < report.html


#!/bin/bash

last_date=$("$ORACLE_HOME"/bin/sqlplus -s /nolog <<EOF
connect x/x@x

set verify      off
set echo        off
set heading     off
set feedback    off
set pagesize    0
set linesize    2500
set trimspool   on
set timing      off
set arraysize   100

SELECT TO_CHAR(MAX (SYSDATE),'DD/MM/YYYY HH:MI:SS')
  FROM DUAL
exit;
EOF
)

#echo $last_date
#exit 0


"$ORACLE_HOME"/bin/sqlplus -s /nolog <<EOF
connect x/x@x
set verify      off
set echo        off
set heading     off
set feedback    off
set pagesize    0
set linesize    2500
set trimspool   on
set timing      off
set arraysize   100

spool test.txt
 to_date('$last_date','DD/MM/YYYY HH:MI:SS');

exit;
spool off
EOF

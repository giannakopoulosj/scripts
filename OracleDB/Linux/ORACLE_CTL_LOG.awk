awk '/Table.+[:]/ {print substr($2,1,length($2)-1)}'  xxxxx.log

awk '/Rows successfully loaded./ {print $1}' xxxxx.log

awk '/not loaded due to data errors./ {print $1}' xxxxx.log

awk '/not loaded because all WHEN clauses were failed./ {print $1}' xxxxx.log

awk '/not loaded because all fields were null./ {print $1}'  xxxxx.log

awk '/^ORA-/ {print}' xxxxx.log | sort -u

awk '/Run began on/ {print $6, $5, $8, $7}' xxxxx.log

awk '/Run ended on/ {print $6, $5, $8, $7}' xxxxx.log

awk '/Elapsed/ {print substr($4,1,2)*3600 + substr($4,4,2)*60 + substr($4,7)}' xxxxx.log

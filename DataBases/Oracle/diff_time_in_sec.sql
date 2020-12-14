select 
trunc(mod(end_date - start_date,1)*24)*60*60 + -- Hours to seconds difference between Start_Date: DD/MM/YYYY HH24:MM:SS - End_Date: DD/MM/YYYY HH24:MM:SS
trunc( mod(mod(end_date - start_date,1)*24,1)*60)*60 + -- Min to seconds between Start_Date: DD/MM/YYYY HH24:MM:SS - End_Date: DD/MM/YYYY HH24:MM:SS
trunc(mod(mod(mod(end_date - start_date,1)*24,1)*60,1)*60 ) as secs --Seconds between Start_Date: DD/MM/YYYY HH24:MM:SS - End_Date: DD/MM/YYYY HH24:MM:SS
from dual;

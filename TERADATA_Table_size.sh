select 
databasename, 
tablename,
sum (currentperm)/1024**3 as current_GB
from dbc.allspace 
where tablename <> 'All'
and tablename like '%2017%'
/*and databasename like '%L2%'*/
group by 1,2
order by 1 desc

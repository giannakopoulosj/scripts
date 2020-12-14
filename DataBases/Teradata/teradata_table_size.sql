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

--------------------------
SELECT	Databasename (format 'X(25)'),
CAST(SUM(maxperm)/(1024*1024*1024) as integer)+1 AS Max_Capacity_GB,
   CAST(SUM(currentperm)/(1024*1024*1024) as integer) AS Current_Capacity_GB,
   ((SUM (currentperm))/NULLIFZERO (SUM (maxperm)) * 100)(format 'zz9.99%',
		   TITLE 'Used%'),
   case 
	when (((SUM (currentperm))/NULLIFZERO (SUM (maxperm)) * 100)(format 'zz9.99%',TITLE 'Used%')>85) then 'Size over 85%' 
	else '-'  
END	as Above_85_Percent_Used 
where	Databasename like 'P%'
   FROM DBC.DiskSpaceV 
order by 4 desc 
GROUP BY 1 

/*
GLOBAL_STATS
For partitioned tables, indicates
whether statistics were collected for the table as a whole (YES) or 
were estimated from statistics on underlying partitions and subpartitions (NO)

LAST_ANALYZED
Date on which this table was most recently analyzed
*/


--Tables
select owner,table_name,last_analyzed, global_stats
from dba_tables
where owner not in ('SYS','SYSTEM')
order by owner,table_name

--Partitions
select table_owner, table_name, partition_name, last_analyzed, global_stats
from dba_tab_partitions
where table_owner  not in ('SYS','SYSTEM')
order by table_owner,table_name, partition_name

--Index
select owner, index_name, last_analyzed, global_stats
from dba_indexes
where owner not in ('SYS','SYSTEM')
order by owner, index_name

--Partiion Index
select index_owner, index_name, partition_name, last_analyzed, global_stats
from dba_ind_partitions
where index_owner not in ('SYS','SYSTEM')
order by index_owner, index_name, partition_name

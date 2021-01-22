BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
ownname =>'xxxx',
tabname =>'xxxxx ',
estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
block_sample =>TRUE,
degree =>10,
method_opt =>'FOR ALL COLUMNS SIZE AUTO',
granularity =>'ALL',
cascade =>TRUE,
stattab => NULL,
statid =>NULL,
statown => NULL);
END;
/

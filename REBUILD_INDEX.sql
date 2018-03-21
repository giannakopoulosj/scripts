declare 
pout varchar(2000);
begin
xxxx.REBUILD_INDEX (pout);
dbms_output.put_line(pout);
end;
/





CREATE OR REPLACE PROCEDURE XXXXXXXXX.REBUILD_INDEX (P_OUT OUT VARCHAR2) AUTHID DEFINER 
AS
/******************************************************************************
      NAME:       compile_unusable_indexes
      PURPOSE:

      REVISIONS:
      Ver        Date        Authors                     Description
      ---------  ----------  ---------------        ------------------------------------
      1.0                                            1. Created this package body.
   ******************************************************************************/
CURSOR c_invalid is
SELECT 'alter index '||table_owner||'.'||index_name||' rebuild tablespace '||tablespace_name as A1
FROM   all_indexes
WHERE  status = 'UNUSABLE'
union all
SELECT 'alter index '||index_owner||'.'||index_name ||' rebuild partition '||PARTITION_NAME||' TABLESPACE '||tablespace_name 
FROM all_ind_partitions
WHERE  status = 'UNUSABLE'
union all
SELECT 'alter index '||index_owner||'.'||index_name ||' rebuild subpartition '||SUBPARTITION_NAME||' TABLESPACE '||tablespace_name
FROM all_ind_subpartitions
WHERE  status = 'UNUSABLE';
      
r_invalid c_invalid%ROWTYPE;

BEGIN

OPEN c_invalid;

    LOOP
         FETCH c_invalid INTO r_invalid;

         EXIT WHEN c_invalid%NOTFOUND;
         DBMS_OUTPUT.put_line (r_invalid.A1);
         EXECUTE IMMEDIATE r_invalid.A1;
    END LOOP;

 EXCEPTION
      WHEN OTHERS
      THEN
         ROLLBACK;
         DBMS_OUTPUT.
          put_line (
            r_invalid.A1||SQLCODE || ' ---' || SQLERRM);
         RAISE_APPLICATION_ERROR (SQLCODE, SQLERRM);
         
         P_OUT:=SQLCODE;
             
       
         
END RAID_PL_REBUILD_INDEX_NEW;
/

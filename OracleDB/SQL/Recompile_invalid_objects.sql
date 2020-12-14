set linesize 2000
set serveroutput on size 1000000
spool objects.lst
begin 
  -- Compile all invalid objects in current schema
  dbms_utility.compile_schema( sys_context('USERENV','CURRENT_SCHEMA'), false );
  -- Show all objects that remain invalid after compilation
  dbms_output.put_line('Invalid objects after recompile in schema '||sys_context('USERENV','CURRENT_SCHEMA') );
  dbms_output.new_line;
  dbms_output.new_line;
  dbms_output.put_line('-------------------------------       -----------------' );
 dbms_output.put_line('OBJECT NAME                           OBJECT TYPE      ' );
  dbms_output.put_line('-------------------------------       -----------------' );
  for r in (select rpad(object_name, 30, ' ') object_name 
                 , rpad(object_type,19,' ') object_type
            from 
            ((select object_name
                 , object_type
              from user_objects
             where status = 'INVALID'
               and object_type in( 'PACKAGE'
                                 , 'PROCEDURE'
                                 , 'FUNCTION'
                                 , 'TRIGGER'
                                 , 'PACKAGE BODY'
                                 , 'VIEW'
                                 , 'TRIGGER' 
                                 , 'TYPE' 
                                 , 'TYPE BODY' 
                                 )
            )
            minus -- Added recycle bin 10G
            (select object_name, type
             from user_recyclebin
            ))
           )
  loop
    dbms_output.put_line( rpad(r.object_name, 30)||chr(9)||chr(9)||r.object_type );
  end loop; 
  dbms_output.put_line('-------------------------------         -----------------' );
end;
/

column error format a500

select name
,      type
,      line
,      position
,      substr(text, 1, 1000) error
from   user_errors;

spool off

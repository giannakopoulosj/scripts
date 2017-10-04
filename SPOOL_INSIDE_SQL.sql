col spoolname new_value spoolname  

select 'invoice_'||to_char(sysdate, 'yymmdd') spoolname from dua;

spool '&spoolname'



spool off

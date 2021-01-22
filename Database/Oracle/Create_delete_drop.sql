CREATE TABLE backup.my_table AS
 (
select distinct * from view.my_table
   )
with data;

Delete from view.my_table;

insert into view.my_table
select * from backup.my_tale;


drop table backup.my_tale;

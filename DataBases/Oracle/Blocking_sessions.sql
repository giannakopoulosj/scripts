/* Formatted on 25/4/2018 09:39:17 (QP5 v5.149.1003.31008) */
SELECT (SELECT USERNAME
          FROM V$SESSION
         WHERE SID = A.SID)
          BLOCKER,
       A.SID,
       ' is blocking ',
       (SELECT USERNAME
          FROM V$SESSION
         WHERE SID = B.SID)
          BLOCKEE,
       B.SID
  FROM V$LOCK A, V$LOCK B
 WHERE A.BLOCK = 1 AND B.REQUEST > 0 AND A.ID1 = B.ID1 AND A.ID2 = B.ID2;
  
 select 
   blocking_session, 
   sid, 
   serial#, 
   wait_class,
   seconds_in_wait
from 
   v$session
where 
   blocking_session is not NULL
order by 
   blocking_session;

SELECT  DATA,
      EXTRACTVALUE (XMLTYPE (T.DATA),'/root/data/x/y/z') AS Z
  FROM TABLE AS T
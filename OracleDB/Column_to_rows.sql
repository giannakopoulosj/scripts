select server,LISTAGG (IP, ', ') WITHIN GROUP (ORDER BY IP)
from UNIX
group by server
--aggregates Multiple entries of different ips to single server

--Input:
--Server|IP
--A|1
--A|2
--A|3
--B|1
--C|1
--C|2

--Output:
--A|1, 2, 3
--B|1
--C|1, 2

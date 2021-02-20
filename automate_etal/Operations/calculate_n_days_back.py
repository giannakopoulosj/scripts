#!/usr/bin/python

DDAY=2
python -c "import datetime;print (datetime.date.today()-datetime.timedelta(${DDAY})).strftime(\"%Y%m%d\")"

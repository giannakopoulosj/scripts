#!/usr/bin/python

import datetime
import subprocess

format = "%Y%m%d%H%M%S"

#getting time with timedelta 30 min back
today = datetime.datetime.today() - datetime.timedelta(minutes=30)

#formatin time with format = "%Y%m%d%H%M%S"
script_time = today.strftime(format)

#call unix command with subprocess
#subprocess.call(["command", "arg1", "arg2"])
subprocess.call(["command", "arg1", "arg2"])

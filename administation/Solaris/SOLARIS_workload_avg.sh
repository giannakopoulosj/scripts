#!/bin/bash

 echo "Workload: $(w | grep "average" | grep -v grep)"| awk '{print $9,$10,$11,$12,$13}' && echo "#Cores: $(kstat cpu_info|grep -c core_id)"

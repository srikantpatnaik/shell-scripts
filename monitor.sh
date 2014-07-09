#!/bin/bash

# Monitor the SWAP and CPU usage of server and creates the log file,
# restarts server if limits get compromised


#logfile location, CSV format (date-time, SWAP, load avg)
logfile='/var/log/ipython-load.log'

# Looking for swap in GB
SWAP=`free -g | tail -n 1 | tr -s " " | cut -d " " -f 3`

# Swap in MB
SWAP_MB=`free -m | tail -n 1 | tr -s " " | cut -d " " -f 3`

# Looking for CPU load average > 1 (for 15 min field)
CPU=`cat /proc/loadavg | cut -d " " -f 3 | cut -c 1`

# CPU load average, all fields
CPU_ALL=`cat /proc/loadavg | cut -d " " -f -3`

# if swap > 12GB and CPU loadavg > 1
if  (( "$SWAP" >= "1" )) || (( "$CPU" >= "1" ))
   then
   echo "$(date +%d-%m-%Y_%T),$SWAP,$CPU" >> $logfile
   # printing to STDOUT for cronjob to catch and send email
   echo -e "Rebooting now ! \n $(date +%d-%m-%Y_%T),$SWAP_MB,$CPU_ALL"
   reboot
fi

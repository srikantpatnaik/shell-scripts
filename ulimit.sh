#!/bin/bash

### LOGIC ###
# Check user processes every 10s and add +400 to ulimit, i.e,
# present_user_processes + 400 = new_ulimit (to limit damage from fork bomb)


#present_user_processes=$(ps -eLF | grep $(whoami) | wc -l)
present_user_processes=$(ps -eLF | grep ipynb | wc -l)
max_user_process_allowed=3072


echo $(ulimit -a | grep -oE [\(][-][u][\)][' '][0-9]+ | cut -d ' ' -f 2)

#echo $ulimit_value

if [ $user_processes -lt 200 ] && [ $user_processes -lt 3072 ] ;
	then
	echo $(ulimit -a)
else
	echo $user_processes, $root_processes
	#echo $(ulimit -a)
fi


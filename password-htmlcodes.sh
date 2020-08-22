#!/bin/bash

declare -A splchars

passwd="$1"
passwd=$(echo -n $passwd)

splchars=( 
["%20"]=" " 
["%21"]="!"
["%22"]="\""
["%23"]="#"
["%2A"]="*"
["%2B"]="+"
["%2C"]=","
["%2D"]="-"
["%2E"]="."
["%2F"]="/"
["%3A"]=":"
["%3B"]=";"
["%3C"]="<"
["%3D"]="="
["%3E"]=">"
["%3F"]="?"
["%40"]="\@"
["%5B"]="["
["%5D"]="]"
["%5F"]="_"
["%7B"]="{"
["%7D"]="}"
)

#set -x

for i in ${!splchars[@]}; do
 	if [[ "$2" == "-r" ]]; then
		passwd=$(echo $passwd | sed "s|$i|${splchars[$i]}|g")
	else
		passwd=$(echo $passwd | sed "s|${splchars[$i]}|$i|g")
	fi
done
echo $passwd


#!/bin/bash

sciFile=andblk.sci
jsFile=js

declare -A mapping=( ["orig"]="ScilabDouble"
					 ["sz"]="ScilabDouble"
					 ["flip"]="ScilabBoolean"
					 ["pout"]="ScilabDouble"
					 ["pein"]="ScilabDouble"
					 ["peout"]="ScilabDouble"
					 ["exprs"]="ScilabString"
					 ["ipar"]="ScilabDouble"
					)

header() {
	echo "function " | tr -d '\n'
	echo -n $(head -n 1 $sciFile | cut -d '=' -f 2 | cut -d '(' -f 1) 
	echo "() {"
}

define() {
	IFS=$'\n';
	for line in $(tail -n +3 $sciFile);
		do
			if echo $line | grep -q "define";
				then
					echo
					echo -n "        var " 
					echo -n $line | tr -d ' '
					echo  ';' 
			else
				for key in "${!mapping[@]}";
					do 
						if echo $line | grep -q $key;
							then
								echo $line | cut -d "=" -f 1 | tr -d '\n' 
								echo " = new " | tr -d '\n'
								echo ${mapping[$key]} | tr -d '\n'
								echo "(" | tr -d '\n'
								echo $line | cut -d "=" -f 2 | tr -d '\n'
								echo ")" | tr -d '\n'
								echo ";"
						fi
					done
				if echo $line | grep -q "scicos_diagram"; then break;fi
			fi
		done
}

###########################################################################
#main starts here
main() {
	header
	define
}

main

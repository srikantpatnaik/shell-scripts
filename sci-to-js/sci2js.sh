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

diagram() {
	echo
	#echo -n "        " 
	echo "var diagram = scicos_diagram();"
	for line in $(grep -A1000 "scicos_diagram" $sciFile | tail -n +2);
		do
			if echo $line | grep -q "scicos_block"; then break;fi
			if echo $line | grep -q 'scicos_link';
				then
					scicosLinks=$(echo -n $line | sed 's/objs([0-9]*)/objs\.push(/g' | sed 's/=//')
					scicosVarsCount=$(echo -n $scicosLinks | grep -o "=" | wc -l)
					scicosVars=$(echo $scicosLinks  | cut -d '(' -f 3- | sed 's/)//')
					echo -n  $scicosLinks | cut -d '(' -f -2 | tr -d '\n'
					echo '({'
					eachIntVars=$(echo $scicosVars | grep -o "[a-z]*\=\[[0-9,;.-]*\]" | cut -d '=' -f 1-) 
					for each in $eachIntVars;
						do 
							scicosVarsCount=$(($scicosVarsCount-1))
							a=$(echo $each | cut -d '=' -f 1)
							b=$(echo $each | cut -d '=' -f 2-)
							echo -n "        "
							echo -n $a: new ScilabDouble\($b\)
						   	if [ $scicosVarsCount -gt 0 ]; then echo ','; else echo; fi
						done
					echo '}));'
			else 
				echo -n $line | sed 's/objs([0-9]*)/objs\.push(/g' | sed 's/=//' 
				echo -n ');'
			fi
			echo 
		done

}

###########################################################################
#main starts here
main() {
	header
	define
	diagram
}

main

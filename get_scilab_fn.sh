#!/bin/bash

w3m -no-cookie -dump_source http://help.scilab.org/docs/5.4.1/en_US/ > all_functions

# As the function class is also in list-refentry line in some places. To fix that
# we need to add new line after this class so that we can distinguish lines with functions
# clearly

sed -i "s/'class="list-refentry"><li>'/'class="list-refentry"><li>\n'/g" all_functions

cat all_functions | grep  'class="refentry">' -A10000 | grep 'type="text/javascript"' -B100000 | grep -o 'class="refentry">[a-zA-Z0-9_]*' | cut -d '>' -f 2 | uniq | sed '/^$/d' | sed '/^_/d' > final_list_of_all_fns

for eachLetter in {a..z}
	do
	cat sorted.txt | grep -oi ^$eachLetter[a-zA-Z0-9_]* > $eachLetter.txt
	done

rm all_functions

#!/bin/bash -e

echo ""
echo "Welcome Osdag installer"
echo "======================="
echo ""

while true; do
		echo "Install Osdag in $HOME/Osdag?"
		echo ""
		echo -n "Type 'y' to proceed, or 'c' for custom PATH: "
		read choice
		if [[ $choice == 'y' ]]; then
			#sed -e '1,/^exit$/d' "$0" | tar xzf - && ./test/bin/test
			echo -n $choice
			break
		elif [[ $choice == 'c' ]]; then
			echo -n "Enter custom PATH: "
			read path
			echo -n $path
			break
		else
			echo "You have given an invalid option. Please try again. "
		fi
done

exit

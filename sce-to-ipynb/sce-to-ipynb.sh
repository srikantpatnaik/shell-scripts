#!/bin/bash

# Author: Srikant Patnaik
# srikant@fossee.in
# License: GNU GPLv3

########################################################################

# How to use?

########################################################################

# FAQ

# What this script for?
# It will convert the sce files in a directory into an ipynb file.

# How it does?
#

########################################################################

sce_files_count=$(ls -1 *.sce | wc -l)
cellCodeSeparatorCount=0

file=1.ipynb
echo -n > $file

jsonHeader() {
	echo '{' >> $file
}

cellHeader() {
	echo '"cells": [' >> $file
}

nbTitle() {
	echo ' {
		   "cell_type": "markdown",
	   "metadata": {},
	   "source": [
	    "# Chapter 2 ELECTROSTATIC POTENTIAL AND CAPACITANCE"
	   ]
	},' >> $file
}

cellTitle() {
	echo  '{
		   "cell_type": "markdown",
		   "metadata": {},
		   "source": [
			"## Example 2.1; Page No 55"
		   ]
		  },' >> $file
}

cellCodeHeader() {
	echo '  {' >> $file
}

cellCodeBody() {
	echo '"cell_type": "code",
	   "execution_count": null,
	   "metadata": {
	    "collapsed": true
	   },
	   "outputs": [],' >> $file
}

cellCodeSourceHeader() {
	echo '"source": [' >> $file
}

cellCodeSourceBody(){
	IFS=$'\n';
	rm .tmp
			for line in $(cat $sceFile);
				do
					# replace " with ', add '\n",' at end of the line, add " at the beginning of the line
					echo $line | sed "s|\"|\'|g" | sed 's|\x0D$|\\n",|' | sed 's|^|"|' >> .tmp ;
				done
			# Last line 'comma' and '\n' is not required
			cat .tmp | sed '$s|.$||' | sed '$s|\\n||'>> $file
}

cellCodeSourceFooter() {
	echo '   ]' >> $file
}

cellCodeFooter() {
	echo '   }' >> $file
}


cellCodeSeparator() {
	# except the last cell
	cellCodeSeparatorCount=$(($cellCodeSeparatorCount + 1))
	if [ $cellCodeSeparatorCount -lt $sce_files_count ]; then
			echo ',' >> $file 
	fi
}

cellFooter() {
	echo '],' >> $file
}

metadata() {
	echo '"metadata": {
		  "kernelspec": {
		   "display_name": "Scilab",
		   "language": "scilab",
		   "name": "scilab"
		  },
		  "language_info": {
		   "file_extension": ".sce",
		   "help_links": [
			{
			 "text": "MetaKernel Magics",
			 "url": "https://github.com/calysto/metakernel/blob/master/metakernel/magics/README.md"
			}
		   ],
		   "mimetype": "text/x-octave",
		   "name": "scilab",
		   "version": "0.7.1"
		  }
		 },
		 "nbformat": 4,
		 "nbformat_minor": 0' >> $file

}

jsonFooter() {
	echo '}' >> $file
} 

###############################################################################

main() {
		# constant events
		jsonHeader
		cellHeader
		nbTitle
		for sceFile in $(ls -1 *.sce);
			do
				cellTitle
		    	cellCodeHeader
				cellCodeBody
				cellCodeSourceHeader
				cellCodeSourceBody $sceFile
				cellCodeSourceFooter
				cellCodeFooter
				cellCodeSeparator
			done
		cellFooter
		metadata
		jsonFooter
}

main

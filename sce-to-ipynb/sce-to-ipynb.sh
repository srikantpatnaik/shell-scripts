#!/bin/bash

#######################################################################

# License GNU GPLv3

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Author: Srikant Patnaik
# srikant@fossee.in

########################################################################

# How to use?

########################################################################

# FAQ

# What this script for?
# It will convert the sce files in a directory into an ipynb file.

# How it does?
#

########################################################################

file=1.ipynb
rm $file

jsonHeader() {
	echo '{' >> $file
}

cellHeader() {
	echo '"cells": [' >> $file
}

cellCodeHeader() {
	echo '  {' >> $file
}

cellCodeBody () {
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
	for each in $(cat 2.sce);
		do
			# replace " with ', add '\n",' at end of the line, add " at the beginning of the line
			echo $each | sed "s|\"|\'|g" | sed 's|\x0D$|\\n",|' | sed 's|^|"|' >> .tmp ;
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
	# only call if you have multiple code cells
	echo ',' >> $file 
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

jsonHeader
cellHeader
cellCodeHeader
cellCodeBody
cellCodeSourceHeader
cellCodeSourceBody
cellCodeSourceFooter
cellCodeFooter
#cellCodeSeparator
cellFooter
metadata
jsonFooter


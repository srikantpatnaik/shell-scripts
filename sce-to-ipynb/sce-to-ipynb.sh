#!/bin/bash

# Author: Srikant Patnaik
# srikant@fossee.in
# License: GNU GPLv3
# Version: 0.1 beta

########################################################################

# How to use?

# The present setup is hard coded for Scilab TBCs, but can be easily 
# modified for generic behaviour 

# ./sce-to-ipynb.sh dir-0/dir-1/dir-2/sce-files.sce

########################################################################

# FAQ

# What is this script for?
# It will convert the '.sce/.sci' files in a directory into ipynb file(s).

# How it does?
# The ipynb is a json file with place holders for code, output, title
# subtitle etc. Placing the content of sce file in the code section is
# the starting point. 

########################################################################

# function calls to create a $chapterName.ipynb file 

jsonHeader() {
	echo '{' >> $chapterName
}


cellHeader() {
	echo '"cells": [' >> $chapterName
}


nbTitle() {
	echo ' {
		   "cell_type": "markdown",
	   "metadata": {},
	   "source": [
       "# Chapter '$nbTitleName'"
	   ]
	},' >> $chapterName
}


cellTitle() {
	echo  '{
		   "cell_type": "markdown",
		   "metadata": {},
		   "source": [
			"## Example '$exampleName'"
		   ]
		  },' >> $chapterName
}


cellCodeHeader() {
	echo '  {' >> $chapterName
}


cellCodeBody() {
	echo '"cell_type": "code",
	   "execution_count": null,
	   "metadata": {
	    "collapsed": true
	   },
	   "outputs": [],' >> $chapterName
}


cellCodeSourceHeader() {
	echo '"source": [' >> $chapterName
}


cellCodeSourceBody(){
	IFS=$'\n';
	rm .tmp
			for line in $(cat $sceFile);
				do
					# replace " with ', add '\n",' at end of the line, add " at the beginning of the line
					echo $line | sed "s|\"|\'|g" | sed 's|\x0D$||' | sed 's|$|\\n",|' | sed 's|^|"|' >> .tmp;
				done
			# Last line 'comma' and '\n' is not required
			cat .tmp | sed '$s/\\n",/"/g' >> $chapterName
}


cellCodeSourceFooter() {
	echo '   ]' >> $chapterName
}


cellCodeFooter() {
	echo '   }' >> $chapterName
}


cellCodeSeparator() {
	# except the last cell
	if [ $currentCount -lt $sceFilesCount ]; then
			echo ',' >> $chapterName 
	fi
}


cellFooter() {
	echo '],' >> $chapterName
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
		 "nbformat_minor": 0' >> $chapterName

}


jsonFooter() {
	echo '}' >> $chapterName
} 

###############################################################################

main() {
	for sceFilePath in $(find $1/ -mindepth 2 -maxdepth 2 -type d);
		do
			cd $sceFilePath
			sceFilesCount=$(ls -1 *.sce *.sci | wc -l)
			currentCount=0
			chapterName=$(echo $sceFilePath | cut -d '/' -f 4).ipynb
			nbTitleName=$(echo $sceFilePath | cut -d '/' -f 4 | sed 's/_/ /g' | sed 's/-/: /')
			jsonHeader $chapterName
			cellHeader $chapterName
			nbTitle $chapterName $nbTitleName
				for sceFile in $(ls -1 *.sce *.sci);
					do  
						exampleName=$(echo $sceFile | sed 's/_/./' | sed 's/-/: /')
						cellTitle $chapterName $exampleName
					    	cellCodeHeader $chapterName
						cellCodeBody $chapterName
						cellCodeSourceHeader $chapterName 
						cellCodeSourceBody $chapterName $sceFile
						cellCodeSourceFooter $chapterName
						cellCodeFooter $chapterName 
						currentCount=$(($currentCount + 1))
						cellCodeSeparator $chapterName $sceFilesCount $currentCount
					done
				cellFooter $chapterName
				metadata $chapterName
				jsonFooter
				cd ../../../
			done
		}

#################################################################################

# program starts here
# calling main()

if [ "$#" -ne 1 ]; then
    echo "Usage: './sce-to-ipynb.sh all-books/' where all books have all-books/book1/chap1/1.sce and so on"
else
	main $1
fi



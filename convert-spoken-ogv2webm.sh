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

########################################################################

# A sample 'avconv' command

# avconv -y -i video.ogv -threads 4 -r 2 -c:v libvpx \
# -qmin 5 -qmax 45 -crf 5 -b:v 100k  -c:a libvorbis -q:a 1 video.webm

# 'qmin'   : the minimum quantization parameter (default 4)
# 'qmax'   : the maximum quantization parameter (default 63)
# 'b:v'    : the target bit rate setting
# 'crf'    : the overall quality setting. If not set, VBR (default 10)
# 'r'      : frame rate
# 'threads': For quad core its safe to use 4 threads

########################################################################

# MUST READ

# What this script for?
# This will find the 'ogv' videos in directories recurssively and convert
# them into 'webm'.

# How it does?
# It uses 'find' command to list all ogv file paths and store it in a text
# file. It then reads each line from the text file and executes 'avconv'
# command to convert the file into 'webm'. Simple.
#
# Also, it helps in resuming the conversion by storing the completed webm
# video status to a file
#
# To resume you must run the file from the same location.

########################################################################

# Paths for our database files
ogvfile='source-ogvfile-paths.txt'
webmfile='converted-webmfile-paths.txt'

# Get the PATH of the running script
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# This file need to present before comparison, also it is needed for
# subsequent invocations to compare whether file already converted or not
touch $DIR/$webmfile

# Force user to enter only one arguement, i.e path of the video directory
if [ $# -ne "1" ]; then
    echo 'Provide path of your media directory as argument to this script.'
    exit 0
fi

# Create text file with ogv file paths
find $1 -iname \*.ogv > $DIR/$ogvfile

checkForWebmConversion() {
	# This $1 is different than command line argument.
	# It is a function argument.
    grep $1 $DIR/$webmfile
    # Check the return status of grep command. If '0' file converted, else not.
	file_conversion_status=$(echo $?)
}

# Iterate over each line of the file and convert it to webm. Place the file
# in the same directory
for eachOgvFile in $(cat $DIR/$ogvfile); do
	# First construct the new file name with webm extension using ogv path
	# Handling both OGV/ogv extensions
	eachWebmFile=$(echo $eachOgvFile | sed -s s/ogv/webm/i)
    # Check whether the ogv file already converted. For this let's maintain
    # a separate text file.
    # The next function will handle this
    checkForWebmConversion $eachWebmFile
	# Execute CPU hungry avconv command only if the video was not dealt earlier
    # This is useful if we rerun the script. It shouldn't start from beginning.
	if [ $file_conversion_status -eq "1" ]; then
		# Change the command line flags based on the sample shown on the top of
		# this file.
		avconv -y -i $eachOgvFile -threads 4 \
			   -r 2 \
			   -c:v libvpx -qmin 5 -qmax 45 -crf 5 -b:v 100k \
			   -c:a libvorbis -q:a 1 \
			   $eachWebmFile
		# Check whether file actually created successfully, sometimes due to
		# power failure the file might be incomplete.
		# This will fail for any other containers and return 1
		file $eachWebmFile | grep WebM
		if [ $? -eq '0' ]; then
			# Now we are almost sure that file created is indeed a webm, hence
			# create an entry in webmfile so that it doesn't get converted again
			echo $eachWebmFile >> $DIR/$webmfile
		fi

fi
done


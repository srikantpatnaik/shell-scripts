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

# '-qmin' : the minimum quantization parameter (default 4)
# '-qmax' : the maximum quantization parameter (default 63)
# '-b:v'  : the target bit rate setting
# '-crf'  : the overall quality setting. If not set, VBR (default 10)

########################################################################

# What this script for?
# This will find the 'ogv' videos in directories recurssively and convert
# them into 'webm'.

# How it does?
# It uses 'find' command to list all ogv file paths and store it in a text
# file. It then reads each line from the text file and executes 'avconv'
# command to convert the file into 'webm'. Simple.

########################################################################
ogvfile='source-ogvfile-paths.txt'
webmfile='converted-webmfile-paths.txt'

# Get the PATH of the running script
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

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
    grep $1 $DIR/$ogvfile
    # Check the return status of grep command. If '0' file converted, else not.
	file_conversion_status=$(echo $?)

}

# Iterate over each line of the file and convert it to webm. Place the file
# in the same directory
for eachOgvFile in $(cat $DIR/$ogvfile); do
    # Check whether the ogv file already converted. For this let's maintain
    # a separate text file.
    # The next function will handle this
    checkForWebmConversion $eachOgvFile
	if [ $file_conversion_status -eq "0" ]; then
		echo file need to be converted
	fi

done




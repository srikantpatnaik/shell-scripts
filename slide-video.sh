#!/bin/bash

# Get the files from command line parameters
image1=$1
image2=$2
output=$3

ffmpeg -y -framerate 1/20 \
	-i $image1 -s 1280x720\
	-r 25\
	-vf "zoompan=z='zoom+0.0002':d=500:fps=25:s=1280x720'" -q:v 4\
        $image1.mpg

ffmpeg -y -framerate 1/5\
        -i $image2 -s 1280x720\
        -r 30 \
	-vf "zoompan=z='if(lte(zoom,1.0),1.2,max(1.001,zoom-0.0002))':d=500:fps=25:s=1280x720" -q:v 4\
	$image2.mpg

ffmpeg -y -i "concat:$1.mpg|$2.mpg" -c copy $output.mpg

ffmpeg -y -i $output.mpg -b 1000k $output

rm -v $image1.mpg $image2.mpg $output.mpg


#!/bin/bash
# A noob script to generate video from past 24 hour sattelite images to predict cloud motion. Hopefully!
workdir=/tmp/weather

rm -rf $workdir
for each in {1..48}; do wget -P $workdir -q http://satellite.imd.gov.in/img/animation3d/3Dasiasec_wv$each.jpg; done
ffmpeg -y -f image2 -i $workdir/3Dasiasec_wv%d.jpg -vf crop=310:240  $workdir/mumbai_weather_yesterday_till_today_$(date +%d_%b_%H00IST).mp4
ffmpeg -y -f image2 -i $workdir/3Dasiasec_wv%d.jpg -vf crop=900:850 $workdir/india_weather_yesterday_till_today_$(date +%d_%b_%H00IST).mp4
mpv --fs -loop $workdir/india_weather_*

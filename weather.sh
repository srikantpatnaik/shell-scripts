#!/bin/bash
# A noob script to generate video from past 24 hour sattelite images to predict cloud motion. Hopefully!

rm -rf 3Dasiasec_wv* mumbai_weather_* india_weather_*
for each in {1..48}; do wget -q http://satellite.imd.gov.in/img/animation3d/3Dasiasec_wv$each.jpg; done
ffmpeg -y -f image2 -i 3Dasiasec_wv%d.jpg -vf crop=310:240  mumbai_weather_yesterday_till_today_$(date +%d_%b_%H00IST).mp4
ffmpeg -y -f image2 -i 3Dasiasec_wv%d.jpg -vf crop=900:850 india_weather_yesterday_till_today_$(date +%d_%b_%H00IST).mp4
mpv -loop india_weather_*

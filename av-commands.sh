# Changing the frame rate and size
#avconv -y -i /tmp/kazam_00000.mp4 -b:v 500k -r 15 -strict experimental /tmp/normal-size.mp4

# Converting to usable format to edit in audacity
#avconv -y -i /tmp/normal-size.mp4 /tmp/stereo-noisy.wav

# Adding noisefree audio to original video
#avconv -y -i /tmp/normal-size.mp4 -i /tmp/stereo-noisefree.mp3 -map 0:0 -map 1 -vcodec copy -strict experimental /tmp/output.mp4

# To add multiple mp4 files to output.mp4
#MP4Box -cat kazam_00000.mp4 -cat beta-videos/5.3_solder-16x2.mp4 -cat kazam_00001.mp4 -new output.mp4

# To cut portion of mp4 video, here from 0s to 4m55s
#avconv -ss 00:00:00.00 -i kazam_00000.mp4 -t 00:04:55.10 -acodec copy -vcodec copy out.mp4

# To cut till end just don't provide the duration (-t).
#avconv -ss 00:00:00.00 -i kazam_00000.mp4 -acodec copy -vcodec copy out.mp4

# Join webm/mkv videos
#mkvmerge -o output.webm -w 1.webm + 2.webm + 3.webm (or)

# To slow down the video/audio together
#mencoder -ovc copy -oac pcm -speed .95 fast.webm -o slow.webm

# To crop width/height :
# http://www.incenp.org/notes/2012/video-cropping.html
# To obtain the coordinates use mplayer.
# Create a ~/.mplayer/crop and add the following
RIGHT change_rectangle 2  10
LEFT  change_rectangle 2 -10
UP    change_rectangle 3 -10
DOWN  change_rectangle 3  10
2   change_rectangle 0  10
4   change_rectangle 0 -10
6   change_rectangle 1  10
8   change_rectangle 1 -10
# To view and scale visually using mplayer with keyboard shortcuts (1 to 8).
#mplayer -vf rectangle -input conf=crop video.webm

# Grab the crop value from mplayer stdout and render the video
# ffmpeg -threads 4 -i 5.webm -vf crop=1226:768:0:0 -vcodec vp8 -acodec copy output.webm

# Scale the video. To keep the proportion use this link: http://scriptygoddess.com/resources/proportioncalc.htm
#ffmpeg -threads 4 -i output.webm -vf scale=800:502 -vcodec vp8 -acodec copy output-scaled.webm 


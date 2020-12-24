#!/usr/bin/python

import subprocess
import os
import time

start_time = time.time()

#Get the directory that contains movies
base_directory = "./movies/"
directory = os.listdir(base_directory)

#Run through all files in directory
for input_file in directory:
	if os.path.splitext(input_file)[0]+".mp4" not in cdirectory:
		#Split files from .extension
		name = os.path.splitext(input_file)
		#Forming the conveting name
		output_file = name[0] + ".mp4"
		print "\n Converting %s to %s \n" % (input_file,output_file)
		#Creating the ffmpeg command for the video
		ffmpeg_command = 'ffmpeg -loglevel quiet -i "%s%s" -vcodec libx264 -b 700k -acodec libfaac -ab 128k 
-ar 48000 -f mp4 -deinterlace -y -threads 0 "%s" ' % (base_directory,input_file,output_file)
		subprocess.call(ffmpeg_command,shell=True)

print "Done in ",time.time() - start_time,"seconds"

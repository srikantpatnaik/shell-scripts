#!/bin/bash

#This script is intended to run on server

pelican_home="/home/srikant/Documents/gnu-linux.org"
pelican_content="$pelican_home/content/"
website_output="/var/www/gnu-linux.org/"

# copy posts of other authors to content directory
# array of authors and their working directories

posts=("/home/user1/blogs/"
	   "/home/user2/blogs/"
	   "/home/user3/blogs/")

for post in ${posts[@]}; 
	do 
		rsync -rth --include '*/'  --include '*.rst' --include '*.png' --include '*.jpg' --exclude '*' $post $pelican_content 
		return_status=$(git status | grep -a 'Untracked files')	
			if [ $? -eq "0" ];
			then
				echo "git has to commit, commit, build & then copy 'output/' dir to '/var/www/'"
				git add -A && git commit -am "a post by contributor"
				make publish
				echo $post
				cp -r output/* $website_output
			fi
	done


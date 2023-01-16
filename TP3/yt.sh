#!/bin/bash

if [ -d /home/smaintos/srv/yt/downloads ] && [ -d /var/log/yt ]
then
	cd downloads
	video_url=$1
        title="$(youtube-dl --get-title --skip-download ${video_url})"
	mkdir  "${title}"
        cd "${title}"
        youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]' ${video_url} 2>&1 > /dev/null
	echo "Video ${video_url} was downloaded."
	chemin="$(find $(cd ..; pwd) -name "${title}")"
	echo "File path :$(find $(cd ..; pwd) -name "${title}")"
	mkdir description
	cd description
	youtube-dl --skip-download --get-description ${video_url} > description.txt
	datelog="$(date '+[%y/%m/%d %T]')" 
	echo "${datelog} Video ${url} was downloaded. File path : "${chemin}"" >> /var/log/yt/download.log
else 
	echo "Répertoire manquant."
	exit 0
fi

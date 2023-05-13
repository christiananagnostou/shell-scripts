#! /bin/bash
#
#	Converts all .alac files into .flac files 
#	in current directory using ffmpeg
#

for f in *.m4a; do 
	ffmpeg -i "$f" "${f%.m4a}.flac"
done


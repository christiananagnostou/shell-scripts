#! /bin/bash
#
#	Converts all .flac files into .alac files 
#	in current directory using ffmpeg
#

for f in *.flac; do 
	ffmpeg -i $f -vn -c:a alac ${f%.flac}.m4a
done


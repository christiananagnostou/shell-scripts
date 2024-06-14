#! /bin/bash

# Performs a git pull on all git repositories in your current working directory

for file in $(ls); do
	if [[ -d $file && -d $file/.git ]]; then
		cd $file
		echo "Pulling latest changes for $file"
		git pull
		printf "\n"
 		cd ..
	fi
done

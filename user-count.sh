#!/bin/bash

# Description:
# This script extracts and processes user information from the /etc/passwd file.
# It displays the full names of users, sorts them, and counts the number of users.
# Usage: ./user-count.sh

# Pipeline to extract and process user information
pipeline='cat /etc/passwd | cut -d: -f5 | grep -v "^[#]" | sort -k1'

# Execute the pipeline and process the output
eval $pipeline | while read -r line; do
  if [[ $line == *","* ]]; then
    echo "$line" | awk '{print $2, $1}' | tr ',' ' '
  else
    echo "$line"
  fi
done

# Count the number of lines produced by the pipeline
numLines=$(eval $pipeline | wc -l | xargs)

# Output the count of users
echo '-----------------------------------------'
echo "There are $numLines users in /etc/passwd"

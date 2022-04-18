#! /bin/bash

# Lab 8 - Christian Anagnostou
# Question 1 command pipeline


pipeline='cat /etc/passwd | cut -d: -f5 | grep ^[A-G] | grep -iv 'account' | cut -d- -f1 | sort -k2'

eval $pipeline | while read line
do
  if [[ $line == *","* ]]; then
    awk '{print $2,$1}' | tr ',' ' '
  else
    echo $line
  fi
done

numLines=$( eval $pipeline | wc -l | xargs )
echo '-------------------------------------------------'
echo "There are $numLines users in /etc/passwd"

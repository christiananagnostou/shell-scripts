#! /bin/bash

# ECHO COMMAND
echo Hello World!


# VARIABLES 
# Uppercase by convention
# Letters, numbers, underscores

NAME="Christian" 
echo "My name is $NAME"


# USER INPUT
read -p "Enter your name: " NAME
echo "Hello $NAME, nice to meet you!"


# CONDITIONALS
# IF

if [ "$NAME" == "Dumb" ]
then 
	echo "Your name is dumb!"
elif [ "$NAME" == "Kap" ]
then
	echo "tryna kap?"
else 
	echo "Your name is basic"
fi

# COMPARISON

########
# val1 -eq val2 Returns true if the values are equal
# val1 -ne val2 Returns true if values are not equal
# val1 -gt val2 Returns true if val1 is greater than val2
# val1 -ge val2 Returns true if val1 is greater than or equal to val2
# val1 -lt val2 Returns true if val1 is less than val2
# val1 -le val2 Returns true if val1 is less than or equal to val2
########

NUM1=3
NUM2=5

if [ "$NUM1" -gt "$NUM2" ]
then 
	echo "$NUM1 is greater than $NUM2"
else 
	echo "$NUM1 is less than $NUM2"
fi

# FILE CONDITIONS

########
# -d file	True if the file is a directory
# -e file	True if the file exists (note that this is not particularly portable, this -f is generally used)
# -f file 	True if the provided string is a file
# -g file 	True if the group id is set on a file
# -r file 	True if the file is readable
# -s file 	True if the file has non-zero size 
# -u 		True if the user id is set on a file
# -w		True if the file is writable
# -x 		True if teh file is an executable
########

FILE="test.txt"
if [ -f "$FILE" ]
then 
	echo "$FILE is a file"
	rm test.txt
	echo "File test.txt has been removed"
else 
	echo "$FILE is not a file"
	touch test.txt
	echo "It has been created for you"
fi


# CASE STATEMENT

read -p "Are you 21 or over? Y/N " ANSWER
case "$ANSWER" in
	[yY] | [yY][eE][sS])
		echo "You can have a beer! :)"
		;;
	[nN] | [nN][oO])
		echo "Sorry, no drinking"
		;;
	*)
		echo "Please enter y/yes or n/no"
		;;
esac

	
# FOR LOOP
NAMES="Brad Kevin Alice Mark"
for NAME in $NAMES
	do 
		echo "Hello $NAME"
done

# FORLOOP TO RENAME RILES 
FILES=$(ls *.txt)
NEW="new"
for FILE in $FILES
	do	
		echo "Renaming $FILE to new-$FILE"
		mv $FILE $NEW-$FILE
done


# WHILE LOOP - read through the file line by line

LINE=1
while read -r CURRENT_LINE
	do
		echo "$LINE: $CURRENT_LINE"
		((LINE++))
done < "./new-1-.txt"


# FUNCTION
function sayHello() {
	echo "Hello World"
}		

sayHello

# FUNCTION WITH PARAMS
function greet() {
	echo "Hello, I am $1 and I am $2"
}

greet "Brad" "36"


# CREATE FOLDER AND WRITE TO FILE
mkdir hello
touch hello/world.txt
echo "Hello World" >> hello/world.txt


cal
man cal









#! /bin/bash 

# Assign default phonebook file
default_phonebook="/home/isaacs/class/unix.part2/phone.book"

# Colors for printing
GREEN='\033[0;32m'
NC='\033[0m' # no color

# -h Print the help text
print_help() {
printf "
NAME:
\t phonebook.lab11\n
DESCRIPTION:
\t This script is from Lab 11 CSM CIS 121 Linux/Unix\n
USAGE:
\t phonebook.lab11 [OPTION] <PHONEBOOK_FILE>\n
\t Print a custom phonebook:
\t\t phonebook.lab11 <PHONEBOOK_FILE>\n
\t Print multiple custom phonebooks:
\t\t phonebook.lab11 <PHONEBOOK_FILE> <PHONEBOOK_FILE> <PHONEBOOK_FILE>\n
OPTIONS:
\t -h\t Print script information\n
\t -c\t Create a phonebook
\t\t EX: phonebook.lab11 -c new_phone.book\n
\t -e\t Edit a line of a phonebook
\t\t PARAMS: 
\t\t\t First param is a term to search lines in target file. Uses grep, so this can also take regex expressions
\t\t\t Second param is the phonebook file you want to edit
\t\t EX: phonebook.lab11 -e Bill phone.book\n
AUTHOR:
\t Christian Anagnostou - May 25, 2022
\t Github: https://github.com/ChristianAnagnostou\n
"
}

# -c Create a phonebook and prompt user to enter contacts
create_phonebook () {
	if [ -f $1 ]; then echo "Error: $1 - file already exists"; exit 1; fi
	touch $1
	printf "\nCreated file: $1 - $(date) \n\n"
	echo "Enter contacts in the form: First:Last:Phone:Email - (press ctrl+d when finished)"
	cat > $1
}

# Print a phonebook
print_phonebook () {
 	printf "\nPhonebook - ${GREEN}$1${NC} - $(date)\n\n"
	sort -t: -k2 $1 | sed 's/:/\t/g'
}

# Validate that a phonebook is a file and that it is readable. If it is not a file, prompt to create a file in its place
validate_phonebook () {
	if [ ! -f $1 ]; then
		echo "Error: $1 - file does not exist"
		read -p "Would you like to create a phonebook at $1? (y/n): " create
		if [[ $create == [yY] ]]; then
			create_phonebook $1
		else exit 1
		fi
	elif [ ! -r $1 ]; then
		echo "Error: $1 - not a readable file"
	fi
}

# Edit a phonebook - Takes 2 args (value to search lines of file, file to edit)
edit_phonebook() {
	val=$1
	file=$2
	
	# File is not empty string
	if [ -z "$file" ]; then
		echo "Error: you must pass the file you want to edit as the second parameter"
		exit 1
	# File is writable
	elif [ ! -w $file ]; then
		echo "Error: $file - cannot write to file"
		exit 1
	fi
	# Validate file exists and is readable
	validate_phonebook $file

	# Search for lines that match value searched
	line=$(grep -n "$val" $file)
	line_num=0
	
	# Get line number to edit
	if [ -z "$line" ]; then
		echo "Erorr: no phonebook entries match '$val'"
		exit 1
	elif [ $(echo "$line" | wc -l) -gt 1 ]; then
		printf "Multiple lines match your edit query:\n\n"
		echo -n "$line"; echo; echo;
		read -p "Which line would you like to edit? (first number in row): " selected_line_num
  		# TODO: validate that selected_line_num is a valid line num
		line_num=$selected_line_num
	else
		line_num=$(echo $line | cut -d: -f1)
	fi

	# Verify line is correct
	echo "Attempting to edit:"
	sed -n "$line_num"p $file
	read -p "Is this correct? (y/n): " correct

	# Open to line in vim
	if [[ $correct == [yY] ]]; then
		echo "Opening $file in vim at line $line_num"
		vim +$line_num $file
	fi
}

handle_phonebook_input() {
	if [[ -z $@ ]]; then 
		echo "Error: No input was given. Exiting program..."	
		exit 1
	fi

	paramArr=($*)

	if [ $# -gt 1 ]; then
		for file in "$@"; do
			validate_phonebook $file	
			print_phonebook $file
		done
	elif [ ${#paramArr[@]} -gt 1 ]; then
		for file in "${paramArr[@]}"; do
			validate_phonebook $file
			print_phonebook $file
		done
	else 
		validate_phonebook $@
		print_phonebook $@
	fi
}

handle_opts() {
	# Define flags and handle usage
	while getopts ":hce:" opt; do
		case $opt in
			h) print_help; exit 1;;
			c) create_phonebook $2; exit 1;; 
			e) edit_phonebook $2 $3; exit 1;;
			*) echo "Invalid option $opt"; echo "Valid options are h (help), c (create), and e (edit)"; exit 1;;
		esac
	done
}

run_default() {
	# A file or multiple files are passed as params
	if [[ ! -z $@ ]]; then
		handle_phonebook_input $@
		exit 1
	fi

	# No file passed, prompt to use default
	read -p "Would you like to read from the default phonebook? (y/n): " use_default

	# Use default phonebook
	if [[ $use_default == [yY] ]]; then
		validate_phonebook $default_phonebook
		print_phonebook $default_phonebook
		exit 1
 	fi

	# Prompt for alternative phonebook to read
	read -p "Enter the relative or abolute path of the phonebook(s) to read: " input_file 

	# Handle alternative phonebook response
	handle_phonebook_input "$input_file"
}

init () {
	handle_opts $@
	run_default $@
}
init $@

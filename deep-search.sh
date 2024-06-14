#!/bin/bash

# Search all files and nested files for a term in their names and contents and display files to STDOUT
# Usage - deep-search.sh [search_term] [dir_to_search] [dir_to_copy_to] [--include-hidden]

# $1 - Required term to use for deep search
# $2 - Optional directory to deep search in. Defaults to current directory
# $3 - Optional directory to copy matching files into
# --include-hidden - Optional flag to include hidden files and directories

# Ensure search term is provided
if [[ -z $1 ]]; then
  echo "Usage: $0 [search_term] [dir_to_search] [dir_to_copy_to] [--include-hidden]"
  exit 1
fi

search_term=$1
search_dir=$(pwd)
copy_dir=""
include_hidden=false

# Parse the optional parameters
for arg in "$@"; do
  case $arg in
		# Flag to include hidden files and directories
    --include-hidden)
      include_hidden=true
      ;;

		# Default match
    *)
      if [[ -z $search_dir ]] && [[ -d $arg ]]; then
        search_dir=$arg
      elif [[ -z $copy_dir ]]; then
        copy_dir=$arg
      fi
      ;;

  esac
done

# Set the find command based on the include_hidden flag
if $include_hidden; then
  find_cmd="find \"$search_dir\" -type f"
else
  find_cmd="find \"$search_dir\" -type f -not -path '*/\.*'"
fi

# Find matching file names
echo "Searching for file names containing '$search_term'..."
eval $find_cmd -name "*$search_term*" | while read -r file; do
  echo "File name match: $file"
  if [[ -n $copy_dir ]]; then
    mkdir -p "$copy_dir"
    cp "$file" "$copy_dir"
  fi
done

echo ""

# Find matching file contents
echo "Searching for file contents containing '$search_term'..."
eval $find_cmd | xargs grep -rl "$search_term" | while read -r file; do
  echo "File content match: $file"
  if [[ -n $copy_dir ]]; then
    mkdir -p "$copy_dir"
    cp "$file" "$copy_dir"
  fi
done

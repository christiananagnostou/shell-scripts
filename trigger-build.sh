#!/bin/bash

# Default commit message
commit_message="fix: trigger build"

# If a parameter is provided, use it as the commit message
if [ -n "$1" ]; then
  commit_message="$1"
fi

# Create an empty commit with the specified or default message
git commit --allow-empty -m "$commit_message"

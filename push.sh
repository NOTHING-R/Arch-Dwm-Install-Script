#!/bin/bash

# Prompt for commit message
read -p "ENTER COMMIT (DEFULT 'NOTES ADDED'): " msg

# If user gives empty message → use default
if [ -z "$msg" ]; then
    msg="NOTES ADDED"
fi

# Add, commit and push
git add .
git commit -m "$msg"
git push

echo "✅ Successfully pushed to GitHub!"

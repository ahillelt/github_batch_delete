#!/bin/bash

# Alon Hillel-Tuch github.com/ahillelt
# This script automates the process of pulling repository lists and deleting the repositories
# Usage: ./auto-delete.sh <org> <base_repo_prefix>

if [ $# -lt "2" ]; then
    echo "Usage: $0 <org> <base_repo_prefix>"
    exit 1
fi

org=$1
base_repo_prefix=$2

# Step 1: Generate the list of repositories by calling pull.sh
echo "Generating repository list for organization '$org' with prefix '$base_repo_prefix'..."
./pull-repositories.sh "$org" "$base_repo_prefix" > repos.csv

# Check if the list generation was successful
if [ ! -s repos.csv ]; then
    echo "No repositories found or generated list is empty. Exiting."
    exit 1
fi

# Step 2: Call delete.sh to delete the repositories from the generated list
echo "Starting the deletion process..."
./delete-repositories-from-list.sh repos.csv

# Clean up the generated repos.csv file
rm repos.csv

echo "Repository deletion process completed."

#!/bin/bash


# # Alon Hillel-Tuch github.com/ahillelt
#
# Note:
# Deletes repos from a CSV input list
# - Ensure you have the `delete_repo` scope by running: gh auth refresh -h github.com -s delete_repo
# - Usage:
#   Step 1: Generate a repository list with ./pull.sh <org> <base_repo_prefix> > repos.csv
#   Step 2: Run this script: ./delete-repositories-from-list.sh repos.csv
#
# Credits to @joshjohanning from this repo for the idea: https://github.com/joshjohanning/github-misc-scripts/blob/main/gh-cli/

if [ $# -lt "1" ]; then
    echo "Usage: $0 <reposfilename>"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "File $1 does not exist"
    exit 1
fi

filename="$1"

echo "WARNING: This action will delete all repositories listed in $filename."
read -p "Are you sure you want to proceed? (yes/no): " confirmation
if [[ "$confirmation" != "yes" ]]; then
    echo "Aborting operation."
    exit 0
fi

while read -r repofull; do
    # Skip empty lines
    [[ -z "$repofull" ]] && continue

    # Validate format (must contain a single '/')
    if ! [[ "$repofull" =~ ^[^/]+/[^/]+$ ]]; then
        echo "Invalid entry: $repofull (skipping)"
        continue
    fi

    IFS='/' read -ra data <<< "$repofull"
    org=${data[0]}
    repo=${data[1]}

    echo "Deleting: $org/$repo"
    gh repo delete "$org/$repo" --yes || echo "Failed to delete: $org/$repo"
done < "$filename"

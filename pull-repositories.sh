#!/bin/bash

# # Alon Hillel-Tuch github.com/ahillelt
# Generates a list of repositories in an organization that are forks of a specified repository
# Usage: ./pull-repositories.sh <org> <base_repo_prefix>
# Example: ./pull-repositories.sh nyuappsec NYUAppSec/nyuappsec-cyber-fall-2024 > fallrepo.csv
#
# Credits to @tspascoal from this repo: https://github.com/tspascoal/dependabot-alerts-helper
# Credits to @joshjohanning from this repo: https://github.com/joshjohanning/github-misc-scripts/blob/main/gh-cli/

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <org> <base_repo_prefix>"
    exit 1
fi

org=$1
base_repo_prefix=$2

# Fetch repository data and filter in Bash
gh api graphql --paginate -F org="$org" -f query='
query($org: String!, $endCursor: String) {
  organization(login: $org) {
    repositories(first: 100, after: $endCursor) {
      pageInfo {
        hasNextPage
        endCursor
      }
      nodes {
        name
        isFork
        parent {
          owner {
            login
          }
          name
        }
      }
    }
  }
}' --template '{{range .data.organization.repositories.nodes}}{{.name}},{{.isFork}},{{if .parent}}{{.parent.owner.login}}/{{.parent.name}}{{end}}{{"\n"}}{{end}}' \
| while IFS=',' read -r repo_name is_fork parent_repo; do
    # Check if the repository is a fork and the parent matches the base_repo_prefix
    if [[ "$is_fork" == "true" && "$parent_repo" == "$base_repo_prefix"* ]]; then
        echo "$org/$repo_name"
    fi
done

# Ensure the output ends with an empty line
echo

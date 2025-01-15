# GitHub Repo Management Scripts

This repository contains scripts to manage repositories within a GitHub organization. You can use these scripts to:
- Generate a list of repositories in your GitHub organization.
- Delete repositories based on a specified prefix.

I really needed this functionality for some of the courses I teach at NYU which has students creating repositories for assignments each semester. 

Idea credits to @tspascoal from this repo: https://github.com/tspascoal/dependabot-alerts-helper and to @joshjohanning from this repo: https://github.com/joshjohanning/github-misc-scripts/blob/main/gh-cli/

## Prerequisites

1. **GitHub CLI (`gh`)**:
   - You need to have the GitHub CLI (`gh`) installed and authorized to interact with your GitHub account.
   - To install GitHub CLI, follow the instructions here: [GitHub CLI installation](https://cli.github.com/).

2. **Authentication**:
   - Make sure you are logged in to GitHub CLI:
     ```bash
     gh auth login
     ```

3. **Delete Permissions**:
   - To delete repositories, you need to ensure that you have the `delete_repo` scope:
     ```bash
     gh auth refresh -h github.com -s delete_repo
     ```

4. **Verify Installation**:
   - Ensure that `gh` is installed correctly by running:
     
     ```bash
     where gh  # For Windows
     gh --version  # To check the version of GitHub CLI
     ```

     ```bash
     which gh  # For Linux
     gh --version  # To check the version of GitHub CLI
     ```

---

## Usage Instructions

### 1. **Manual Usage**

There are two main scripts you can run manually:

#### `pull-repositories.sh` — Generate a List of Repositories

This script generates a list of repositories in an organization that are forks of a specified repository. The output is a list of repositories written to a CSV file.

**Usage:**
```bash
./pull-repositories.sh <org> <base_repo_prefix>
```

- `<org>`: The name of the GitHub organization.
- `<base_repo_prefix>`: The prefix of the parent repository you want to filter forks by.

Example:
```bash
./pull-repositories.sh nyuappsec NYUAppSec/nyuappsec-cyber-fall-2024 > repos.csv
```

This will generate a `repos.csv` file containing all the repositories in `nyuappsec` that are forks of repositories starting with `NYUAppSec/nyuappsec-cyber-fall-2024`.

#### `delete-repositories-from-list.sh` — Delete Repositories from a CSV List

This script deletes repositories from a list specified in a CSV file, where each line contains a repository in the format `org/repo`.

**Usage:**
```bash
./delete-repositories-from-list.sh <reposfilename>
```

- `<reposfilename>`: The path to the CSV file containing the list of repositories to be deleted.

Example:
```bash
./delete-repositories-from-list.sh repos.csv
```

The script will read the list of repositories from `repos.csv` and delete them one by one.

### 2. **Automated Usage**

If you prefer to automate the entire process (generate the list and delete the repositories), you can use the `auto-delete.sh` script, which combines `pull-repositories.sh` and `delete-repositories-from-list.sh`.

#### `auto-delete.sh` — Automatically Generate and Delete Repositories

This script runs `pull-repositories.sh` to generate the list of repositories and then calls `delete-repositories-from-list.sh` to delete them.

**Usage:**
```bash
./auto-delete.sh <org> <base_repo_prefix>
```

- `<org>`: The name of the GitHub organization.
- `<base_repo_prefix>`: The prefix of the parent repository you want to filter forks by.

Example:
```bash
./auto-delete.sh nyuappsec NYUAppSec/nyuappsec-cyber-fall-2024
```

This will:
1. Generate a list of repositories in `nyuappsec` that are forks of repositories starting with `NYUAppSec/nyuappsec-cyber-fall-2024`.
2. Delete those repositories.
3. Clean up the temporary `repos.csv` file.

---

## Notes

- **Permissions**: You must have the necessary permissions (e.g., `delete_repo`) to delete repositories in the organization.
- **Confirmation**: The `delete-repositories-from-list.sh` script automatically deletes the repositories. Be careful when running these scripts.
- **CSV Format**: Ensure the CSV file used with `delete-repositories-from-list.sh` follows the format `org/repo`, with one repository per line.

---

## Troubleshooting

1. **GitHub CLI not working**:
   - If `gh` is not recognized or doesn't work, make sure it is installed and available in your PATH.
   - To verify, run the following commands:
     - On Windows:
       ```bash
       where gh
       ```
     - On Linux/macOS:
       ```bash
       which gh
       ```
   - If `gh` is installed but not recognized, ensure it’s added to your system's PATH.
   
2. **Missing `delete_repo` permission**:
   - If you don't have the `delete_repo` scope, you'll need to add it using the following command:
     ```bash
     gh auth refresh -h github.com -s delete_repo
     ```

---

## Example Workflow

1. **Generate the list of repositories**:
   ```bash
   ./pull-repositories.sh nyuappsec NYUAppSec/nyuappsec-cyber-fall-2024
   ```

2. **Delete the repositories from the list**:
   ```bash
   ./delete-repositories-from-list.sh repos.csv
   ```

3. **Alternatively, use the automated script**:
   ```bash
   ./auto-delete.sh nyuappsec NYUAppSec/nyuappsec-cyber-fall-2024
   ```

---
## Restore Window

You can always quickly restore any deleted repo within a 90 day window, see here: https://docs.github.com/en/repositories/creating-and-managing-repositories/restoring-a-deleted-repository
May develop script to automate restore if I end up facing this issue or others request. 

Hope it helps folks!

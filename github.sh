#!/bin/bash

# Function to setup GitHub credentials
setup_github_credentials() {
    # Prompt the user for the GitHub username
    read -p 'Enter your GitHub username: ' GITHUB_USERNAME

    # Prompt the user for the GitHub token
    read -sp 'Enter your GitHub token: ' GITHUB_TOKEN
    echo
}

# Function to remove existing directory and clone repository
clone_repository() {
    local org_name=$1
    local repo_name=$2
    local repo_url="https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/$org_name/$repo_name"

    # Remove existing directory
    rm -rf "$repo_name"

    # Clone repository
    git clone "$repo_url"

    # Return repository name
    echo "$repo_name"
}

# Function to create VS Code workspace file
create_workspace_file() {
    local workspace_name=$1
    shift
    local folder_names=("$@")

    # Create workspace file
    local workspace_file="${workspace_name}.code-workspace"
    echo '{
    "folders": [' > "$workspace_file"

    # Add folder configurations
    for folder_name in "${folder_names[@]}"; do
        echo '        {
            "path": "'"$folder_name"'"
        },' >> "$workspace_file"
    done

    # Remove trailing comma from the last folder configuration
    sed -i '$ s/,$//' "$workspace_file"

    # Close workspace file
    echo '    ]
}' >> "$workspace_file"

    # Print success message
    echo "Workspace file '$workspace_file' created successfully."
}

# 
# Usage
# 

# Setup GitHub credentials
# setup_github_credentials

# Checkout repositories as well as create a VS Code workspace with such projects added
# create_workspace_file "your-workspace-name" \
#     $(clone_repository "org1" "repo1") \
#     $(clone_repository "org1" "repo2")


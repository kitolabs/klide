function Setup-GitHubCredentials {
    # Prompt the user for the GitHub username
    $GitHubUsername = Read-Host "Enter your GitHub username"

    # Prompt the user for the GitHub token (hidden input)
    $GitHubToken = Read-Host "Enter your GitHub token" -AsSecureString

    # Convert the secure string back to plain text for use (if necessary)
    $GitHubTokenPlainText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($GitHubToken))

    # Store the username and token in environment variables
    [System.Environment]::SetEnvironmentVariable("GITHUB_USERNAME", $GitHubUsername, [System.EnvironmentVariableTarget]::Process)
    [System.Environment]::SetEnvironmentVariable("GITHUB_TOKEN", $GitHubTokenPlainText, [System.EnvironmentVariableTarget]::Process)

    Write-Host "GitHub credentials stored in environment variables."
}

function Clone-Repository {
    param (
        [string]$OrgName,
        [string]$RepoName
    )

    # Retrieve the username and token from environment variables
    $GitHubUsername = [System.Environment]::GetEnvironmentVariable("GITHUB_USERNAME", [System.EnvironmentVariableTarget]::Process)
    $GitHubToken = [System.Environment]::GetEnvironmentVariable("GITHUB_TOKEN", [System.EnvironmentVariableTarget]::Process)

    # Check if credentials are available
    if (-not $GitHubUsername -or -not $GitHubToken) {
        Write-Host "Error: GitHub credentials are not set. Run Setup-GitHubCredentials first."
        return
    }

    # Construct the repository URL using the credentials
    $RepoUrl = "https://$($GitHubUsername):$($GitHubToken)@github.com/$($OrgName)/$($RepoName)"

    # Remove existing directory if it exists
    if (Test-Path -Path $RepoName) {
        Remove-Item -Recurse -Force -Path $RepoName
        Write-Host "Removed existing directory: $RepoName"
    }

    # Clone the repository using Git
    git clone $RepoUrl

    Write-Host "GitHub credentials stored "

    # Return the repository name
    return $RepoName
}

function Create-WorkspaceFile {
    param (
        [string]$WorkspaceName,
        [string[]]$FolderNames
    )

    # Define the path to the workspace file
    $WorkspaceFile = "$WorkspaceName.code-workspace"

    # Create a workspace file with initial content
    $jsonContent = @{
        folders = @()
    }

    foreach ($folderName in $FolderNames) {
        $jsonContent.folders += @{
            path = $folderName
        }
    }

    # Convert the content to JSON and format it
    $jsonString = $jsonContent | ConvertTo-Json -Depth 10 -Compress

    # Write the JSON content to the workspace file
    $jsonString | Set-Content -Path $WorkspaceFile -Encoding UTF8

    # Print success message
    Write-Host "Workspace file '$WorkspaceFile' created successfully."
}

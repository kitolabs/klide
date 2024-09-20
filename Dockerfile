# Use the official PowerShell image as the base
FROM mcr.microsoft.com/powershell:latest

# Install Git
RUN apt-get update && apt-get install -y git

# Set the default command to PowerShell
CMD ["pwsh"]

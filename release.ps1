# PowerShell script for managing KeyPad installer releases

param(
    [Parameter(Mandatory=$true)]
    [string]$Version,
    
    [Parameter(Mandatory=$true)]
    [string]$ReleaseNotes,
    
    [Parameter(Mandatory=$true)]
    [string]$InstallerPath
)

# Configuration
$REPO_NAME = "application"
$GITHUB_USERNAME = "SinTuch"

# Create release directory
$RELEASE_DIR = "releases/v$Version"
New-Item -ItemType Directory -Force -Path $RELEASE_DIR

# Copy installer to release directory with both names
Copy-Item -Path $InstallerPath -Destination "$RELEASE_DIR/SinTuch.exe"

# Create release notes file
$RELEASE_NOTES_PATH = "$RELEASE_DIR/release-notes.md"
@"
# KeyPad v$Version Release Notes

$ReleaseNotes

## Program Information
- File: SinTuch.exe
- Version: 1.0.0
- Type: Main Program

## Installation
1. Download SinTuch.exe
2. Place it in your desired location
3. Run the program

## System Requirements
- Windows 10/11
- USB port for KeyPad device
- Internet connection for updates
"@ | Out-File -FilePath $RELEASE_NOTES_PATH -Encoding UTF8

# Create checksum
$CHECKSUM = Get-FileHash -Path "$RELEASE_DIR/SinTuch.exe" -Algorithm SHA256
@"
SHA256: $($CHECKSUM.Hash)
File: SinTuch.exe
Version: $Version
"@ | Out-File -FilePath "$RELEASE_DIR/checksum.txt" -Encoding UTF8

Write-Host "Release package created in $RELEASE_DIR"
Write-Host "Next steps:"
Write-Host "1. Create a new release on GitHub"
Write-Host "2. Upload the files from $RELEASE_DIR"
Write-Host "3. Copy the release notes from $RELEASE_NOTES_PATH"
Write-Host "4. Publish the release" 
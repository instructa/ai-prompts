# Script to rename all .md files to .mdc files in the prompts directory
# Usage: .\rename_md_to_mdc.ps1

# Get all .md files recursively in the prompts directory
$files = Get-ChildItem -Path ".\prompts" -Filter "*.md" -Recurse

Write-Host "Found $($files.Count) .md files to rename to .mdc."

# Initialize counters
$renamed = 0

# Rename each file
foreach ($file in $files) {
    # Get the directory and filename
    $directory = $file.DirectoryName
    $filename = $file.Name
    
    # Create the new filename
    $newFilename = $filename.Replace(".md", ".mdc")
    
    # Full paths
    $oldPath = Join-Path -Path $directory -ChildPath $filename
    $newPath = Join-Path -Path $directory -ChildPath $newFilename
    
    # Rename the file
    try {
        Rename-Item -Path $oldPath -NewName $newFilename
        Write-Host "Renamed: $oldPath to $newPath"
        $renamed++
    } catch {
        Write-Host "Failed to rename: $oldPath"
    }
}

Write-Host "Renamed $renamed out of $($files.Count) files." 
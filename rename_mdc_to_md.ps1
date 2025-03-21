# Script to rename all .mdc files to .md files in the prompts directory
# Usage: .\rename_mdc_to_md.ps1

# Get all .mdc files recursively in the prompts directory
$files = Get-ChildItem -Path ".\prompts" -Filter "*.mdc" -Recurse

Write-Host "Found $($files.Count) .mdc files to rename to .md."

# Initialize counters
$renamed = 0

# Rename each file
foreach ($file in $files) {
    # Get the directory and filename
    $directory = $file.DirectoryName
    $filename = $file.Name
    
    # Create the new filename
    $newFilename = $filename.Replace(".mdc", ".md")
    
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
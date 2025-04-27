# Folder Size Analyzer Script
# Created by Alfa

# Set the target path (modify this if needed)
$targetPath = "C:\Users\bayea\Documents"

# Get all folders recursively
$folders = Get-ChildItem -Path $targetPath -Directory -Recurse

# Create a list to hold folder sizes
$folderSizes = foreach ($folder in $folders) {
    try {
        $folderSize = (Get-ChildItem -Path $folder.FullName -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        [PSCustomObject]@{
            FolderName = $folder.FullName
            SizeMB     = "{0:N2}" -f ($folderSize / 1MB)
        }
    } catch {
        Write-Host "Error accessing $($folder.FullName): $_"
    }
}

# Sort by folder size descending and display
$folderSizes | Sort-Object -Property SizeMB -Descending | Format-Table -AutoSize

# (Optional) Export to CSV report
#$folderSizes | Sort-Object -Property SizeMB -Descending | Export-Csv -Path "$env:PFT\Desktop\FolderSizeReport.csv" -NoTypeInformation

Write-Host "`nAnalysis complete."

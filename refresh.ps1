# Define the path to search
$path = "C:\Users\Legion\Desktop"

# Define the file extension filter
$filter = "*.mbu"

# Get the list of .mbu files recursively and process each file
Get-ChildItem -Path $path -Filter $filter -Recurse | ForEach-Object {
    # Extract the full name and name without extension
    $fullName = $_.Name
    $nameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($fullName)

    # Start the regedit process with the specified .reg file
    $regFilePath = "C:\Program Files\currone\DesktopManager\reg\$nameWithoutExtension.reg"
    Start-Process "regedit.exe" -ArgumentList "/s", "`"$regFilePath`"" -NoNewWindow -Wait | Wait-Process
    
    # Wait for a second
    Start-Sleep 1
    
    # Stop the explorer process
    Stop-Process -Name explorer -Force

    # Write "done" to the console
    Write-Output "done"
}

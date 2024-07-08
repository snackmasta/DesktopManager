# Define the path to search
$path = "C:\Users\Legion\Desktop"

# Define the file extension filter
$filter = "*.mbu"

# Get the list of .mbu files recursively and process each file
Get-ChildItem -Path $path -Filter $filter -Recurse | ForEach-Object {
    # Extract the full name and name without extension
    $fullName = $_.Name
    $nameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($fullName)

    # Start the robocopy process with the /MIR switch
    $process = Start-Process -NoNewWindow -FilePath "robocopy" -ArgumentList "C:\Users\Legion\Desktop E:\Obsidian\shigoto\$nameWithoutExtension /MIR /COPY:DATS /R:0 /W:0 /XO /NFL /NDL /NJH /NJS /NS /NC /NP" -PassThru

    # Wait for the process to complete
    $process | Wait-Process

    # Write "done" to the console
    Write-Output "done"
}

$outputFilePath = "C:\Program Files\currone\DesktopManager\reg\$nameWithoutExtension.reg"

# Remove the file if it already exists
if (Test-Path $outputFilePath) {
    Remove-Item $outputFilePath -Force
}

reg export "HKCU\SOFTWARE\Microsoft\Windows\Shell\Bags\1\Desktop" $outputFilePath

# Define the content of the new .ps1 script
$scriptContent = @"
# clear desktop directory completely using rm -force
Remove-Item -Path "C:\Users\Legion\Desktop" -Recurse -Force

# Start the robocopy process with the /MIR switch

# Wait for the process to complete
Start-Process -NoNewWindow -FilePath "robocopy" -ArgumentList "E:\Obsidian\shigoto\$nameWithoutExtension C:\Users\Legion\Desktop /MIR /COPY:DATS /R:0 /W:0 /XO /NFL /NDL /NJH /NJS /NS /NC /NP" -PassThru | Wait-Process

# Write "done" to the console
Write-Output "done"
regedit.exe /s '"C:\Program Files\currone\DesktopManager\reg\$nameWithoutExtension.reg"'
Stop-Process -Name explorer -Force
"@

# Write the content to the new .ps1 script file
$scriptContent | Out-File -FilePath "C:\Program Files\currone\DesktopManager\profiles\$nameWithoutExtension.ps1" -Encoding ascii
Invoke-PS2EXE "C:\Program Files\currone\DesktopManager\profiles\$nameWithoutExtension.ps1" "C:\Program Files\currone\DesktopManager\bin\$nameWithoutExtension.exe" -requireAdmin
$profiles = Get-ChildItem "C:\Program Files\currone\DesktopManager\reg"

# Display the list with numbered items and last modified time
for ($i = 0; $i -lt $profiles.Count; $i++) {
    Write-Host ("{0}. {1} (Last Modified: {2})" -f ($i + 1), $profiles[$i].Name, $profiles[$i].LastWriteTime)
}

# Prompt the user to pick a number
$choice = Read-Host -Prompt "Enter the number of the profile you want to choose"

# Validate the user's input
if ($choice -ge 1 -and $choice -le $profiles.Count) {
    # Get the selected profile path
    $selectedProfile = $profiles[$choice - 1].Name

    # Remove the extension from the selected profile
    $selectedProfileWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($selectedProfile)

    # Get the directory path from the text file
    $directoryPath = Get-Content -Path "C:\Program Files\currone\DesktopManager\data\directory.txt"
    $regPath = "C:\Program Files\currone\DesktopManager\reg\" + $selectedProfile
    $scriptPath = "C:\Program Files\currone\DesktopManager\profiles\" + $selectedProfileWithoutExtension + ".ps1"

    # Perform the desired action with the selected profile and directory path
    Remove-Item -Path ($directoryPath + "\" + $selectedProfileWithoutExtension) -Recurse -Force
    Remove-Item -Path $regPath
    Remove-Item -Path $scriptPath

    Write-Host $selectedProfileWithoutExtension
    Start-Sleep 5
    # Close the console
    exit
} else {
    Write-Host "Invalid selection. Please try again."
}
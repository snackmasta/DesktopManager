$profiles = Get-ChildItem "C:\Program Files\currone\DesktopManager\reg" | Sort-Object LastWriteTime -Descending

# Display the list with numbered items and last modified time
for ($i = 0; $i -lt $profiles.Count; $i++) {
    $lastModifiedDate = $profiles[$i].LastWriteTime
    $timeDifference = New-TimeSpan -Start $lastModifiedDate -End (Get-Date)

    if ($timeDifference.TotalHours -lt 24) {
        $lastModifiedInfo = "{0} hours ago" -f [math]::Round($timeDifference.TotalHours)
    } elseif ($timeDifference.TotalDays -lt 7) {
        $lastModifiedInfo = "{0} days ago" -f [math]::Round($timeDifference.TotalDays)
    } elseif ($timeDifference.TotalDays -lt 30) {
        $lastModifiedInfo = "{0} weeks ago" -f [math]::Round($timeDifference.TotalDays / 7)
    } else {
        $lastModifiedInfo = $lastModifiedDate.ToString("yyyy-MM-dd HH:mm:ss")
    }

    Write-Host ("{0}. {1} (Last Modified: {2})" -f ($i + 1), $profiles[$i].Name, $lastModifiedInfo)
}

# Prompt the user to pick a number
$choice = Read-Host -Prompt "Enter the number of the profile you want to choose"

# Validate the user's input by converting to integer
$choice = [int]$choice

if ($choice -ge 1 -and $choice -le $profiles.Count) {
    # Get the selected profile path
    $selectedProfile = $profiles[$choice - 1].Name

    Write-Host "Selected profile: $selectedProfile"

    # Remove the extension from the selected profile
    $selectedProfileWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($selectedProfile)

    Write-Host "Selected profile without extension: $selectedProfileWithoutExtension"

    # Add ".exe" extension to the selected profile
    $selectedProfileWithoutExtension = $selectedProfileWithoutExtension + ".exe"

    Write-Host "Selected profile without extension with.exe extension: $selectedProfileWithoutExtension"

    # Run the selected profile
    $path = "C:\Program Files\currone\DesktopManager\bin"
    [System.Diagnostics.Process]::Start($path + "\\" + $selectedProfileWithoutExtension)

    exit

} else {
    Write-Host "Invalid selection. Please try again."
}

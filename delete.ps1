do {    
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

    # Prompt the user to pick a number (text red colored)
    Write-Host -NoNewline -ForegroundColor Red "Enter the number of the profile you want to choose: "
    $choice = [System.Console]::ReadLine()

    # Validate the user's input by converting to integer
    $choice = [int]$choice

    if ($choice -ge 1 -and $choice -le $profiles.Count) {
        # Get the selected profile path
        $selectedProfile = $profiles[$choice - 1].Name

        Write-Host "Selected profile: $selectedProfile"

        # Remove the extension from the selected profile
        $selectedProfileWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($selectedProfile)

        Write-Host "Selected profile without extension: $selectedProfileWithoutExtension"

        # Get the directory path from the text file
        $directoryPath = Get-Content -Path "C:\Program Files\currone\DesktopManager\data\directory.txt"
        Write-Host "Directory path: $directoryPath"

        $regPath = "C:\Program Files\currone\DesktopManager\reg\" + $selectedProfile
        $scriptPath = "C:\Program Files\currone\DesktopManager\profiles\" + $selectedProfileWithoutExtension + ".ps1"
        $binaryPath = "C:\Program Files\currone\DesktopManager\bin\" + $selectedProfileWithoutExtension + ".exe"

        Write-Host "Registry path: $regPath"
        Write-Host "Script path: $scriptPath"
        Write-Host "Binary path: $binaryPath"

        # Perform the desired action with the selected profile and directory path
        Write-Host "Removing directory: $directoryPath\$selectedProfileWithoutExtension"
        Remove-Item -Path ($directoryPath + "\" + $selectedProfileWithoutExtension) -Recurse -Force

        Write-Host "Removing registry file: $regPath"
        Remove-Item -Path $regPath

        Write-Host "Removing script file: $scriptPath"
        Remove-Item -Path $scriptPath

        Write-Host "Removing binary file: $binaryPath"
        Remove-Item -Path $binaryPath

        Write-Host "Profile $selectedProfileWithoutExtension has been removed."
        Start-Sleep 5

        # Close the console
        exit
    } else {
        Write-Host "Invalid selection. Please try again."
    }
} while ($true);
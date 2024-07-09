function Save-Profile {
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
}

function Get-Profile {
    # Get the selected profile path
    $selectedProfile = $profiles[$choiceInt - 1].Name

    Write-Host "Selected profile: $selectedProfile"

    # Remove the extension from the selected profile
    $selectedProfileWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($selectedProfile)

    Write-Host "Selected profile without extension: $selectedProfileWithoutExtension"

    # Add ".exe" extension to the selected profile
    $selectedProfileWithoutExtension = $selectedProfileWithoutExtension + ".exe"

    Write-Host "Selected profile without extension with .exe extension: $selectedProfileWithoutExtension"

    # Run the selected profile
    $path = "C:\Program Files\currone\DesktopManager\bin"
    [System.Diagnostics.Process]::Start($path + "\\" + $selectedProfileWithoutExtension)
}

do {
    $profiles = Get-ChildItem "C:\Program Files\currone\DesktopManager\reg" | Sort-Object LastWriteTime -Descending

    # Display the list with numbered items and last modified time
    for ($i = 0; $i -lt $profiles.Count; $i++) {
        $lastModifiedDate = $profiles[$i].LastWriteTime
        $timeDifference = New-TimeSpan -Start $lastModifiedDate -End (Get-Date)

        if ($timeDifference.TotalMinutes -lt 60) {
            $lastModifiedInfo = "{0} minutes ago" -f [math]::Round($timeDifference.TotalMinutes)
        } elseif ($timeDifference.TotalHours -lt 24) {
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

    # If the user input a number convert it to a integer If the user input a string convert it to a string
    $choiceInt = [System.Convert]::ToInt32($choice)
    $choiceString = $choice.ToString()

    if ($choiceInt -ge 1 -and $choiceInt -le $profiles.Count -and $choiceString -ne "save") {
        Get-Profile
        # Clear console
        Clear-Host
    } elseif ($choiceString -eq "save") {
        # Call the Find-Profile function
        $profileNames = Save-Profile
        Write-Host "Found profiles: $profileNames"
        # Clear console
        Clear-Host
    }

} while ($true)
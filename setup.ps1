Add-Type -AssemblyName System.Windows.Forms

function Select-AppLocation {
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Select App Location"
    $folderBrowser.ShowNewFolderButton = $true

    $result = $folderBrowser.ShowDialog()
    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        return $folderBrowser.SelectedPath
    } else {
        return $null
    }
}

function Select-ProfileLocation {
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Select Profile Location"
    $folderBrowser.ShowNewFolderButton = $true

    $result = $folderBrowser.ShowDialog()
    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        return $folderBrowser.SelectedPath
    } else {
        return $null
    }
}

$sourceLocation = Select-AppLocation
$profileLocation = Select-ProfileLocation

if ($sourceLocation -and $profileLocation) {
    # append the string to txt file
    New-Item -ItemType Directory -Path (Join-Path -Path $sourceLocation -ChildPath "currone\DesktopManager\data")
    $sourceFile = Join-Path -Path $sourceLocation -ChildPath "currone\DesktopManager\data\appDir.txt"
    $profileFile = Join-Path -Path $profileLocation -ChildPath "currone\DesktopManager\data\deskDir.txt"
    Add-Content -Path $sourceFile -Value $sourceLocation
    Add-Content -Path $profileFile -Value $profileLocation

} else {
    Write-Output "No folder selected."
}

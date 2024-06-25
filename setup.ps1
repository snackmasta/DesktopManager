Add-Type -AssemblyName System.Windows.Forms

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

$profileLocation = Select-ProfileLocation

$profileLocation | Out-File -FilePath "C:\Program Files\currone\DesktopManager\data\directory.txt" -Encoding ascii
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

$selectedFolder = Select-AppLocation
$profileLocation = Select-ProfileLocation
if ($selectedFolder) {
    Write-Output "Selected folder: $selectedFolder"
    Write-Output "Selected folder: $profileLocation"
} else {
    Write-Output "No folder selected."
}

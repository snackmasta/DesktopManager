# Desktop Manager

## Overview
Desktop Manager is a PowerShell-based utility designed to manage desktop configurations by utilizing the `robocopy` tool for mirroring directories. It also handles registry exports and imports for desktop settings, and provides functionality to clear and restore desktop contents.

## Features
- Recursively searches for `.mbu` files in a specified directory.
- Uses `robocopy` with the `/MIR` switch to mirror directories.
- Exports desktop settings to a registry file.
- Clears desktop contents and restores them from a backup.
- Converts PowerShell scripts to executable files.

## Prerequisites
- PowerShell 5.1 or later
- `robocopy` utility
- `PS2EXE` module for converting PowerShell scripts to executables

## Installation
1. Clone the repository or download the source code.
2. Ensure that the `PS2EXE` module is installed by running:
    ```powershell
    Install-Module -Name PS2EXE -Scope CurrentUser
    ```
3. Place the scripts and required directories in the desired location.

## Usage
### Define the Path and File Extension
Set the path to search and the file extension filter in the script:
```powershell
$path = "C:\Users\Legion\Desktop"
$filter = "*.mbu"
```

### Process Each `.mbu` File
The script recursively searches for `.mbu` files, processes each file, and mirrors directories using `robocopy`:
```powershell
Get-ChildItem -Path $path -Filter $filter -Recurse | ForEach-Object {
    $fullName = $_.Name
    $nameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($fullName)

    $process = Start-Process -NoNewWindow -FilePath "robocopy" -ArgumentList "C:\Users\Legion\Desktop E:\Obsidian\shigoto\$nameWithoutExtension /MIR /COPY:DATS /R:0 /W:0 /XO /NFL /NDL /NJH /NJS /NS /NC /NP" -PassThru
    $process | Wait-Process

    Write-Output "done"
}
```

### Export and Remove Registry Entries
Export the current desktop settings to a registry file and remove the existing file if it already exists:
```powershell
$outputFilePath = "C:\Program Files\currone\DesktopManager\reg\$nameWithoutExtension.reg"

if (Test-Path $outputFilePath) {
    Remove-Item $outputFilePath -Force
}

reg export "HKCU\SOFTWARE\Microsoft\Windows\Shell\Bags\1\Desktop" $outputFilePath
```

### Create and Execute the New PowerShell Script
Generate a new PowerShell script to clear and restore the desktop, and convert it to an executable:
```powershell
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

$scriptContent | Out-File -FilePath "C:\Program Files\currone\DesktopManager\profiles\$nameWithoutExtension.ps1" -Encoding ascii
Invoke-PS2EXE "C:\Program Files\currone\DesktopManager\profiles\$nameWithoutExtension.ps1" "C:\Program Files\currone\DesktopManager\bin\$nameWithoutExtension.exe" -requireAdmin
```

## Contributing
Contributions are welcome! Feel free to submit issues or pull requests for improvements or bug fixes.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
```

This `README.md` file provides an overview of the software, installation instructions, usage examples, and contributing guidelines. Feel free to adjust the content based on specific details and requirements of your project.
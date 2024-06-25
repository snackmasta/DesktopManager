# clear desktop directory completely using rm -force
Remove-Item -Path "C:\Users\Legion\Desktop" -Recurse -Force

# Start the robocopy process with the /MIR switch

# Wait for the process to complete
Start-Process -NoNewWindow -FilePath "robocopy" -ArgumentList "E:\Obsidian\shigoto\$nameWithoutExtension C:\Users\Legion\Desktop /MIR /COPY:DATS /R:0 /W:0 /XO /NFL /NDL /NJH /NJS /NS /NC /NP" -PassThru | Wait-Process

# Write "done" to the console
Write-Output "done"

Start-Process "regedit.exe" -ArgumentList "/s", "C:\Program Files\currone\DesktopManager\reg\$nameWithoutExtension.reg" -NoNewWindow -Wait
Stop-Process -Name explorer -Force; Start-Process explorer

$deskData = 

Start-Process -NoNewWindow -FilePath "robocopy" -ArgumentList '"C:\Users\Legion\Desktop" '$deskData' /E /COPY:DATS /R:0 /W:0 /XO /NFL /NDL /NJH /NJS /NS /NC /NP'

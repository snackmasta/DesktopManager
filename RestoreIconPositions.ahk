^!r:: ; Ctrl+Alt+R to restore positions
    ; Ensure the file exists
    if FileExist("C:\Program Files\currone\DesktopManager\IconPositions.txt")
    {
        FileRead, IconList, C:\Program Files\currone\DesktopManager\IconPositions.txt
        StringSplit, IconArray, IconList, |
        ControlGet, hwnd, Hwnd,, SysListView321, ahk_class Progman
        
        Loop %IconArray0%
        {
            StringSplit, IconData, IconArray%A_Index%, `,
            LV_SetItemPos(hwnd, IconData1, IconData2, IconData3)
        }
    }
    else
    {
        MsgBox, The file C:\Program Files\currone\DesktopManager\IconPositions.txt does not exist.
    }
return

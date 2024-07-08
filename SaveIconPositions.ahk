^!s:: ; Ctrl+Alt+S to save positions
    ; Ensure the directory exists
    FileCreateDir, C:\Program Files\currone\DesktopManager
    
    WinGetPos, , , DeskWidth, DeskHeight, Program Manager
    IconCount := DllCall("Shell32\SHGetSpecialFolderLocation", "uint", 0, "int", 0, "uint*", pidl) + 0
    ControlGet, hwnd, Hwnd,, SysListView321, ahk_class Progman
    
    IconList := ""
    
    Loop %IconCount%
    {
        LV_GetItemPos(hwnd, A_Index - 1, xpos, ypos)
        IconList .= A_Index - 1 . "," . xpos . "," . ypos . "|"
    }
    
    FileAppend, %IconList%, C:\Program Files\currone\DesktopManager\IconPositions.txt
return

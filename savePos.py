import ctypes
from ctypes import wintypes

# Define necessary Windows API functions and constants
SPI_GETICONMETRICS = 0x002F
SPI_SETICONMETRICS = 0x0030

# Define the required Windows structures and functions
class POINT(ctypes.Structure):
    _fields_ = [("x", ctypes.c_long), ("y", ctypes.c_long)]

def get_desktop_icon_positions():
    # Get the desktop window handle
    hwnd_desktop = ctypes.windll.user32.GetDesktopWindow()
    
    # Find the desktop folder window
    hwnd_desktop_folder = ctypes.windll.user32.FindWindowExW(hwnd_desktop, 0, "SHELLDLL_DefView", None)
    if not hwnd_desktop_folder:
        raise Exception("Unable to find the desktop folder window.")
    
    # Find the list view control that holds the icons
    hwnd_icons_view = ctypes.windll.user32.FindWindowExW(hwnd_desktop_folder, 0, "SysListView32", None)
    if not hwnd_icons_view:
        raise Exception("Unable to find the SysListView32 window.")
    
    # Get the number of icons
    item_count = ctypes.windll.user32.SendMessageW(hwnd_icons_view, 0x1004, 0, 0)  # LVM_GETITEMCOUNT
    
    icon_positions = []
    for i in range(item_count):
        # Get the item position
        pos = POINT()
        ctypes.windll.user32.SendMessageW(hwnd_icons_view, 0x100B, i, ctypes.byref(pos))  # LVM_GETITEMPOSITION
        icon_positions.append((pos.x, pos.y))
    
    return icon_positions

if __name__ == "__main__":
    try:
        positions = get_desktop_icon_positions()
        for pos in positions:
            print(f"Icon Position: {pos}")
    except Exception as e:
        print(e)

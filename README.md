# Beeper.AppImage trayIcon patcher

### This script replaces the systray icons of Beeper (Linux).
- It unpacks the appimage and the internal asar archive
- It replaces all `trayIcon` and `trayUnreadIcon` files with custom ones
- It repacks the asar archive and the appimage

### Dependencies
- appimagetool.AppImage (from github.com/AppImage/appimagetool)
- asar                  (from your package manager of choice)

### Required files
- patch.sh
- Beeper.AppImage
- appimagetool.AppImage
- trayIcon.png
- trayUnreadIcon.png

### The script checks everything
- If everything is ok it's all automatic
- If not you'll be told what's missing"

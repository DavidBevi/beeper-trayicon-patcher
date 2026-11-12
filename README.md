# Beeper.AppImage trayIcon patcher
This script replaces the systray icons of Beeper (Linux).
It unpacks Beeper.AppImage, then unpacks the underlying ASAR archive,
then finds the trayIcon/trayUnreadIcon files and replaces them, then
repacks the ASAR archive and finally outputs a new AppImage.

### DEPENDENCIES
- appimagetool.AppImage (from github.com/AppImage/appimagetool)
- asar                  (from your package manager of choice)

### REQUIRED FILES ALONGSIDE THIS SCRIPT
- Beeper.AppImage       (tested with v4.3.284)
- appimagetool.AppImage (tested with build 370)
- trayIcon.png          (any new icon, suggested size 32x32 pixels)
- trayUnreadIcon.png    (any new icon, suggested size 32x32 pixels)

### THE SCRIPT CHECKS EVERYTHING
- If everything is ok it's all automatic
- If not you'll be told what's missing"

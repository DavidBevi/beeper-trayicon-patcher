# beeper-trayicon-patcher<br><sub><sup>A script to customize the systray icons of Beeper AppImage (Linux)</sup></sub>

### Dependencies
- install `asar` [`[EXT SOURCE]`](https://github.com/electron/asar)

### Prep (in the same folder)
- download [`patch.sh`](https://downgit.github.io/#/home?url=https://github.com/DavidBevi/beeper-trayicon-patcher/raw/main/patch.sh) (it's the script!) 
- download [`trayIcon.png`](https://downgit.github.io/#/home?url=https://github.com/DavidBevi/beeper-trayicon-patcher/raw/main/trayIcon.png) (or provide your own)
- download [`trayUnreadIcon.png`](https://downgit.github.io/#/home?url=https://github.com/DavidBevi/beeper-trayicon-patcher/raw/main/trayUnreadIcon.png) (or provide your own)
- download `appimagetool.AppImage` [`[EXT SOURCE]`](https://github.com/AppImage/appimagetool/releases/tag/continuous)
- download `Beeper.AppImage` [`[EXT SOURCE]`](https://beeper.com)

### Usage
- `[GUI]` double-click on `patch.sh`, or drag-n-drop `Beeper.AppImage` onto `patch.sh`
- `[CLI]` `source patch.sh` or `source patch.sh "path/to/Beeper.AppImage"`

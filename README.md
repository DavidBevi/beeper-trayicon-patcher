# beeper-trayicon-patcher<br><sub><sup>A script to customize the systray icons of Beeper AppImage (Linux)</sup></sub>

### Dependencies
- install `asar` [`[EXT SOURCE]`](https://github.com/electron/asar)

### Prep (in the same folder)
- download [`patch.sh`](https://git-link.vercel.app/api/download?url=https%3A%2F%2Fgithub.com%2FDavidBevi%2Fbeeper-trayicon-patcher%2Fblob%2Fmain%2Fpatch.sh) (it's the script!) 
- download [`trayIcon.png`](https://git-link.vercel.app/api/download?url=https%3A%2F%2Fgithub.com%2FDavidBevi%2Fbeeper-trayicon-patcher%2Fblob%2Fmain%2FtrayIcon.png) (or provide your own)
- download [`trayUnreadIcon.png`](https://git-link.vercel.app/api/download?url=https%3A%2F%2Fgithub.com%2FDavidBevi%2Fbeeper-trayicon-patcher%2Fblob%2Fmain%2FtrayUnreadIcon.png) (or provide your own)
- download `appimagetool.AppImage` [`[EXT SOURCE]`](https://github.com/AppImage/appimagetool/releases/tag/continuous)
- download `Beeper.AppImage` [`[EXT SOURCE]`](https://beeper.com)

### Usage
- `[GUI]` double-click on `patch.sh`, or drag-n-drop `Beeper.AppImage` onto `patch.sh`
- `[CLI]` `source patch.sh` or `source patch.sh "path/to/Beeper.AppImage"`

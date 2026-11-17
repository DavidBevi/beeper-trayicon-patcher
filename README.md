# beeper-trayicon-patcher<br><sub><sup>A script to customize the systray icons of Beeper AppImage (Linux)</sup></sub>

![Demo gif](./bpr-patcher-demo.gif)

## Prep
- install the dependency `asar` [`[github/asar]`](https://github.com/electron/asar)

Then put in a directory of your choice:
- `Beeper*.AppImage` from your PC or from [`[beeper.com]`](https://beeper.com)
- `trayIcon.png` of your own or [download mine](https://git-link.vercel.app/api/download?url=https%3A%2F%2Fgithub.com%2FDavidBevi%2Fbeeper-trayicon-patcher%2Fblob%2Fmain%2FtrayIcon.png)
- `trayUnreadIcon.png` of your own or [download mine](https://git-link.vercel.app/api/download?url=https%3A%2F%2Fgithub.com%2FDavidBevi%2Fbeeper-trayicon-patcher%2Fblob%2Fmain%2FtrayUnreadIcon.png)
- `appimagetool.AppImage` from [`[github/appimagetool]`](https://github.com/AppImage/appimagetool/releases/tag/continuous)
- `beeper-trayicon-patcher.sh`: [DOWNLOAD](https://git-link.vercel.app/api/download?url=https%3A%2F%2Fgithub.com%2FDavidBevi%2Fbeeper-trayicon-patcher%2Fblob%2Fmain%2Fbeeper-trayicon-patcher.sh) and make it executable with one of these methods:
  - `[GUI]`: use your file-manager to open the file-properties, find something like `[ ] Allow execution`, enable it
  - `[CLI]`: `chmod +x "/path/to/beeper-trayicon-patcher.sh"`

## Usage options
- `[GUI]`: double-click `beeper-trayicon-patcher.sh` to use the files in the same directory
- `[GUI]`: select the required files, drag-n-drop them onto `beeper-trayicon-patcher.sh`
- `[CLI]` directly: `"/path/to/beeper-trayicon-patcher.sh" [-h] [-f] [-o="/path/to/outputfile.AppImage"]`
- `[CLI]` sourcing: `. "/path/to/beeper-trayicon-patcher.sh" [-h] [-f] [-o="/path/to/outputfile.AppImage"]`

## Optional arguments (`CLI`)
- `-h` or `--help` to print the help page (and return)
- `--forced` or `-f` to skip confirmation prompt and patch directly
- `--out=/file/path` or `-o=/file/path` to use a custom filename for the output

----

<img width="600" height="600" alt="beeper systray icon drake meme" src="https://github.com/user-attachments/assets/55d02c30-a18c-432e-84ff-c4d6df6bc8a7" />
